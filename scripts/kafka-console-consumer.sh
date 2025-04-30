#!/bin/bash

## wrapper for nerdctl
docker() {
  nerdctl "$@"
}

kafka-topics() {
  echo "*** List topics defined ***"
  docker compose exec kafka \
    kafka-topics \
    --bootstrap-server localhost:9092 \
    --list
}

kafka-console-consumer() {
  _TOPIC="$1"
  echo "*** Start to tail ${_TOPIC}. Press Ctrl-C to stop. ***"
  docker compose exec kafka \
    kafka-console-consumer \
    --bootstrap-server localhost:9092 \
    --topic "${_TOPIC}" \
    --from-beginning \
    --property print.key=true \
    --property print.headers=true
}

kafka-console-consumer $1
