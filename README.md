# Dublyo Postgres

Production-ready PostgreSQL Docker image with SSL encryption, popular extensions, and performance tuning.

Built for [Dublyo](https://dublyo.xyz) PaaS — auto-deployed to Hetzner Cloud servers via Portainer.

## Versions

| Tag | Base Image |
|-----|-----------|
| `ghcr.io/dublyo/postgres:16` | `postgres:16-alpine` |
| `ghcr.io/dublyo/postgres:17` | `postgres:17-alpine` |
| `ghcr.io/dublyo/postgres:18` | `postgres:18-alpine` |

## Features

- **SSL enforced** — self-signed cert auto-generated on first start, plaintext connections rejected
- **pgvector** — AI vector embeddings (`CREATE EXTENSION vector`)
- **PostGIS** — geospatial queries (`CREATE EXTENSION postgis`)
- **Pre-installed extensions** — uuid-ossp, pgcrypto, citext, hstore, pg_trgm, pg_stat_statements
- **Conditional extensions** — pass `POSTGRES_EXTENSIONS=pgvector,postgis` to enable extras on init

## Usage

```yaml
services:
  postgres:
    image: ghcr.io/dublyo/postgres:17
    environment:
      POSTGRES_USER: myuser
      POSTGRES_PASSWORD: mypassword
      POSTGRES_DB: mydb
      POSTGRES_EXTENSIONS: "pgvector"
    command: >
      postgres
        -c ssl=on
        -c ssl_cert_file=/var/lib/postgresql/server.crt
        -c ssl_key_file=/var/lib/postgresql/server.key
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `POSTGRES_USER` | Superuser name | `postgres` |
| `POSTGRES_PASSWORD` | Superuser password | (required) |
| `POSTGRES_DB` | Default database | `postgres` |
| `POSTGRES_EXTENSIONS` | Comma-separated extras: `pgvector`, `postgis` | `none` |

## SSL

SSL is enforced via `pg_hba_ssl.conf`:
- `hostssl` connections accepted (with scram-sha-256 auth)
- Plain `host` connections rejected
- `local` (unix socket) connections trusted

Connect with `sslmode=require`:
```
postgresql://user:pass@host:5432/db?sslmode=require
```

## Build Locally

```bash
docker build --build-arg PG_VERSION=17 -t dublyo/postgres:17 .
```
