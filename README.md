# Telegram Open Network: Full node and Toncenter API, dockerised

This repository contains TON full node and Toncenter API builds unified into one Compose definition - to run as a service on any host machine.

This setup can be deployed on your host without any external dependencies: just clone this repo and run `bootstrap.sh`. Then wait for your full node to sync with the chain.

## Credentials

Many thanks to **EmelyanenkoK** and **neodiX42** for the [TON node build](https://github.com/ton-blockchain/ton/blob/master/docker/Dockerfile) which is used here without major changes, as well as **dungeon-master-666** for [TON HTTP API](https://github.com/toncenter/ton-http-api).

This setup has been created with the use of these sources.

## Functionality

TON node works in the full mode by default.

The API service can be configured to work in two modes:

- one-to-one - interacting with your node only;
- one-to-many - interacting with a set of nodes including your node.

## Prerequisites

To bootstrap and run the node, you have to install **Docker and Docker Compose** on your host.

As per my experience, following hardware requirements are applicable for both Testnet and Mainnet full nodes:

- 8-core CPU / vCPU's
- 64 Gb RAM
- <= 10 Gbps network bandwith
- Static IP to advertise the node

For further details, refer to the [official requirements](https://docs.ton.org/participate/run-nodes/full-node#:~:text=Hardware%20requirements%E2%80%8B&text=You%20need%20a%20machine%20with,a%20TON%20Blockchain%20Full%20Node.).

## Configuration

Both node and API are configured via the `.env` file.

In the **node part** of the file, you will find following parameters:

| Variable | Description | Default value |
| -------- | ----------- | ------------- |
| `NODE_VERSION` | Release version of the TON node | `2023.10` |
| `NODE_CONF_VOLUME` | External volume to store node configuration files | `./config/node-config` |
| `NODE_LOG_VOLUME` | External volume to store node logs | `./logs` |
| `NODE_STATE_VOLUME` | External volume to store the node DB | `./db` |
| `NODE_CONFIG_URL` | Node config URL to download (find current config versions for Testnet and Mainnet below) | Testnet config |
| `NODE_PUBLIC_IP` | External public IP of your host to advertise the node on. This IP can be fetched automatically by `bootstrap.sh` | `TON_NODE_IP` environment variable |
| `NODE_LITESERVER` | Enable liteserver mode | `true` |
| `NODE_LITESERVER_PORT` | Node liteserver port | `43679` |

In the **API part** of the file, you can set following HTTP API parameters:

| Variable | Description | Default value |
| -------- | ----------- | ------------- |
| `API_VERSION` | Release version of TON HTTP API | `2.0.31` |
| `API_NETWORK` | API network corresponding with your node | `testnet` |
| `API_MODE` | API interaction mode as above: `onetoone` or `onetomany` | `onetoone` |
| `API_CONF_VOLUME` | External volume to store API configs | `./config/api-config` |
| `API_CACHE_ENABLED` | Set `1` to enable API cache | `0` |
| `API_LOGS_JSONIFY` | Set `1` to get logs in the JSON format | `0` |
| `API_LOGS_LEVEL` | API log level | `ERROR` |
| `API_TONLIB_LITESERVER_CONFIG` | Internal config path, fetched automatically from `API_NETWORK` and `API_MODE` variables | `/conf/${API_NETWORK}-config-${API_MODE}.json` |
| `API_TONLIB_PARALLEL_REQUESTS_PER_LITESERVER` | Maximal number of parallel request per liteserver | `50` |
| `API_TONLIB_REQUEST_TIMEOUT` | Timeout time of a request in milliseconds | `10000` |
| `API_GET_METHODS_ENABLED` | Set `1` to enable `GET` API methods | `1` |
| `API_JSON_RPC_ENABLED` | Set `1` to enable JSON RPC | `1` |
| `API_ROOT_PATH` | API root path after your hostname or IP | `"/"` |

## Running the node

To run the full node and API, change environment variables needed in the `.env` configuration and run the `bootstrap.sh` script.

This script will perform following operations:

1. Set your static IP as the `TON_NODE_IP` environment variable - to be used in the `.env` file further.
2. Apply `.env` variables to your shell environment.
3. Build local node and API images.
4. Run the node container. The node will bootstrap additionally with the use of the `./config/node-config/init.sh` script.
5. Run the standard `python` Docker image to set the `NODE_API_KEY` variable containing the generated HTTP API key of the node.
6. Add the obtained node API key to the desired API config.
7. Run the HTTP API container.

Then, just wait until your node is synchronised with the chain.

To interact with the API, refer to the [Toncenter API reference](https://toncenter.com/api/v2/).