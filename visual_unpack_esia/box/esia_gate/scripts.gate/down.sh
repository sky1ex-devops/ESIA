#!/bin/bash

if [ -f ../docker-compose.yml ]; then
    echo "Остановка ЕСИА Шлюза:"
    (cd .. && docker compose down --remove-orphans || docker-compose down --remove-orphans)
else
    echo "Ошибка! Не найден docker-compose.yml в директории $PWD"
    exit
fi
