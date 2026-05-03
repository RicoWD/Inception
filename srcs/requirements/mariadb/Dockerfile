# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: erpascua <erpascua@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/04/30 16:15:34 by erpascua          #+#    #+#              #
#    Updated: 2026/04/30 16:15:35 by erpascua         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:bookworm

RUN apt update && apt install -y --no-install-recommends mariadb-server && apt clean && rm -rf /var/lib/apt/lists/*

COPY ./tools/mariadb.sh /usr/local/bin

RUN chmod +x /usr/local/bin/mariadb.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/mariadb.sh"]
