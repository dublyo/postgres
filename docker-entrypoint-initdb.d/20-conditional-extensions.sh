#!/bin/sh
set -e

# Parse POSTGRES_EXTENSIONS env var (comma-separated)
# Example: POSTGRES_EXTENSIONS=pgvector,postgis

if [ -z "$POSTGRES_EXTENSIONS" ] || [ "$POSTGRES_EXTENSIONS" = "none" ]; then
    echo "No additional extensions requested."
    exit 0
fi

# POSIX-compatible comma splitting (no bash arrays)
echo "$POSTGRES_EXTENSIONS" | tr ',' '\n' | while read -r ext; do
    ext=$(echo "$ext" | xargs)  # trim whitespace
    case "$ext" in
        pgvector|vector)
            echo "Enabling pgvector..."
            psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
                -c "CREATE EXTENSION IF NOT EXISTS vector;"
            ;;
        postgis)
            echo "Enabling PostGIS..."
            psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
                -c "CREATE EXTENSION IF NOT EXISTS postgis;"
            ;;
        *)
            echo "Unknown extension: $ext (skipping)"
            ;;
    esac
done
