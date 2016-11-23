FROM        debian:jessie

MAINTAINER  Roman Lakhtadyr <roman.lakhtadyr@gmail.com>

ENV         DEBIAN_FRONTEND=noninteractive

ARG         PHP_VERSION=7.0

RUN         apt-key adv --fetch-keys http://www.dotdeb.org/dotdeb.gpg && \

            echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb.list && \
            echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb.list && \

            apt-get update && \
            apt-get install -y --no-install-recommends \
              ca-certificates \
              curl \
              supervisor \
              nginx \
              php${PHP_VERSION} \
              php${PHP_VERSION}-fpm && \
            apt-get clean && \

            rm /etc/nginx/sites-available/default \
               /etc/nginx/sites-enabled/default && \

            mkdir -p /var/app/public && \

            curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY        supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY        nginx-server.conf /etc/nginx/sites-available/nginx-server.conf
COPY        index.php /var/app/public/index.php

RUN         ln -s /etc/nginx/sites-available/nginx-server.conf /etc/nginx/sites-enabled/nginx-server.conf

EXPOSE      80
CMD         ["/usr/bin/supervisord"]
