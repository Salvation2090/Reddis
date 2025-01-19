#!/bin/bash
# Script for Install and configure Redis cluster
# KeepWalking86

# Initial
MASTER_IP=192.168.1.111
SLAVE1_IP=192.168.1.112
SLAVE2_IP=192.168.1.113
REDIS_PORT=6379

echo "Welcome to install and configure Redis cluster"
sleep 3

# Check for root user
if [ "$(id -u)" -ne 0 ]; then
    echo "Please, run this script as root account!"
    exit 1
fi

# Check OS and install essential package to compile redis
if [ -f /etc/debian_version ]; then
    apt-get -y install build-essential
else
    if [ -f /etc/redhat-release ]; then
        yum -y groupinstall "Development Tools"
    else
        echo "Distro hasn't been supported by this script"
        exit 1
    fi
fi

# Installing redis
cd /opt
curl -O http://download.redis.io/redis-stable.tar.gz
tar xzvf redis-stable.tar.gz
cd redis-stable
make
cp /opt/redis-stable/src/redis-cli /usr/bin/
cp /opt/redis-stable/src/redis-server /usr/bin/

# Configure redis
mkdir /etc/redis/
mkdir /var/log/redis/
cp /opt/redis-stable/redis.conf /etc/redis/
sed -i 's/supervised no/supervised systemd/' /etc/redis/redis.conf
sed -i 's/dir .\//dir \/var\/lib\/redis/' /etc/redis/redis.conf
sed -i '/bind 127.0.0.1/c\bind 0.0.0.0' /etc/redis/redis.conf
sed -i '/logfile/c\logfile "/var/log/redis/redis.log"' /etc/redis/redis.conf

# Set up the systemd unit file
cat >/etc/systemd/system/redis.service<<EOF
[Unit]
Description=Redis In-Memory Data Store
After=network.target
[Service]
ExecStart=/usr/bin/redis-server /etc/redis/redis.conf
ExecStop=/usr/bin/redis-cli shutdown
Restart=always
[Install]
WantedBy=multi-user.target
EOF

# Redis dump
mkdir -p /var/lib/redis
chmod 770 /var/lib/redis

# Start and enable redis server
systemctl start redis
systemctl enable redis

## Setup Redis cluster
# Configure replication
IP_ADDR=`ip route get 1.1.1.1 | grep -oP 'src \K\S+'`
if [ $IP_ADDR == $SLAVE1_IP ] || [ $IP_ADDR == $SLAVE2_IP ]; then
    echo "slaveof $MASTER_IP $REDIS_PORT" >>/etc/redis/redis.conf
    systemctl restart redis.service
fi

