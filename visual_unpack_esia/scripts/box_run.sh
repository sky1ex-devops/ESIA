#!/bin/bash

args_array=($1 $2 $3 $4 $5)                   # Массив передаваемых переменных
max_array_length=$((${#args_array[@]} - 1))   # Массив максимального количества передаваемых переменных
values_array=("db" "redis" "nginx" "traefik") # Массив допустимых переменных

# Определение разницы массивов передаваемых и допустимых переменных
diff_array=()
for i in "${args_array[@]}"; do
        skip=
        for j in "${values_array[@]}"; do
                [[ $i == $j ]] && {
                        skip=1
                        break
                }
        done
        [[ -n $skip ]] || diff_array+=("$i")
done

if [ -z $5 ]; then                    # Проверка на максимальное количество передаваемых переменных
        if [ -z ${diff_array} ]; then # Проверка на допустимые передаваемые переменные

                source ../.env.main

                # Проверка на наличие передаваемой переменной и запуск контейнеров:
                if [[ "${args_array[@]}" =~ "db" ]]; then
                        ENV_DB_TEMPLATE=$(echo "DATABASE_IMAGE="${DATABASE_IMAGE}"
DATABASE_IMAGE_TAG="${DATABASE_IMAGE_TAG}"
DATABASE_DATA_PATH="${DATABASE_DATA_PATH}"
DATABASE_HOST="${DATABASE_HOST}"
POSTGRES_NAME="${POSTGRES_NAME}"
POSTGRES_USER="${POSTGRES_USER}"
POSTGRES_PASSWORD="${POSTGRES_PASSWORD}"
DATABASE_PORT="${DATABASE_PORT}"")
                        echo "$ENV_DB_TEMPLATE" >../box/environments/.env.db
                        (cd ../box/esia_db/scripts.db && ./run.sh)
                        echo ""
                fi

                if [[ "${args_array[@]}" =~ "redis" ]]; then
                        ENV_REDIS_TEMPLATE=$(echo "REDIS_DATA_PATH="${REDIS_DATA_PATH}"
REDIS_IMAGE="${REDIS_IMAGE}"
REDIS_IMAGE_TAG="${REDIS_IMAGE_TAG}"
REDIS_PORT="${REDIS_PORT}"")
                        echo "$ENV_REDIS_TEMPLATE" >../box/environments/.env.redis
                        (cd ../box/esia_redis/scripts.redis && ./run.sh)
                        echo ""
                fi

                ENV_GATE_TEMPLATE=$(echo "SENTINEL_IMAGE="${SENTINEL_IMAGE}"
SENTINEL_IMAGE_TAG="${SENTINEL_IMAGE_TAG}"
ESIA_GATE_URI="${ESIA_GATE_URI}"
DATABASE_HOST="${DATABASE_HOST}"
POSTGRES_NAME="${POSTGRES_NAME}"
POSTGRES_USER="${POSTGRES_USER}"
POSTGRES_PASSWORD="${POSTGRES_PASSWORD}"
DATABASE_PORT="${DATABASE_PORT}"
SIGNER_IP="${SIGNER_IP}"
DATABASE_IP="${DATABASE_IP}"
REDIS_IP="${REDIS_IP}"
MAIN_ADMIN_PASSWORD="${MAIN_ADMIN_PASSWORD}"
SMTP_ADDRESS="${SMTP_ADDRESS}"
SMTP_USER_NAME="${SMTP_USER_NAME}"
SMTP_PASSWORD="${SMTP_PASSWORD}"
SMTP_PORT="${SMTP_PORT}"



## Не менять без необходимости:

# Проверять URL Signer в настройках ЕСИА Шлюза
JIGNER_VALIDATE_URL="false"

# Настройки приложения
RAILS_ENV="production"
SENTRY_RAILS_ENABLE="false"
LOG_LEVEL="debug"

# Нужно ли заполнять ЕСИА Шлюз тестовыми данными (Демо ЕИС, КИС)
NEED_SEED="True"

# Отключить поддержку Consul
NO_CONSUL="true"")
                echo "$ENV_GATE_TEMPLATE" >../box/environments/.env.gate
                (cd ../box/esia_gate/scripts.gate && ./run.sh)
                echo ""

                ENV_SIGNER_TEMPLATE=$(echo "SIGNER_IMAGE="${SIGNER_IMAGE}"
SIGNER_IMAGE_TAG="${SIGNER_IMAGE_TAG}"
SIGNER_USERNAME="${SIGNER_USERNAME}"
SIGNER_PASSWORD="${SIGNER_PASSWORD}"
SIGNER_WEB_PORT="${SIGNER_WEB_PORT}"
SIGNER_PROVIDER="${SIGNER_PROVIDER}"
CRYPTOPRO_CSP_LICENSE="${CRYPTOPRO_CSP_LICENSE}"
CRYPTOPRO_CSP_ALIAS="${CRYPTOPRO_CSP_ALIAS}"
CRYPTOPRO_CSP_NAME="${CRYPTOPRO_CSP_NAME}"
CRYPTOPRO_CSP_PIN="${CRYPTOPRO_CSP_PIN}"



# Не менять без необходимости:

## Директория с конфигурацией API Signer
SERVICE_CONFIG_PATH="./"
## Директория с контейнерами КЭП
CSP_KEYS_PATH="./cryptopro_keys"
## Директория с сертификатами Openssl
OPENSSL_KEYS_PATH="./openssl_keys"")
                echo "$ENV_SIGNER_TEMPLATE" >../box/environments/.env.signer
               (cd ../box/esia_signer/scripts.signer && ./run.sh)
                echo ""

                if [[ "${args_array[@]}" =~ "nginx" ]]; then
                        (cd ../box/nginx/scripts.nginx && ./run.sh)
                        echo ""
                fi

                if [[ "${args_array[@]}" =~ "traefik" ]]; then
                        (cd ../box/traefik/scripts.traefik && ./run.sh)
                        echo ""
                fi
        else
                echo " ${diff_array[@]} - недопустимые значения переменных!"
                echo "Допустимые значения: ${values_array[@]}"
                exit 1
        fi
else
        echo -e "\033[31mСлишком много переменных!"
        echo "Максимальное количество допустимых переменных: ${max_array_length}"
        echo -e "\033[30m"
        exit 1
fi
