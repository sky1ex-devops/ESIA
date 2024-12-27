#!/bin/bash

if [ -f ./docker-compose.yml ]; then
    echo "Конфигурация ЕСИА Шлюза:"
    (cd .. && docker compose config || docker-compose config)
    echo " "
    cat ../tenant.yml
else
    echo "Ошибка! Не найден docker-compose.yml в директории $PWD"
    exit
fi
