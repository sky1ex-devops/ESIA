from flask import Flask, render_template, render_template, request
from flask import url_for


app = Flask(__name__) # Создаем переменную app и записываем в неё класс Flask с функцией __name__


@app.route('/') # создаем маршрут /
def home(): # создаем функцию home без параметров
    return render_template("index.html", title="ЕСИА-Шлюз") # Возвращаем шаблон base.html и заполняем в нем переменную title


@app.route('/run', methods=['POST'])
def run():


## Переменные окружения ЕСИА Шлюза
# Параметры Docker образа для ЕСИА Шлюза
    SENTINEL_IMAGE = request.form['SENTINEL_IMAGE'] 
    SENTINEL_IMAGE_TAG = request.form['SENTINEL_IMAGE_TAG'] 
    ESIA_GATE_URI = request.form['ESIA_GATE_URI'] 
# Адреса хостов инфраструктуры Шлюза
    SIGNER_IP = request.form['SIGNER_IP'] 
    DATABASE_IP = request.form['DATABASE_IP'] 
    REDIS_IP = request.form['REDIS_IP'] 
# Пароль к главной учетной записи ЕСИА Шлюза (логин - admin@esia.pro)
    MAIN_ADMIN_PASSWORD = request.form['MAIN_ADMIN_PASSWORD'] 
# Настройки доступа к вашему почтовому серверу
    SMTP_ADDRESS = request.form['SMTP_ADDRESS'] 
    SMTP_USER_NAME = request.form['SMTP_USER_NAME'] 
    SMTP_PASSWORD = request.form['SMTP_PASSWORD'] 
    SMTP_PORT = request.form['SMTP_PORT'] 


# Переменные окружения Signer
    ## Значения Docker образа signer
    SIGNER_IMAGE = request.form['SIGNER_IMAGE']
    SIGNER_IMAGE_TAG = request.form['SIGNER_IMAGE_TAG']

    ## Имя пользователя для http basic authentication
    SIGNER_USERNAME = request.form['SIGNER_USERNAME']

    ## Пароль пользователя для http basic authentication
    SIGNER_PASSWORD = request.form['SIGNER_PASSWORD']

    ## Внешний порт контейнера с Signer
    SIGNER_WEB_PORT = request.form['SIGNER_WEB_PORT']

    ## Используемый криптопровайдер для обращения к сертификату (может принимать значения: csp, openssl)
    SIGNER_PROVIDER = request.form['SIGNER_PROVIDER']

    ## [Если криптопровайдером выбран CSP] Лицензионный номер для криптопро CSP на одно рабочее место
    CRYPTOPRO_CSP_LICENSE = request.form['CRYPTOPRO_CSP_LICENSE']

    ## [Если криптопровайдером выбран CSP] Алиас сертификата (необходим для выполнения запросов к конкретному сертификату. Может быть произвольным)
    CRYPTOPRO_CSP_ALIAS = request.form['CRYPTOPRO_CSP_ALIAS']

    ## [Если криптопровайдером выбран CSP] Имя криптоконтейнера (находится в name.key криптоконтейнера)
    CRYPTOPRO_CSP_NAME = request.form['CRYPTOPRO_CSP_NAME']

    ## [Если криптопровайдером выбран CSP] Pin код для криптоконтейнера (если он есть, иначе оставить пустым)
    CRYPTOPRO_CSP_PIN = request.form['CRYPTOPRO_CSP_PIN']


# Переменные окружения базы данных
    ## Значения Docker образа для БД
    DATABASE_IMAGE = request.form['DATABASE_IMAGE']
    DATABASE_IMAGE_TAG = request.form['DATABASE_IMAGE_TAG']

    ## Путь к файлам БД на хостовой машине
    DATABASE_DATA_PATH = request.form['DATABASE_DATA_PATH']

    ## Данные БД
    DATABASE_HOST = request.form['DATABASE_HOST']
    POSTGRES_NAME = request.form['POSTGRES_NAME']
    POSTGRES_USER = request.form['POSTGRES_USER']
    POSTGRES_PASSWORD = request.form['POSTGRES_PASSWORD']
    DATABASE_PORT = request.form['DATABASE_PORT']


# Переменные окружения Redis
    ## Путь к файлам Redis на хостовой машине
    REDIS_DATA_PATH = request.form['REDIS_DATA_PATH']

    ## Значения Docker образа для Redis
    REDIS_IMAGE = request.form['REDIS_IMAGE']
    REDIS_IMAGE_TAG = request.form['REDIS_IMAGE_TAG']

    ## Внешний порт контейнера Redis
    REDIS_PORT = request.form['REDIS_PORT']


    with open(r"./.env.test", "w") as file:
        ## Переменные окружения ЕСИА Шлюза
        file.write("# Переменные окружения ЕСИА Шлюза\n\n")

        file.write("## Значения Docker образа для ЕСИА Шлюза\n")
        file.write("SENTINEL_IMAGE=" + repr(SENTINEL_IMAGE) + '\n')
        file.write("SENTINEL_IMAGE_TAG=" + repr(SENTINEL_IMAGE_TAG) + '\n\n')

        file.write("ESIA_GATE_URI=" + repr(ESIA_GATE_URI) + '\n')

        file.write("## Адреса хостов инфраструктуры Шлюза\n")
        file.write("SIGNER_IP=" + repr(SIGNER_IP) + '\n')
        file.write("DATABASE_IP=" + repr(DATABASE_IP) + '\n')
        file.write("REDIS_IP=" + repr(REDIS_IP) + '\n\n')

        file.write("## Пароль к главной учетной записи ЕСИА Шлюза (логин - admin@esia.pro)\n")
        file.write("MAIN_ADMIN_PASSWORD=" + repr(MAIN_ADMIN_PASSWORD) + '\n\n')

        file.write("## Настройки доступа к вашему почтовому серверу\n")
        file.write("SMTP_ADDRESS=" + repr(SMTP_ADDRESS) + '\n')
        file.write("SMTP_USER_NAME=" + repr(SMTP_USER_NAME) + '\n')
        file.write("SMTP_PASSWORD=" + repr(SMTP_PASSWORD) + '\n')
        file.write("SMTP_PORT=" + repr(SMTP_PORT) + '\n\n')

        # Переменные окружения Signer
        file.write("# Переменные окружения Signer\n\n")

        file.write("## Значения Docker образа signer\n")
        file.write("SIGNER_IMAGE=" + repr(SIGNER_IMAGE) + '\n')
        file.write("SIGNER_IMAGE_TAG=" + repr(SIGNER_IMAGE_TAG) + '\n\n')
        
        file.write("## Имя пользователя для http basic authentication \n")
        file.write("SIGNER_USERNAME=" + repr(SIGNER_USERNAME) + '\n\n')
        
        file.write("## Пароль пользователя для http basic authentication \n")
        file.write("SIGNER_PASSWORD=" + repr(SIGNER_PASSWORD) + '\n\n')

        file.write("## Внешний порт контейнера с Signer \n")
        file.write("SIGNER_WEB_PORT=" + repr(SIGNER_WEB_PORT) + '\n\n')

        file.write("## Используемый криптопровайдер для обращения к сертификату (может принимать значения: csp, openssl) \n")
        file.write("SIGNER_PROVIDER=" + repr(SIGNER_PROVIDER) + '\n\n')      

        file.write("## [Если криптопровайдером выбран CSP] Лицензионный номер для криптопро CSP на одно рабочее место \n")
        file.write("CRYPTOPRO_CSP_LICENSE=" + repr(CRYPTOPRO_CSP_LICENSE) + '\n\n')   

        file.write("## [Если криптопровайдером выбран CSP] Алиас сертификата (необходим для выполнения запросов к конкретному сертификату. Может быть произвольным) \n")
        file.write("CRYPTOPRO_CSP_ALIAS=" + repr(CRYPTOPRO_CSP_ALIAS) + '\n\n')          

        file.write("## [Если криптопровайдером выбран CSP] Имя криптоконтейнера (находится в name.key криптоконтейнера)\n")
        file.write("CRYPTOPRO_CSP_NAME=" + repr(CRYPTOPRO_CSP_NAME) + '\n\n')      

        file.write("## [Если криптопровайдером выбран CSP] Имя криптоконтейнера (находится в name.key криптоконтейнера) \n")
        file.write("CRYPTOPRO_CSP_PIN=" + repr(CRYPTOPRO_CSP_PIN) + '\n\n')          


        # Переменные окружения базы данных
        file.write("# Переменные окружения базы данных\n\n")

        file.write("## Значения Docker образа для БД \n")
        file.write("DATABASE_IMAGE=" + repr(DATABASE_IMAGE) + '\n\n')          
        file.write("DATABASE_IMAGE_TAG=" + repr(DATABASE_IMAGE_TAG) + '\n\n')   

        file.write("## Путь к файлам БД на хостовой машине\n")
        file.write("DATABASE_DATA_PATH=" + repr(DATABASE_DATA_PATH) + '\n\n') 

        file.write("## Данные БД \n")
        file.write("DATABASE_HOST=" + repr(DATABASE_HOST) + '\n')          
        file.write("POSTGRES_NAME=" + repr(POSTGRES_NAME) + '\n')  
        file.write("POSTGRES_USER=" + repr(POSTGRES_USER) + '\n')  
        file.write("POSTGRES_PASSWORD=" + repr(POSTGRES_PASSWORD) + '\n')  
        file.write("DATABASE_PORT=" + repr(DATABASE_PORT) + '\n\n')  


        # Переменные окружения Redis
        file.write("# Переменные окружения Redis\n\n")

        file.write("## Путь к файлам Redis на хостовой машине\n")
        file.write("REDIS_DATA_PATH=" + repr(REDIS_DATA_PATH) + '\n\n') 

        file.write("## Значения Docker образа для Redis \n")
        file.write("REDIS_IMAGE=" + repr(REDIS_IMAGE) + '\n')          
        file.write("REDIS_IMAGE_TAG=" + repr(REDIS_IMAGE_TAG) + '\n\n')     

        file.write("## Путь к файлам Redis на хостовой машине\n")
        file.write("REDIS_DATA_PATH=" + repr(REDIS_DATA_PATH) + '\n\n') 


    return render_template(f"base.html", title="ЕСИА-Шлюз",
    SENTINEL_IMAGE = SENTINEL_IMAGE,
    SENTINEL_IMAGE_TAG = SENTINEL_IMAGE_TAG,
    ESIA_GATE_URI = ESIA_GATE_URI,
    SIGNER_IP = SIGNER_IP,
    DATABASE_IP = DATABASE_IP,
    REDIS_IP =  REDIS_IP,
    MAIN_ADMIN_PASSWORD = MAIN_ADMIN_PASSWORD,
    SMTP_ADDRESS =  SMTP_ADDRESS,
    SMTP_USER_NAME = SMTP_USER_NAME,
    SMTP_PASSWORD = SMTP_PASSWORD ,
    SMTP_PORT = SMTP_PORT,
    SIGNER_IMAGE = SIGNER_IMAGE,
    SIGNER_IMAGE_TAG = SIGNER_IMAGE_TAG,
    SIGNER_USERNAME = SIGNER_USERNAME,
    SIGNER_PASSWORD = SIGNER_PASSWORD,
    SIGNER_WEB_PORT = SIGNER_WEB_PORT,
    SIGNER_PROVIDER = SIGNER_PROVIDER,
    CRYPTOPRO_CSP_LICENSE = CRYPTOPRO_CSP_LICENSE,
    CRYPTOPRO_CSP_ALIAS = CRYPTOPRO_CSP_ALIAS,
    CRYPTOPRO_CSP_NAME = CRYPTOPRO_CSP_NAME,
    CRYPTOPRO_CSP_PIN = CRYPTOPRO_CSP_PIN,
    DATABASE_IMAGE = DATABASE_IMAGE,
    DATABASE_IMAGE_TAG = DATABASE_IMAGE_TAG,
    DATABASE_DATA_PATH = DATABASE_DATA_PATH,
    DATABASE_HOST = DATABASE_HOST,
    POSTGRES_NAME = POSTGRES_NAME,
    POSTGRES_USER = POSTGRES_USER,
    POSTGRES_PASSWORD = POSTGRES_PASSWORD,
    DATABASE_PORT = DATABASE_PORT,
    REDIS_DATA_PATH = REDIS_DATA_PATH,
    REDIS_IMAGE = REDIS_IMAGE,
    REDIS_IMAGE_TAG = REDIS_IMAGE_TAG,
    REDIS_PORT = REDIS_PORT
)

if __name__ == "__main__":
    app.run(debug=True) # Выполнять программу в режиме debug mode