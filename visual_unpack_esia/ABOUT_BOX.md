# Описание коробочного решения ЕСИА Шлюз

## Требования

Здесь описаны требования, предъявляемые платформой `ЕСИА Шлюз` к IT-инфраструктуре, в которую планируется интеграция. Поскольку платформа представляет собой комплексное и конфигурируемое решение, то данные требования носят консультационный характер и могут меняться в зависимости от конкретной выбранной схемы размещения или иных условий.

## Системные требования

Работает на любой современной операционной системе семейства Linux и на любой современной версии Docker.

Поскольку требования к аппаратной части сильно зависят от планируемой загрузки (и выбранной схемы размещения), то тут будут приведены минимальные характеристики.

Минимальные требования к аппаратной части:

- 2CPU;
- 4GB Memory;
- 100GB Disk [^disk].

Минимальные требования к аппаратной части БД:

- 2CPU;
- 4GB Memory.

## Технические особенности

Программное обеспечение `ЕСИА Шлюз` поставляется в виде архива c набором bash-скриптов, основой для работы которых является docker-compose.

_docker compose - средство для определения и запуска приложений Docker с несколькими контейнерами. При работе с ним используется формат YAML для настройки служб приложения._

## Безопасность

Требования к безопасности в существенной степени определяются окружением клиента и принятыми внутренними регламентами, уставными документами и иными нормативными и законодательными актами.

## Хранение данных

`ЕСИА Шлюз` не хранит данные локально и представляет из себя `read-only` контейнеры. Все данные сохраняются в строго определенных местах: `PostgreSQL` и `Redis`, которые в свою очередь не являются частью ПО и могут быть настроены и запущены силами специалистов заказчика согласно установленным нормам.

Кроме того, `ЕСИА Шлюз` спроектирован так, чтобы во время работы `не сохранять персональные данные`, с которыми он работает, а хранить лишь информацию о выполненной работе - какой запрос как именно был обработан.

## Сайнер

Для корректной работы ЕСИА Шлюз необходимо запустить Сайнер. Сайнер - это ПО, которое подписывает запросы перед их отправкой в ЕСИА.

Данное ПО работает с 2-мя провайдерами:

- КриптПро CSP (Для работы потребуется лицензия КриптоПро на одно рабочее место)
- OpenSSL
