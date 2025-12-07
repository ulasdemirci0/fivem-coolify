# We use Debian Slim (approx 30MB) instead of Alpine because FiveM requires glibc.
# Alpine (musl) causes segmentation faults with FXServer.
FROM debian:bookworm-slim

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies:
# - curl/wget: To download FiveM artifacts
# - git: To clone server data
# - xz-utils: To extract FiveM artifacts
# - mariadb-client: To manage the database from this container
# - iproute2/ca-certificates: Required by FiveM
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    xz-utils \
    mariadb-client \
    ca-certificates \
    iproute2 \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt/fivem

# Copy the entrypoint script into the container
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh

# Make the script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# The entrypoint script will handle startup
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]