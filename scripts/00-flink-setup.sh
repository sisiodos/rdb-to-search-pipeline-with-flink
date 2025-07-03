#!/bin/bash

SRC=https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-opensearch2/2.0.0-1.19/flink-sql-connector-opensearch2-2.0.0-1.19.jar
TGT=$(pwd)/flink/plugins/opensearch/$(basename ${SRC})
curl --create-dirs --output ${TGT} ${SRC}

SRC=https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-kafka/3.3.0-1.19/flink-sql-connector-kafka-3.3.0-1.19.jar
TGT=$(pwd)/flink/plugins/kafka/$(basename ${SRC})
curl --create-dirs --output ${TGT} ${SRC}

chmod -R 777 $(pwd)/flink/plugins/
