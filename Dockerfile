ARG PG_VERSION=16
FROM postgres:${PG_VERSION}-alpine

# Alpine uses ash/sh, not bash — all scripts must use #!/bin/sh
RUN apk add --no-cache openssl

# Install pgvector from source
# with_llvm=no skips LLVM bitcode compilation (JIT optimization — not needed)
RUN apk add --no-cache --virtual .build-deps git build-base && \
    cd /tmp && \
    git clone --branch v0.8.0 https://github.com/pgvector/pgvector.git && \
    cd pgvector && \
    make USE_PGXS=1 with_llvm=no && make USE_PGXS=1 with_llvm=no install && \
    cd / && rm -rf /tmp/pgvector && \
    apk del .build-deps

# Install PostGIS
RUN apk add --no-cache \
    --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main \
    postgis

# Copy scripts — all use #!/bin/sh (NOT bash)
COPY scripts/docker-entrypoint-wrapper.sh /usr/local/bin/docker-entrypoint-wrapper.sh
COPY scripts/generate-ssl.sh /usr/local/bin/generate-ssl.sh
COPY docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/
COPY pg_hba_ssl.conf /etc/postgresql/pg_hba_ssl.conf

RUN chmod +x /usr/local/bin/docker-entrypoint-wrapper.sh \
    /usr/local/bin/generate-ssl.sh \
    /docker-entrypoint-initdb.d/*.sh || true

ENTRYPOINT ["docker-entrypoint-wrapper.sh"]
CMD ["postgres"]
