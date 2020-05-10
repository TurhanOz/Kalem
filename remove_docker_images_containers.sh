#!/usr/bin/env bash
# -------------------------------------------------------
# This script is under MIT License
# Written by: @TurhanOz
# Last updated on: 2020/05/10
# -------------------------------------------------------

read -p 'pattern in name: ' pattern

echo "removing containers"
docker rm $(docker container ls | grep ${pattern} | awk "{print \$1}") -f

echo "removing images"
docker rmi $(docker images | grep ${pattern} | awk "{print \$3}") -f

echo "removing networks"
docker network rm $(docker network ls | grep ${pattern} | awk "{print \$1}")