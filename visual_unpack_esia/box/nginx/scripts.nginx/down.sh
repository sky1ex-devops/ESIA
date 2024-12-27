if [ -f ../docker-compose.yml ]; then
    echo "Остановка Nginx:"
    (cd .. && docker compose down --remove-orphans || docker-compose down --remove-orphans)
else
    echo "Ошибка! Не найден docker-compose.yml в директории $PWD"
    exit
fi
