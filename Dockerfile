# Используем базовый образ Ubuntu 20.04
FROM ubuntu:20.04

# Обновляем и устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y redis-server

# Открываем порт Redis (по умолчанию 6379)
EXPOSE 6379

# Устанавливаем Redis в качестве демона
CMD ["redis-server", "--bind", "0.0.0.0"]

