FROM alpine:3.19

RUN apk add --no-cache postfix postfix-pcre cyrus-sasl cyrus-sasl-digestmd5 busybox-extras \
    && mkdir -p /var/spool/postfix

COPY conf/main.cf /etc/postfix/main.cf
COPY conf/master.cf /etc/postfix/master.cf
COPY conf/virtual /etc/postfix/virtual

EXPOSE 25 587

CMD ["sh", "-c", "syslogd && mkdir -p /var/log && touch /var/log/mail.log && postmap /etc/postfix/virtual && postfix start && tail -f /var/log/mail.log"]
