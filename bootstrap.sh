#!/bin/bash

set_ip () {
  TON_NODE_IP=$(curl -s https://ipinfo.io/ip)
}

build_all () {
  docker-compose -f docker-compose.node.yml build
}

deploy_node () {
  docker-compose -f docker-compose.node.yml up -d ton-node
}

set_http_api_key () {
  NODE_API_KEY=$(docker run --r -v $NODE_STATE_VOLUME:/state python python -c 'import codecs; f=open('/state/liteserver.pub', "rb+"); pub=f.read()[4:]; print(str(codecs.encode(pub,"base64")).replace("\n","")[2:46])')
  sed -i -e 's/NODEAPIKEY/'"$NODE_API_KEY"'/g' ./config/api-config/${API_NETWORK}-config-${API_MODE}.json
}

deploy_api () {
  docker-compose -f docker-compose.node.yml up -d ton-api
}

set_ip
source .env
deploy_node
set_http_api_key
deploy_api