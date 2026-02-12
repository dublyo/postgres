#!/bin/sh
# Copy SSL-enforcing pg_hba.conf after initdb creates PGDATA
if [ -f /etc/postgresql/pg_hba_ssl.conf ]; then
    cp /etc/postgresql/pg_hba_ssl.conf "$PGDATA/pg_hba.conf"
    echo "pg_hba.conf: SSL enforcement enabled"
fi
