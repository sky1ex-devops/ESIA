#!/bin/bash

if [ -f ../openid_signing.key ]; then # Проверка на наличие openssl ключа в директории
    echo "Приватный OpenSSL ключ уже существует!"
    echo "Если хотите сгенерировать новый ключ, необходимо перейти в '../esia_gate' и удалить 'openid_signing.key', после чего перезапустить скрипт"
else
    # Создание приватного ключа
    (cd .. && openssl genpkey -algorithm RSA -out openid_signing.key -pkeyopt rsa_keygen_bits:2048 && chmod a+r openid_signing.key)
    echo "Ключ был успешно создан"
fi
