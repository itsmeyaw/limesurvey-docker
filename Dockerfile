FROM ubuntu:latest AS builder
RUN apt-get update
RUN apt-get install -y wget zip
RUN wget -O limesurvey.zip https://download.limesurvey.org/latest-stable-release/limesurvey5.6.2+230125.zip
RUN unzip limesurvey.zip

FROM php:apache
LABEL org.opencontainers.image.authors="yudhistira.wibowo@itsmeyaw.id"

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN sed -ri -e 's!#ServerName www.example.com!ServerName \${LIMESURVEY_DOMAIN}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!ServerAdmin webmaster@localhost!ServerAdmin \${LIMESURVEY_ADMIN_EMAIL}!g' /etc/apache2/sites-available/*.conf

COPY --from=builder limesurvey /var/www/html

RUN chmod -R 444 "/var/www/html/admin"
RUN chmod -R 755 "/var/www/html/tmp" "/var/www/html/upload" "/var/www/html/application/config"


