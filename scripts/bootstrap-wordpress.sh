#!/bin/bash

STACKNAME="wordpress-stack"
SITEURL="127.0.0.1:8080"
WEBROOT="/var/www/html"

USER="admin"
PASSWORD="password"

echo "Bootstrap wordpress..."

# Wait for the wordpress php-fpm port to be available
until nc -z $(sudo docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' wordpress) 9000
do
    echo "waiting for wordpress container..."
    sleep 5
done

docker run --rm \
    --volumes-from wordpress \
    --network ${STACKNAME}_app-network \
    wordpress:cli \
    core install --path=${WEBROOT} \
    --url=${SITEURL} --title=test \
    --admin_user=${USER} --admin_password=${PASSWORD} \
    --admin_email=root@example.com
