FROM        debian:jessie

MAINTAINER  Roman Lakhtadyr <roman.lakhtadyr@gmail.com>

ARG         PHP_VERSION=7.0
ARG         PHP_INI_FILES="/etc/php/${PHP_VERSION}/fpm/php.ini \
                           /etc/php/${PHP_VERSION}/cli/php.ini"

ENV         DEBIAN_FRONTEND=noninteractive


VOLUME      /var/lib/php/sessions

COPY        supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY        nginx-server.conf /etc/nginx/sites-available/nginx-server.conf
COPY        index.php /var/app/public/index.php

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

            curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \

            sed -i 's/.*post_max_size.*/post_max_size = 256M/;\
                    s/.*upload_max_filesize.*/upload_max_filesize = 256M/;\
                    s/.*max_file_uploads.*/max_file_uploads = 1/' \
                    ${PHP_INI_FILES} && \

            ln -s /etc/nginx/sites-available/nginx-server.conf /etc/nginx/sites-enabled/nginx-server.conf

EXPOSE      80
CMD         ["/usr/bin/supervisord"]
