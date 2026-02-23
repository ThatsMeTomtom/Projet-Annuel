#!/bin/sh
set -e

DOMAIN=${1:?"Usage: ./deploy.sh <domain> <username> <password>"}
USERNAME=${2:?"Usage: ./deploy.sh <domain> <username> <password>"}
PASSWORD=${3:?"Usage: ./deploy.sh <domain> <username> <password>"}

echo "==> Creating directories..."
mkdir -p certs mail

echo "==> Generating self-signed TLS certificate for $DOMAIN..."
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout certs/server.key \
  -out certs/server.crt \
  -subj "/CN=$DOMAIN" 2>/dev/null

echo "==> Hashing password..."
HASH=$(docker run --rm alpine sh -c \
  "apk add -q openssl && echo '$PASSWORD' | openssl passwd -6 -stdin")
echo "$USERNAME:{SHA512-CRYPT}$HASH" > users

echo "==> Building and starting Dovecot..."
docker compose up -d --build

echo ""
echo "Done. Dovecot is running."
echo "  Domain:   $DOMAIN"
echo "  User:     $USERNAME"
echo "  IMAP:     $DOMAIN:143 (STARTTLS) / $DOMAIN:993 (SSL)"
echo "  POP3:     $DOMAIN:110 (STARTTLS) / $DOMAIN:995 (SSL)"
echo "  LMTP:     $DOMAIN:24"
