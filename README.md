# Certbot (webroot + environment variables)

This is a repository of Docker preconfigured Certbot image with automated building.

### Features
* only "webroot" mode (for using with web servers like Nginx, Apache...)
* configuration over environment variables
* need to be 2 shared volumes (certs, web folder) between web server and certbot

### Usage
```
docker run -d \
  -e DOMAINS=MY1.DOMAIN MY2.DOMAIN ...
  -e EMAIL=MY@EMAIL
  -v certbot_certs:/etc/letsencrypt:rw \
  -v certbot_webroot:/webroot:rw \
  nizovtsevnv/certbot
```
Or, with docker-compose:
```
...
services:
  certbot:
    environment:
      - DOMAINS=MY1.DOMAIN MY2.DOMAIN ...
      - EMAIL=MY@EMAIL
    image: nizovtsevnv/certbot
    volumes:
      -  certbot_certs:/etc/letsencrypt:rw
      -  certbot_webroot:/webroot:rw
...
```

### Nginx configuration

* start Nginx with shared volumes:
```
docker run -d \
  -v certbot_certs:/etc/letsencrypt:ro \
  -v certbot_webroot:/usr/share/nginx/html:ro \
  ...
  nginx:alpine
```
* add settings for verification domains by ACME protocol in HTTP server listeners:
```
location ^~ /.well-known/acme-challenge/ {
  auth_basic off;
  allow all;
  root /usr/share/nginx/html;
  try_files $uri =404;
  break;
}
```
* add settings of SSL certificates in HTTPS server listeners:
```
ssl_certificate /etc/letsencrypt/live/MY1.DOMAIN/cert.pem;
ssl_certificate /etc/letsencrypt/live/MY2.DOMAIN/privkey.pem;
```

### Common information

Certbot is part of EFF’s effort to encrypt the entire Internet. Secure communication over the Web relies on HTTPS, which requires the use of a digital certificate that lets browsers verify the identity of web servers (e.g., is that really google.com?). Web servers obtain their certificates from trusted third parties called certificate authorities (CAs). Certbot is an easy-to-use client that fetches a certificate from Let’s Encrypt—an open certificate authority launched by the EFF, Mozilla, and others—and deploys it to a web server.

Anyone who has gone through the trouble of setting up a secure website knows what a hassle getting and maintaining a certificate is. Certbot and Let’s Encrypt can automate away the pain and let you turn on and manage HTTPS with simple commands. Using Certbot and Let's Encrypt is free, so there’s no need to arrange payment.

Certbot is meant to be run directly on your web server, not on your personal computer. If you’re using a hosted service and don’t have direct access to your web server, you might not be able to use Certbot. Check with your hosting provider for documentation about uploading certificates or using certificates issued by Let’s Encrypt.

To understand what the client is doing in detail, it's important to understand the way it uses plugins. Please see the explanation of plugins in the User Guide.
Links

Documentation: https://certbot.eff.org/docs

Software project: https://github.com/certbot/certbot

Notes for developers: https://certbot.eff.org/docs/contributing.html

Main Website: https://certbot.eff.org

Let's Encrypt Website: https://letsencrypt.org

Community: https://community.letsencrypt.org

ACME spec: http://ietf-wg-acme.github.io/acme/

ACME working area in github: https://github.com/ietf-wg-acme/acme

See https://certbot.eff.org/docs/install.html#system-requirements.

For extensive documentation on using and contributing to Certbot, go to https://certbot.eff.org/docs. If you would like to contribute to the project or run the latest code from git, you should read our developer guide.
