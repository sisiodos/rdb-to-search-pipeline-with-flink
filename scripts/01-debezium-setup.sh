#!/bin/bash
set -euo pipefail

# debezium connector
CONNECT_HOST=localhost
CONNECT_PORT=8083
CONNECT_URL="http://${CONNECT_HOST}:${CONNECT_PORT}"

# debezium settings
CONNECTOR_NAME="postgres-connector"
TOPIC_PREFIX="dbserver1"
DATABASE_HOST=postgres
DATABASE_PORT=5432
DATABASE_USER=debezium
DATABASE_PASSWORD=dbz
DATABASE_DBNAME=postgres
SLOT_NAME="debezium_slot"
PUBLICATION_NAME="debezium_pub"
# TABLE_INCLUDE_LIST: カンマ区切りで複数テーブル指定可能（例："public.t1,public.t2"）
TABLE_INCLUDE_LIST="public.testtable"
# SNAPSHOT_MODE: initial / schema_only / never
SNAPSHOT_MODE=initial

echo "Waiting for Kafka Connect to be available at ${CONNECT_URL}..."

# wait until connect REST endpoint is ready
until curl -s "${CONNECT_URL}/connectors" >/dev/null; do
	echo -n "."
	sleep 2
done

echo "Kafka Connect is ready. Registering Debezium PostgreSQL connector..."

# for debeizum 1.9
curl -X POST "${CONNECT_URL}/connectors" \
	-H "Content-Type: application/json" \
	-d @- <<EOF
{
  "name": "${CONNECTOR_NAME}",
  "config": {
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "database.hostname": "${DATABASE_HOST}",
    "database.port": "${DATABASE_PORT}",
    "database.user": "${DATABASE_USER}",
    "database.password": "${DATABASE_PASSWORD}",
    "database.dbname": "${DATABASE_DBNAME}",
    "database.server.name": "${TOPIC_PREFIX}",
    "topic.prefix": "${TOPIC_PREFIX}",
    "plugin.name": "pgoutput",
    "publication.name": "${PUBLICATION_NAME}",
    "slot.name": "${SLOT_NAME}",
    "slot.drop.on.stop": "true",
    "table.include.list": "${TABLE_INCLUDE_LIST}",
    "snapshot.mode": "${SNAPSHOT_MODE}",
    "tombstones.on.delete": "false",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "key.converter.schemas.enable": "false",
    "value.converter.schemas.enable": "false"
  }
}
EOF

# for debezium 2.3
# curl -X POST "${CONNECT_URL}/connectors" \
# 	-H "Content-Type: application/json" \
# 	-d @- <<EOF
# {
#   "name": "${CONNECTOR_NAME}",
#   "config": {
#     "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
#     "database.hostname": "${DATABASE_HOST}",
#     "database.port": "${DATABASE_PORT}",
#     "database.user": "${DATABASE_USER}",
#     "database.password": "${DATABASE_PASSWORD}",
#     "database.dbname": "${DATABASE_DBNAME}",
#     "topic.prefix": "${TOPIC_PREFIX}",
#     "plugin.name": "pgoutput",
#     "publication.name": "${PUBLICATION_NAME}",
#     "slot.name": "${SLOT_NAME}",
#     "slot.drop.on.stop": "true",
#     "table.include.list": "${TABLE_INCLUDE_LIST}",
#     "snapshot.mode": "${SNAPSHOT_MODE}",
#   }
# }
# EOF

echo "Debezium connector '${CONNECTOR_NAME}' registered successfully."
