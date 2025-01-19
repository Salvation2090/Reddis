# Redis Cluster Docker Setup

Этот репозиторий содержит все необходимые файлы для настройки кластера Redis с использованием Docker и Docker Compose. В репозитории присутствуют следующие файлы:

- `Dockerfile`: Dockerfile для создания образа Redis на базе Ubuntu 20.04.
- `docker-compose.yaml`: Конфигурационный файл Docker Compose для запуска кластера Redis.
- `install_redis.sh`: Скрипт для установки Redis на локальную машину.

## Содержание

- [Требования](#требования)
- [Установка](#установка)
- [Использование](#использование)

## Требования

Для работы с этим репозиторием вам потребуется:

- Docker
- Docker Compose
- Bash (для выполнения скрипта установки)

## Установка

### Клонирование репозитория

```bash
git clone https://github.com/Salvation2090/Reddis.git
cd Reddis
```

### Установка docker

```bash
sudo chmod u+x install_docker.sh
sudo bash install_docker.sh
```

### Сборка Docker образа

```bash
sudo docker build -t redis-ubuntu:20.04 .
sudo docker run -d --name redis-container -p 6388:6379 redis-ubuntu:20.04
```

### Запуск кластера Redis

```bash
sudo docker compose up -d
```

### Установка Redis на локальную машину

Для установки Redis на локальную машину, выполните следующий скрипт с правами суперпользователя:

```bash
sudo chmod u+x install_redis.sh
sudo bash install_redis.sh
```

## Использование

После запуска кластера Redis с помощью Docker Compose, вы можете подключиться к любому из узлов кластера. Например, для подключения к первому узлу:

```bash
redis-cli -h localhost -p 6389
```
