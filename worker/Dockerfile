FROM ubuntu:22.04

# Avoid tzdata interactive prompts during apt-get install
ENV DEBIAN_FRONTEND=noninteractive

ENV FLAMENCO_VERSION="3.8.2"
ENV FLAMENCO_URL="https://flamenco.blender.org/downloads/flamenco-${FLAMENCO_VERSION}-linux-amd64.tar.gz"

# Blender version to install
ENV BLENDER_VERSION="4.3.2"
ENV BLENDER_TAR="blender-${BLENDER_VERSION}-linux-x64.tar.xz"
ENV BLENDER_URL="https://download.blender.org/release/Blender4.3/${BLENDER_TAR}"

# Install dependencies for downloading and running headless Blender
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    xz-utils \
    ca-certificates \
    libx11-6 \
    libxi6 \
    libxrender1 \
    libxxf86vm1 \
    libxfixes3 \
    libgl1 \
    libxkbcommon0 \
    && rm -rf /var/lib/apt/lists/*

# Download and install Blender
RUN wget -q ${BLENDER_URL} && \
    tar -xf ${BLENDER_TAR} -C /usr/local/ && \
    mv /usr/local/blender-${BLENDER_VERSION}-linux-x64 /usr/local/blender && \
    rm ${BLENDER_TAR}

# Download and install Flamenco
RUN wget -qO- ${FLAMENCO_URL} | tar -xz -C /opt && \
    mv /opt/flamenco-${FLAMENCO_VERSION}-linux-amd64 /opt/flamenco

# Provide the path to the Blender executable in the environment
ENV BLENDER_EXECUTABLE="/usr/local/blender/blender"
ENV PATH="/usr/local/blender:${PATH}"

WORKDIR /mnt/shared-bucket/config

ENTRYPOINT ["/opt/flamenco/flamenco-worker"]
