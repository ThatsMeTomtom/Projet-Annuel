FROM alpine:3.19

RUN apk add --no-cache dovecot dovecot-lmtpd dovecot-pop3d \
    && mkdir -p /var/mail \
    && addgroup -g 5000 vmail \
    && adduser -D -u 5000 -G vmail -h /var/mail vmail \
    && chown vmail:vmail /var/mail

COPY conf/dovecot.conf /etc/dovecot/dovecot.conf
COPY conf/10-auth.conf conf/10-mail.conf conf/10-ssl.conf conf/10-master.conf /etc/dovecot/conf.d/

EXPOSE 143 993 110 995 24

VOLUME ["/var/mail", "/etc/dovecot/certs", "/etc/dovecot/users"]

CMD ["dovecot", "-F"]
