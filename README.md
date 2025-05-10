# Connecting RDBs and Search Engines: Building a Pipeline with Flink, Kafka, and OpenSearch

📖 [日本語はこちら / Japanese version](./README-ja.md)

This repository contains a runnable example of the OSS-based data pipeline architecture introduced in the technical guidebook  
📘 “[Read the full guide on Zenn (in Japanese)](https://zenn.dev/sisiodos/books/4d81a988255bf0)” (in Japanese).

You can use this Docker Compose setup to try the entire pipeline locally and learn how to stream updates from a relational database to a search engine in real time.

---

## 🛠️ Architecture Overview

This repository builds the following components via Docker Compose:

- PostgreSQL
- Kafka & ZooKeeper
- Kafka Connect (Debezium)
- Flink (JobManager / TaskManager)
- OpenSearch

With this setup, you can experience how CDC (Change Data Capture) from a relational database can be integrated into a real-time searchable index.

---

## 🚀 Quickstart

### Prerequisites

- Docker (Docker Desktop or CLI)
- Docker Compose v2 or later

### 1. Clone the repository

```bash
git clone https://github.com/your-username/flink-opensearch-pipeline.git
cd flink-opensearch-pipeline
```

### 2. Start the services

```bash
docker compose up -d
```

The following services will be started:
- PostgreSQL
- Kafka & ZooKeeper
- Kafka Connect（Debezium）
- Flink JobManager / TaskManager
- OpenSearch

### 3. PostgreSQL will be initialized automatically

The `postgres/00-init.sql` script will create a sample table `testtable` upon startup.

### 4. Register the Debezium connector for PostgreSQL

Run the following script to register the Debezium connector:

```bash
bash scripts/01-debezium-setup.sh
```

### 5. Check available Kafka topics
```bash
docker compose exec kafka kafka-topics \
  --bootstrap-server localhost:9092 \
  --list
```

### 6. Confirm CDC events in Kafka
```bash
docker compose exec kafka kafka-console-consumer \
  --bootstrap-server localhost:9092 \
  --topic dbserver1.public.testtable \
  --from-beginning
```

### 📁 Directory Structure
```bash
.
├── docker/                # Docker Compose configuration
├── postgres/              # PostgreSQL initialization scripts
├── flink/
│   ├── sql/               # Flink SQL job definitions (CDC → OpenSearch, etc.)
│   ├── lib/ext/           # External connector JARs for Flink
│   └── entrypoints/       # Flink entrypoint scripts
└── opensearch/            # OpenSearch index definitions
```

### 🔎 Notes
- OpenSearch Dashboards: http://localhost:5601
- Flink Web UI: http://localhost:8081

Once all services are running, you can:
- Submit Flink SQL jobs located in `flink/sql/`
- Access OpenSearch Dashboards at `http://localhost:5601` to explore indexed data
- Explore the Flink Web UI at `http://localhost:8081`

### 📄 License
Apache License 2.0

### 📘 About the Guidebook
This repository accompanies the technical guide (in Japanese) published on Zenn:

→ [[Read the full guide on Zenn (in Japanese)]](https://zenn.dev/sisiodos/books/4d81a988255bf0)

