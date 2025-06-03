
FROM composer:2.7 AS build

WORKDIR /app

COPY composer.json composer.lock ./
RUN composer install --no-dev --prefer-dist --no-scripts --no-plugins --no-interaction --optimize-autoloader

COPY . .

FROM php:8.2-fpm-alpine


RUN apk add --no-cache \
    bash curl \
    php-bcmath php-curl php-mbstring php-mysqlnd \
    php-opcache php-pdo php-pdo_mysql php-tokenizer \
    php-xml php-ctype php-fileinfo php-json php-phar \
    php-openssl php-simplexml php-dom php-session

WORKDIR /var/www
COPY --from=build /app /var/www
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage /var/www/bootstrap/cache


EXPOSE 9000

CMD ["php-fpm"]
