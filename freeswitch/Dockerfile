# Multi-stage build: compile FreeSWITCH from source
FROM debian:bookworm-slim AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    cmake \
    automake \
    autoconf \
    libtool \
    libtool-bin \
    pkg-config \
    libssl-dev \
    zlib1g-dev \
    libdb-dev \
    libncurses5-dev \
    libexpat1-dev \
    libgdbm-dev \
    libreadline-dev \
    libedit-dev \
    libsqlite3-dev \
    libcurl4-openssl-dev \
    libpcre3-dev \
    libspeex-dev \
    libspeexdsp-dev \
    libldns-dev \
    libedit-dev \
    libtiff5-dev \
    yasm \
    nasm \
    libopus-dev \
    libsndfile1-dev \
    libavformat-dev \
    libswscale-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone FreeSWITCH source (v1.10 branch)
WORKDIR /usr/src
RUN git clone -b v1.10 https://github.com/signalwire/freeswitch.git freeswitch

WORKDIR /usr/src/freeswitch

# Bootstrap and configure
RUN ./bootstrap.sh -j && \
    ./configure \
    --prefix=/usr/local/freeswitch \
    --enable-core-pgsql-support \
    --disable-core-odbc-support \
    --disable-libvpx \
    --disable-libyuv

# Build and install (this takes ~15-20 minutes)
RUN make -j$(nproc) && make install

# Runtime stage - minimal image
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    libssl3 \
    libpcre3 \
    libspeex1 \
    libspeexdsp1 \
    libldns3 \
    libedit2 \
    libsqlite3-0 \
    libcurl4 \
    libtiff6 \
    libopus0 \
    libsndfile1 \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

# Copy compiled FreeSWITCH from builder
COPY --from=builder /usr/local/freeswitch /usr/local/freeswitch

# Add FreeSWITCH binaries to PATH
ENV PATH="/usr/local/freeswitch/bin:${PATH}"

# Copy custom configuration
COPY config/ /usr/local/freeswitch/etc/

# SIP port for media server (Kamailio → FreeSWITCH)
# ESL control port (internal)
EXPOSE 5080/udp 5080/tcp 8021/tcp

WORKDIR /usr/local/freeswitch

CMD ["/usr/local/freeswitch/bin/freeswitch", "-nf", "-nonat", "-c"]
