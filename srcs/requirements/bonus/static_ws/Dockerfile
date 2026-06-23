FROM debian:bookworm

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends nginx gettext-base && \
    rm -rf /var/lib/apt/lists/*

RUN rm -f /etc/nginx/sites-enabled/default

COPY conf/nginx.conf /etc/nginx/templates/default.conf.template
COPY tools/static_ws.sh /usr/local/bin/static_ws.sh
COPY index.html /var/www/static/index.html
COPY index.css /var/www/static/index.css
COPY assets /var/www/static/assets

RUN chmod +x /usr/local/bin/static_ws.sh

ENTRYPOINT ["/usr/local/bin/static_ws.sh"]
