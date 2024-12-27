#!/bin/bash

args_array=($1 $2 $3 $4 $5 $6 $7)                             # Массив передаваемых переменных
max_array_length=$((${#args_array[@]} - 1))                   # Массив максимального количества передаваемых переменных
values_array=("esia" "signer" "db" "redis" "nginx" "traefik") # Массив допустимых переменных

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

if [ -z $7 ]; then                # Проверка на максимальное количество передаваемых переменных
    if [ -z ${diff_array} ]; then # Проверка на допустимые передаваемые переменные

        # Проверка на наличие передаваемой переменной и отображение конфигурации сервисов:
        if [[ "${args_array[@]}" =~ "esia" ]]; then
            (cd ../box/esia_gate/scripts.gate && ./show_config.sh)
            echo " "
        fi

        if [[ "${args_array[@]}" =~ "signer" ]]; then
            (cd ../box/esia_signer/scripts.signer && ./show_config.sh)
            echo " "
        fi

        if [[ "${args_array[@]}" =~ "db" ]]; then
            (cd ../box/esia_db/scripts.db && ./show_config.sh)
            echo " "
        fi

        if [[ "${args_array[@]}" =~ "redis" ]]; then
            (cd ../box/esia_redis/scripts.redis && ./show_config.sh)
            echo " "
        fi

        if [[ "${args_array[@]}" =~ "nginx" ]]; then
            (cd ../box/nginx/scripts.nginx && ./show_config.sh)
            echo " "
        fi

        if [[ "${args_array[@]}" =~ "traefik" ]]; then
            (cd ../box/traefik/scripts.traefik && ./show_config.sh)
            echo " "
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
