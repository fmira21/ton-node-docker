#!/bin/bash

build_all () {
  docker-compose build
}

add_node_assets () {
  mkdir $NODE_STATE_VOLUME
  cp -a config/node-assets/. db/
}

deploy_node () {
  docker-compose up -d ton-node
}

set_http_api_key () {
  NODE_API_KEY=$(docker run --rm -v $API_CONF_VOLUME:/conf -v $NODE_STATE_VOLUME:/liteserver ton-api -c "python /conf/generate-api-key.py")
  sed -i "s~NODEAPIKEY~$NODE_API_KEY~g" ${API_CONF_VOLUME}/${API_NETWORK}-config-${API_MODE}.json
}

deploy_api () {
  docker-compose up -d ton-api
}

export TON_NODE_IP=$(curl -s https://ipinfo.io/ip)
source .env
build_all
add_node_assets
deploy_node
set_http_api_key
deploy_api