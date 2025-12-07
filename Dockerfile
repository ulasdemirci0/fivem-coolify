FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies + openssh-server
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    xz-utils \
    mariadb-client \
    ca-certificates \
    iproute2 \
    tini \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

# Configure SSH to allow root login with password
RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

WORKDIR /opt/fivem

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]