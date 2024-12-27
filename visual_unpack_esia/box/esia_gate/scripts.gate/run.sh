#!/bin/bash

set -ea

# Запуск скрипта по созданию и выдаче прав для приватного OpenSSL ключа
./generate.sh
echo " "

# Проверка наличия глобального .env.main файла и создание tenant.yml с заданными переменными окружения
if [ ! -f ../../environments/.env.gate ]; then
    echo "Рендеринг переменных окружения из локального .env ЕСИА Шлюза и запись в tenant.yml"
    source ../.env
else
    echo "Рендеринг переменных окружения из общего .env.main ЕСИА Шлюза и запись в tenant.yml"
    source ../../environments/.env.gate
fi

TENANT_YML_TEMPLATE=$(echo "production:
  default:
    db_config:
      adapter: postgresql
      encoding: unicode
      host: ${DATABASE_HOST}
      pool: 5
      port: ${DATABASE_PORT}
      database: ${POSTGRES_NAME}
      username: ${POSTGRES_USER}
      password: ${POSTGRES_PASSWORD}
      advisory_locks: false
      prepared_statements: false
  rnds_main:
    db_config:
      adapter: postgresql
      encoding: unicode
      host: ${DATABASE_HOST}
      pool: 5
      port: ${DATABASE_PORT}
      database: user_esia_db
      username: ${POSTGRES_USER}
      password: ${POSTGRES_PASSWORD}
      advisory_locks: false
      prepared_statements: false
    secrets:
      uris: '[\"${ESIA_GATE_URI}\"]'

")

echo "$TENANT_YML_TEMPLATE" >../tenant.yml

# Проверка наличия файла docker-compose.yml и запуск контейнеров
if [ -f ../docker-compose.yml ]; then
    echo "Запуск ЕСИА Шлюза:"
    (cd .. && docker compose up -d || docker-compose up -d)
else
    echo "Ошибка! Не найден docker-compose.yml в директории $PWD"
    exit
fi
