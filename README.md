# docker-mosquitto-auth

================

Debian Docker image with mosquitto 1.4.9, compiled with websockets activated and auth plugin installed

## Run

    docker run -ti -p 1883:1883 -p 9001:9001 simplx/mosquitto

Exposes Port 1883 (MQTT) 9001 (Websocket MQTT)

## Persistence

Volumes: /mqtt/config, /mqtt/data and /mqtt/log

## Build

    git clone https://github.com/toke/docker-mosquitto.git
    cd docker-mosquitto
    docker build .

## Authors and license

docker-mosquitto was written by:

* **Nicolas Duval** | [web](https://simplx.fr/) | [mail](mailto:contact@simplx.fr) | [GitHub](https://github.com/simplx-fr)
