#!/bin/bash
set -e

echo "[flink-taskmanager] Copying connector JARs..."
cp /opt/flink/lib/ext/*.jar /opt/flink/lib/

echo "[flink-taskmanager] Starting Flink TaskManager..."
exec /docker-entrypoint.sh taskmanager
