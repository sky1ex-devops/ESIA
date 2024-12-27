if [ -f ../docker-compose.yml ]; then
    echo "Конфигурация Traefik:"
    (cd .. && docker compose config || docker-compose config)
else
    echo "Ошибка! Не найден docker-compose.yml в директории $PWD"
    exit
fi
