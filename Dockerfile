FROM ubuntu:latest AS builder
RUN apt-get update
RUN apt-get install -y wget zip
RUN wget -O limesurvey.zip https://download.limesurvey.org/latest-stable-release/limesurvey5.6.2+230125.zip
RUN unzip limesurvey.zip

FROM php:7.4-apache
LABEL org.opencontainers.image.authors="yudhistira.wibowo@itsmeyaw.id"

RUN apt-get upgrade && apt-get update

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN apt-get install php7.4-mbstring

RUN sed -i "s|short_open_tag = Off|short_open_tag = On|g" "$PHP_INI_DIR/php.ini"
RUN sed -i "s|mbstring.func_overload = *|mbstring.func_overload = 0|g" "$PHP_INI_DIR/php.ini"

RUN sed -i "s|#ServerName www.example.com|ServerName \${LIMESURVEY_DOMAIN}|g" /etc/apache2/sites-available/*.conf
RUN sed -i "s|ServerAdmin webmaster@localhost|ServerAdmin \${LIMESURVEY_ADMIN_EMAIL}|g" /etc/apache2/sites-available/*.conf

COPY --from=builder limesurvey /var/www/html

RUN chmod -R 555 "/var/www/html/admin"
RUN chmod -R 755 "/var/www/html/tmp" "/var/www/html/upload" "/var/www/html/application/config"

RUN apt-get clean


