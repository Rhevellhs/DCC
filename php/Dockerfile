FROM composer:2.7 AS composer

WORKDIR /app

COPY composer.* ./
RUN composer install --no-dev --no-scripts --no-plugins --no-interaction --optimize-autoloader


FROM node:20-alpine AS node

WORKDIR /app

COPY package.json vite.config.js ./
COPY resources/ ./resources/

RUN npm install && npm run build

FROM php:8.2-cli-alpine

RUN apk add --no-cache \
    libzip-dev \
    zip \
    && docker-php-ext-install pdo pdo_mysql opcache


WORKDIR /var/www
COPY . .
COPY --from=composer /app/vendor ./vendor
COPY --from=node /app/public/build ./public/build

RUN cp .env.example .env \
    && php artisan key:generate \
    && chmod -R 775 storage bootstrap/cache

RUN php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

EXPOSE 8000

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
