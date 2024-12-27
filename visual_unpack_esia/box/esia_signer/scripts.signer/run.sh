#!/bin/bash


set -ea

# Проверка наличия глобального .env.main файла и создание config.yml с заданными переменными окружения
if [ ! -f ../../environments/.env.signer ]; then
    echo "Рендеринг переменных окружения из локального .env Сайнера и запись в config.yml"
    source ../.env
else
    echo "Рендеринг переменных окружения из общего .env.main Сайнера и запись в config.yml"
    source ../../environments/.env.signer
fi

CONFIG_YML_TEMPLATE=$(echo "username: "${SIGNER_USERNAME}" #Имя пользователя для http basic authentication
password: "${SIGNER_PASSWORD}" #Пароль пользователя для http basic authentication
port: ${SIGNER_WEB_PORT} #Порт на котором приложение внутри контейнера будет ожидать входящие подключения (при смене порта, следует учитывать настройки в файле docker-compose.yml)
provider: ${SIGNER_PROVIDER} #Используемый криптопровайдер для обращения к сертификату (может принимать значения: csp, openssl)
csp:
  #Блок настроек для криптопровайдера csp
  keystore: HDImage #Хранилище сертификатов (не менять)
  keys:
  - alias: "${CRYPTOPRO_CSP_ALIAS}" #Алиас сертификата (необходим для выполнения запросов к конкретному сертификату. Может быть произвольным)
    name: "${CRYPTOPRO_CSP_NAME}" #Имя криптоконтейнера (находится в name.key криптоконтейнера)
    pin: "${CRYPTOPRO_CSP_PIN}" #Pin код для криптоконтейнера (если он есть, иначе оставить пустым)
openssl:
  #Блок настроек для криптопровайдера openssl
  keysDir: /home/app/openssl_keys #Директория внутри контейнера в которой должны лежать сертификат и ключ в формате pem.
log:
  level: debug
  dir: ./logs
  maxSize: 1048576
  #colors: auto Управление цветным выводом в консоль. Поддерживаемые значения: on, off, auto. По умолчанию: auto
  #maxCount Максимальное количество файлов логов. По умолчанию: 10
  #baseName: signer Базовое имя файла лога. По умолчанию: signer
")

echo "$CONFIG_YML_TEMPLATE" >../config.yml

# Проверка наличия файла docker-compose.yml и запуск контейнеров
if [ -f ../docker-compose.yml ]; then
    echo "Запуск Сайнера:"
    (cd .. && docker compose up -d || docker-compose up -d)
else
    echo "Ошибка! Не найден docker-compose.yml в директории $PWD"
    exit
fi
