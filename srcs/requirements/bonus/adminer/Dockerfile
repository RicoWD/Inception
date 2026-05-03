FROM debian:bookworm

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends php-cli php-mbstring wget && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/adminer
RUN wget -q https://www.adminer.org/latest.php -O /var/www/adminer/index.php

COPY tools/adminer.sh /usr/local/bin/adminer.sh
RUN chmod +x /usr/local/bin/adminer.sh

WORKDIR /var/www/adminer

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/adminer.sh"]
