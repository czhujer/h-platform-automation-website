#!/bin/bash

STACKNAME="wordpressstack"
SITEURL="127.0.0.1:8080"
WEBROOT="/var/www/html"

USER="admin"
PASSWORD="password"

echo "Bootstrap wordpress..."

sleep 30

docker run --rm \
    --volumes-from wordpress \
    --network ${STACKNAME}_app-network \
    wordpress:cli \
    core install --path=${WEBROOT} \
    --url=${SITEURL} --title=test \
    --admin_user=${USER} --admin_password=${PASSWORD} \
    --admin_email=root@example.com
