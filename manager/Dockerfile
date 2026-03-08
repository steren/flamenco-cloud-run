FROM debian:bullseye-slim

ENV FLAMENCO_VERSION="3.8.2"
ENV FLAMENCO_URL="https://flamenco.blender.org/downloads/flamenco-${FLAMENCO_VERSION}-linux-amd64.tar.gz"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN wget -qO- ${FLAMENCO_URL} | tar -xz -C /opt && \
    mv /opt/flamenco-${FLAMENCO_VERSION}-linux-amd64 /opt/flamenco

# The working directory is intended to be overridden by Cloud Run to /mnt/shared-bucket/config
# but we set a default here.
WORKDIR /opt/flamenco

# Expose port (must match the config)
EXPOSE 8080

ENTRYPOINT ["/opt/flamenco/flamenco-manager"]
