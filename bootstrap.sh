#!/bin/bash

set_ip () {
  TON_NODE_IP=$(curl -s https://ipinfo.io/ip)
}

deploy_node () {
    docker-compose -f docker-compose.node.yml up -d ton-node
}

set_http_api_key () {
    python -c 'import codecs; f=open("${NODE_STATE_VOLUME}/liteserver.pub", "rb+"); pub=f.read()[4:]; print(str(codecs.encode(pub,"base64")).replace("\n","")[2:46])'
}

set_ip
source .env
deploy_node
set_http_api_key
