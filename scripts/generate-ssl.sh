#!/bin/sh
CERT_DIR="/var/lib/postgresql"
CERT_FILE="$CERT_DIR/server.crt"
KEY_FILE="$CERT_DIR/server.key"

# Use POSTGRES_DOMAIN env var if set, otherwise fallback
CN="${POSTGRES_DOMAIN:-dublyo-postgres}"

if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
    echo "Generating self-signed SSL certificate for $CN..."
    openssl req -new -x509 -days 3650 -nodes \
        -out "$CERT_FILE" \
        -keyout "$KEY_FILE" \
        -subj "/CN=$CN" \
        -addext "subjectAltName=DNS:$CN"
    chown postgres:postgres "$CERT_FILE" "$KEY_FILE"
    chmod 600 "$KEY_FILE"
    chmod 644 "$CERT_FILE"
    echo "SSL certificate generated for $CN."
fi
