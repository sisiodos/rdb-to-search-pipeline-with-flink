#!/bin/bash
set -e

# echo "[flink-jobmanager] Copying connector JARs..."
# cp /opt/flink/lib/ext/*.jar /opt/flink/lib/

echo "[flink-jobmanager] Starting Flink JobManager..."
exec /docker-entrypoint.sh jobmanager
