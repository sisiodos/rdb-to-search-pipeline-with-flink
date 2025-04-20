#!/bin/bash

SRC=https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-opensearch2/2.0.0-1.19/flink-sql-connector-opensearch2-2.0.0-1.19.jar
TGT=$(pwd)/flink/lib/ext/$(basename ${SRC})
curl --create-dirs --output ${TGT} ${SRC}

SRC=https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-kafka/3.3.0-1.19/flink-sql-connector-kafka-3.3.0-1.19.jar
TGT=$(pwd)/flink/lib/ext/$(basename ${SRC})
curl --create-dirs --output ${TGT} ${SRC}

SRC=https://repo1.maven.org/maven2/org/apache/flink/flink-connector-opensearch2/2.0.0-1.19/flink-connector-opensearch2-2.0.0-1.19.jar
TGT=$(pwd)/flink/lib/ext/$(basename ${SRC})
curl --create-dirs --output ${TGT} ${SRC}

SRC=https://repo1.maven.org/maven2/org/apache/flink/flink-connector-opensearch-base/2.0.0-1.19/flink-connector-opensearch-base-2.0.0-1.19.jar
TGT=$(pwd)/flink/lib/ext/$(basename ${SRC})
curl --create-dirs --output ${TGT} ${SRC}
