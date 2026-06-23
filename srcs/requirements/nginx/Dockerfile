# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: erpascua <erpascua@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/04/30 16:16:12 by erpascua          #+#    #+#              #
#    Updated: 2026/04/30 16:16:15 by erpascua         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:bookworm

ARG LOGIN

RUN apt-get update -y \
    && apt-get install -y nginx openssl gettext-base \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes \
    -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=${LOGIN}.42.fr/UID=${LOGIN}"

COPY conf/nginx.conf /etc/nginx/templates/default.conf.template
COPY tools/nginx.sh /usr/local/bin/nginx.sh

RUN chmod +x /usr/local/bin/nginx.sh

ENTRYPOINT ["/usr/local/bin/nginx.sh"]
