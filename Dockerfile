FROM certbot/certbot

LABEL maintainer="nizovtsevnv@gmail.com"

ENV DOMAINS=""
ENV EMAIL=""

VOLUME /etc/letsencrypt
VOLUME /webroot

ENTRYPOINT for domain in ${DOMAINS}; do echo "Processing $domain..."; certbot -t certonly --webroot --agree-tos --non-interactive -w /webroot -m ${EMAIL} -d $domain; done; \
  while true; do certbot renew -q; sleep 10h; done
