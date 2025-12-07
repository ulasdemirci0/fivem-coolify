FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for FiveM and MariaDB client
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    xz-utils \
    mariadb-client \
    ca-certificates \
    iproute2 \
    tini \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/fivem

# Copy entrypoint
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Tini ensures signals (like Ctrl+C) are handled correctly
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]