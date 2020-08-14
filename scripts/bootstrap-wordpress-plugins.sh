#!/bin/bash

STACKNAME="wordpress-stack"
WEBROOT="/var/www/html"

PLUGINNAME="calculoid-calculators-builder"

echo "Bootstrap wordpress plugins..."

#sleep 30

docker run --rm \
    --volumes-from wordpress \
    --network ${STACKNAME}_app-network \
    wordpress:cli \
    plugin install ${PLUGINNAME} --path=${WEBROOT}

docker run --rm \
    --volumes-from wordpress \
    --network ${STACKNAME}_app-network \
    wordpress:cli \
    plugin activate ${PLUGINNAME} --path=${WEBROOT}
