FROM debian:bookworm

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends nginx && \
    rm -rf /var/lib/apt/lists/*

RUN rm -f /etc/nginx/sites-enabled/default

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /var/www/static/index.html
COPY index.css /var/www/static/index.css
COPY assets /var/www/static/assets

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
