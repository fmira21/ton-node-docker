#!/bin/bash

set_ip () {
  TON_NODE_IP=$(curl -s https://ipinfo.io/ip)
}

build_node () {
    docker build -t ton-node --build-arg VER=${NODE_VERSION} -f Dockerfile.node ./build
}

build_api () {
    docker build -t ton-node --build-arg VER=${API_VERSION} -f Dockerfile.api ./build
}

set_ip
source .env
build_node
build_api