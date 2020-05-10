#!/usr/bin/env bash

# -------------------------------------------------------
# This script is under MIT License
# Written by: @TurhanOz
# Last updated on: 2020/05/10
# -------------------------------------------------------


## check if correct folder in host
pwd=`pwd`
if [ $pwd != "/var/www" ]
then
  echo "WARNING - you need to have the nginx-proxy folder in /var/www"
  echo "EXIT;"
  exit 1;
fi;

## create docker common bridge network
echo "--------------------------------------------------------'"
echo "creating default docker network for proxy : 'nginx-proxy'"
docker network create nginx-proxy

echo "--------------------------------------------------------'"
echo "installing nginx proxy"
cd nginx-proxy
chmod 777 certs conf.d html vhost.d
docker-compose up -d
echo "EXIT'"

