FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends vsftpd gettext-base && rm -rf /var/lib/apt/lists/*

COPY conf/vsftpd.conf /etc/vsftpd.conf.template
COPY tools/ftp.sh /usr/local/bin/ftp.sh

RUN chmod +x /usr/local/bin/ftp.sh

EXPOSE 21 21100-21110

ENTRYPOINT ["/usr/local/bin/ftp.sh"]
