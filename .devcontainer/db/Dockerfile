FROM ubuntu:24.04

# Args : Iy you need, you can change. 
ARG POSTGRE_VERSION=17

# Environment 
ENV PATH="/usr/lib/postgresql/${POSTGRE_VERSION}/bin:${PATH}"
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

# Add PostgreSQL official repository
RUN install -d /usr/share/postgresql-common/pgdg && \
    curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc && \
    echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Install PostgreSQL
RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-${POSTGRE_VERSION} postgresql-client-${POSTGRE_VERSION}

# Clean up
RUN apt-get clean && \
    rm -rf /var/cache/apt/archives/* && \
    rm -rf /var/lib/apt/lists/*

COPY ./.devcontainer/entrypoint.sh /opt/entrypoint.sh

CMD [ "bash" ]
