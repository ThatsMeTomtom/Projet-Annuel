FROM alpine:3.19

RUN apk add --no-cache dovecot dovecot-lmtpd dovecot-pop3d dovecot-ldap \
    && mkdir -p /var/mail \
    && addgroup -g 5000 vmail \
    && adduser -D -u 5000 -G vmail -h /var/mail vmail \
    && chown vmail:vmail /var/mail

COPY conf/dovecot.conf /etc/dovecot/dovecot.conf
COPY conf/10-auth.conf conf/10-mail.conf conf/10-ssl.conf conf/10-master.conf conf/10-namespace.conf /etc/dovecot/conf.d/
COPY conf/dovecot-ldap.conf /etc/dovecot/dovecot-ldap.conf

EXPOSE 143 993 110 995 24

CMD ["sh", "-c", "chown vmail:vmail /var/mail && dovecot -F"]
