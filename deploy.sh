#!/bin/sh
set -e

DOMAIN=${1:?"Usage: ./deploy.sh <domain> <username> <password>"}
USERNAME=${2:?"Usage: ./deploy.sh <domain> <username> <password>"}
PASSWORD=${3:?"Usage: ./deploy.sh <domain> <username> <password>"}
HOSTNAME="mail.$DOMAIN"

echo "==> Creating directories..."
mkdir -p certs mail

echo "==> Generating TLS certificate for $HOSTNAME..."
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout certs/server.key \
  -out certs/server.crt \
  -subj "/CN=$HOSTNAME" 2>/dev/null

echo "==> Hashing password..."
HASH=$(docker run --rm alpine sh -c \
  "apk add -q openssl && echo '$PASSWORD' | openssl passwd -6 -stdin")
echo "$USERNAME:$DOMAIN:{SHA512-CRYPT}$HASH" > users

echo "==> Writing Postfix virtual mailbox map..."
echo "$USERNAME@$DOMAIN  $USERNAME@$DOMAIN" > postfix/conf/virtual

echo "==> Patching Postfix main.cf with domain..."
sed -i "s/POSTFIX_HOSTNAME/$HOSTNAME/g" postfix/conf/main.cf
sed -i "s/POSTFIX_DOMAIN/$DOMAIN/g" postfix/conf/main.cf

echo "==> Building and starting containers..."
docker compose up -d --build

echo ""
echo "Done. Mail server running for $DOMAIN"
echo ""
echo "  SMTP (inbound):   $HOSTNAME:25"
echo "  SMTP (submit):    $HOSTNAME:587  (STARTTLS + auth)"
echo "  IMAP:             $HOSTNAME:993  (SSL)"
echo "  POP3:             $HOSTNAME:995  (SSL)"
echo ""
echo "  Login: $USERNAME@$DOMAIN / $PASSWORD"
