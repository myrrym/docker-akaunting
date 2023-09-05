FROM php:8.2-fpm-buster

WORKDIR /app

ENV SED_DB_CONNECTION=mysql \
    SED_DB_HOST=joget-test-unit \
    SED_DB_PORT=3306 \
    SED_DB_DATABASE=akaunting_docker \
    SED_DB_USERNAME=root \
    SED_DB_PASSWORD=123123

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY --from=mlocati/php-extension-installer:latest /usr/bin/install-php-extensions /usr/bin/

COPY composer.json composer.lock package.json package-lock.json ./

RUN install-php-extensions \
        zip \
        gd \
        bcmath \
        intl \
        opcache \
        mbstring \
        pdo_mysql \
        pdo_pgsql && \
    apt update && \
    apt install --yes \
        nginx nano && \
    rm --force --recursive /var/lib/apt/lists/*

COPY . .
COPY ./nginx.example.com.conf /etc/nginx/sites-enabled/default

RUN composer install --no-scripts && \
    cp .env.example .env && \
    sed -i -r "s|SED_DB_CONNECTION|${SED_DB_CONNECTION}|g" .env && \
    sed -i -r "s|SED_DB_HOST|${SED_DB_HOST}|g" .env && \
    sed -i -r "s|SED_DB_PORT|${SED_DB_PORT}|g" .env && \
    sed -i -r "s|SED_DB_DATABASE|${SED_DB_DATABASE}|g" .env && \
    sed -i -r "s|SED_DB_USERNAME|${SED_DB_USERNAME}|g" .env && \
    sed -i -r "s|SED_DB_PASSWORD|${SED_DB_PASSWORD}|g" .env && \
    chown -R www-data:www-data ../app 

CMD ["./start.sh"]

EXPOSE 80
