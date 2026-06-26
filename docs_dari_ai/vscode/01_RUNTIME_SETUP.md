# Runtime Setup - dasar-python

## Container utama

- App: `dasar_python_app` (port `8007:8000`)
- MySQL (shared): `mysql-main` (port `3306`)
- Redis (shared): `redis-main` (port `6379`)

## Compose yang dipakai

- `projects/dasar-python/docker-compose.yml`

Jalankan dari folder project:

```bash
docker compose -f docker-compose.yml up -d
```

## Env penting (ringkas)

- MySQL: `DB_HOST=mysql-main`, `DB_NAME=dasar_python_db`
- Redis: `REDIS_HOST=redis-main`, `REDIS_DB=3`

