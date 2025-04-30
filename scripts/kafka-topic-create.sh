#!/bin/bash

## wrapper for nerdctl
docker() {
  nerdctl "$@"
}

kafka-topic-create() {
  _TOPIC="$1"
  echo "*** Create ${_TOPIC} with compact mode ***"
  docker compose exec kafka \
    kafka-topics --create --topic ${_TOPIC} \
    --bootstrap-server localhost:9092 \
    --partitions 6 \
    --replication-factor 1 \
    --config cleanup.policy=compact \
    --config segment.ms=60000 \
    --config delete.retention.ms=86400000
}

kafka-topic-create orders_with_products_raw
