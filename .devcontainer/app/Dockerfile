FROM ubuntu:24.04

# Args : Iy you need, you can change. 
ARG PYTHON_VERSION=3.12.3
ARG NODE_VERSION=22.15.0

# Environment
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8

WORKDIR /workspaces

# Install tools & fonts
RUN apt-get update && apt-get install -y --no-install-recommends \
    tree git wget axel bash ca-certificates locales xz-utils gnupg lsb-release curl software-properties-common \
    fonts-ipafont-gothic fonts-noto-cjk \
    build-essential libssl-dev zlib1g-dev libncurses-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev liblzma-dev tk-dev

# Set up JP-env
RUN apt-get update && \
    locale-gen ja_JP.UTF-8 && \
    update-locale LANG=ja_JP.UTF-8

# Install Python
RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar -xzf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations && \
    make -j"$(nproc)" && \
    make altinstall && \
    cd .. && rm -rf Python-${PYTHON_VERSION}*

# Set up Python3.12
RUN update-alternatives --install /usr/bin/python python /usr/local/bin/python${PYTHON_VERSION%.*} 100 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python${PYTHON_VERSION%.*} 100 && \
    python -m ensurepip --upgrade && \
    python -m pip install --upgrade pip && \
    ln -sf /usr/local/bin/pip${PYTHON_VERSION%.*} /usr/bin/pip && \
    ln -sf /usr/local/bin/pip${PYTHON_VERSION%.*} /usr/bin/pip3

# Remove extra packages
RUN apt-get purge -y build-essential libssl-dev zlib1g-dev libncurses-dev \
    libreadline-dev libffi-dev libsqlite3-dev libbz2-dev liblzma-dev tk-dev && \
    apt-get autoremove -y

# Install nvm (Node Version Manager)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Install Node.js with nvm
RUN bash -c "source /root/.nvm/nvm.sh && \
    nvm install ${NODE_VERSION}"

# Install Python package
COPY ./app/requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Clean up
RUN apt-get clean && \
    rm -rf /var/cache/apt/archives/* && \
    rm -rf /var/lib/apt/lists/*

COPY ./.devcontainer/entrypoint.sh /opt/entrypoint.sh

CMD [ "bash" ]
