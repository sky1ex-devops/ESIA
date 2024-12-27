#!/bin/bash

# Авторизация в harbor.rnds.pro (Docker Registry)
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <login> <password>"
    exit 1
fi

LOGIN=$1
PASSWORD=$2

docker logout harbor.rnds.pro
echo "docker login harbor.rnds.pro -u \"$LOGIN\" -p \"$PASSWORD\"" >docker-login.sh
chmod +x docker-login.sh

./docker-login.sh
LOGIN_RESULT=$?

if [ $LOGIN_RESULT -ne 0 ]; then
    echo "Логин в Docker реестр не удался"
    exit 2
else
    echo "Логин в Docker реестр успешно выполнен"
fi
rm -rf docker-login.sh
echo "Success"
