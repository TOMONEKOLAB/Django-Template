FROM ubuntu:24.04

# Environment 
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8

WORKDIR /workspaces

# Install tools & fonts
RUN apt-get update && apt-get install -y --no-install-recommends \
    tree git wget axel bash ca-certificates locales xz-utils gnupg lsb-release curl software-properties-common\
    fonts-ipafont-gothic fonts-noto-cjk

# Set up JP-env
RUN apt-get update && \
    locale-gen ja_JP.UTF-8 && \
    update-locale LANG=ja_JP.UTF-8

# Install Nginx
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx

# Clean up
RUN apt-get clean && \
    rm -rf /var/cache/apt/archives/* && \
    rm -rf /var/lib/apt/lists/*

COPY web/default.conf /etc/nginx/conf.d/default.conf

COPY ./.devcontainer/entrypoint.sh /opt/entrypoint.sh

CMD [ "bash" ]
