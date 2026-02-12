#!/bin/sh
set -e

# Generate self-signed SSL cert if not already present (runs every start)
/usr/local/bin/generate-ssl.sh

# Copy SSL-enforcing pg_hba.conf into the data directory
# This runs every start so it survives volume recreation
if [ -d "$PGDATA" ] && [ -f /etc/postgresql/pg_hba_ssl.conf ]; then
    cp /etc/postgresql/pg_hba_ssl.conf "$PGDATA/pg_hba.conf"
fi

# Delegate to original Postgres entrypoint
exec docker-entrypoint.sh "$@"
