FROM alpine:3.19

RUN apk add --no-cache postfix postfix-pcre cyrus-sasl cyrus-sasl-digestmd5 \
    && mkdir -p /var/spool/postfix

COPY conf/main.cf /etc/postfix/main.cf
COPY conf/master.cf /etc/postfix/master.cf
COPY conf/virtual /etc/postfix/virtual

EXPOSE 25 587

CMD ["sh", "-c", "postmap /etc/postfix/virtual && postfix start-fg"]
