if [ -f ../docker-compose.yml ]; then
    echo "Запуск Nginx:"
    (cd .. && docker compose up -d || docker-compose up -d)
else
    echo "Ошибка! Не найден docker-compose.yml в директории $PWD"
    exit
fi
