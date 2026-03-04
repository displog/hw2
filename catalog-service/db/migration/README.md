# Flyway migrations

Миграции выполняются автоматически при `docker-compose up` (сервис flyway) или `.\start_all.ps1` (Docker).

**Существующая БД от Alembic:** если схема уже создана, выполни:
```bash
flyway baseline -baselineVersion=4
```
или пересоздай БД для чистой установки.
