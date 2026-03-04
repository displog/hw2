# Синхронизация сгенерированного кода из контейнера в локальную папку.
# Запускать после: docker compose up --build -d (на Fedora)
# Результат: src/openapi_server/ и src/schemas/generated.py появятся в проекте (для IDE).
#
# Если Docker на Fedora 192.168.88.105:
#   $env:DOCKER_HOST = "tcp://192.168.88.105:2375"
#   или: docker -H 192.168.88.105 cp ...

$ErrorActionPreference = "Stop"
$Container = "marketplace-catalog"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

# Проверка, что контейнер запущен
$running = docker ps --format '{{.Names}}' | Select-String -Pattern "^${Container}$" -Quiet
if (-not $running) {
    Write-Host "Ошибка: контейнер $Container не запущен."
    Write-Host "Сначала выполните на Fedora: cd for-docker && docker compose up --build -d"
    Write-Host ""
    Write-Host "Для копирования с удалённого Docker (Fedora 192.168.88.105):"
    Write-Host "  docker -H 192.168.88.105 cp marketplace-catalog:/app/src/openapi_server src/"
    Write-Host "  docker -H 192.168.88.105 cp marketplace-catalog:/app/src/schemas/generated.py src/schemas/"
    exit 1
}

Write-Host "Копирование openapi_server..."
docker cp "${Container}:/app/src/openapi_server" ./src/

Write-Host "Копирование generated.py..."
if (-not (Test-Path src/schemas)) { New-Item -ItemType Directory -Path src/schemas -Force }
docker cp "${Container}:/app/src/schemas/generated.py" ./src/schemas/

Write-Host "Готово. Сгенерированные файлы доступны в src/openapi_server/ и src/schemas/generated.py"
Write-Host "(Они в .gitignore и не коммитятся)"
