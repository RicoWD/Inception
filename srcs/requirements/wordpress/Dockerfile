FROM debian:bookworm

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        wget \
        curl \
        php-fpm \
        php-mysql \
        mariadb-client \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

COPY ./tools/wp_script.sh /usr/local/bin/wp_script.sh

RUN chmod +x /usr/local/bin/wp_script.sh && \
    mkdir -p /var/www/html/wordpress

WORKDIR /var/www/html/wordpress

ENTRYPOINT ["/usr/local/bin/wp_script.sh"]
