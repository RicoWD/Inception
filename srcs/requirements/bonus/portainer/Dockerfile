FROM debian:bookworm

ARG PORTAINER_VERSION=2.21.5

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends wget ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN ARCH=$(dpkg --print-architecture) && \
    wget -q "https://github.com/portainer/portainer/releases/download/${PORTAINER_VERSION}/portainer-${PORTAINER_VERSION}-linux-${ARCH}.tar.gz" -O /tmp/portainer.tar.gz && \
    tar -xzf /tmp/portainer.tar.gz -C /opt && \
    rm /tmp/portainer.tar.gz

COPY tools/portainer.sh /usr/local/bin/portainer.sh
RUN chmod +x /usr/local/bin/portainer.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/portainer.sh"]
