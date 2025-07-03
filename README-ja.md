# RDBと検索を繋ぐ：Flink・Kafka・OpenSearchで学ぶパイプライン設計

📖 [English version available here](./README.md)

本リポジトリは、技術ガイドブック「[RDBと検索を繋ぐ：Flink・Kafka・OpenSearchで学ぶパイプライン設計](https://zenn.dev/sisiodos/books/4d81a988255bf0)」で紹介されている OSS ベースのデータパイプライン構成を、すぐに手元で試せるようにまとめたものです。

## 構成概要

本リポジトリでは、以下のような構成を Docker Compose によって構築します。

この構成を用いて、リレーショナルデータベースの更新をリアルタイムで検索エンジンに連携する仕組みを、実際に体験しながら学ぶことができます。

---

## Quickstart

### 前提

- Docker（Docker Desktop または CLI）
- Docker Compose v2 以降

### 1. クローン

```bash
git clone https://github.com/your-username/flink-opensearch-pipeline.git
cd flink-opensearch-pipeline
```

### 2. サービスの起動
```bash
docker compose up -d
```

起動されるサービス：
- PostgreSQL
- Kafka & ZooKeeper
- Kafka Connect（Debezium）
- Flink JobManager / TaskManager
- OpenSearch

### 3. PostgreSQL に初期データ投入済み
`postgres/00-init.sql` により、自動的にサンプルテーブル testtable が作成されます。

### 4. Debezium コネクタの登録
以下のコマンドで PostgreSQL 用の Debezium コネクタを登録します。

```bash
bash scripts/01-debezium-setup.sh
```

### 5. Kafka トピックの確認
```bash
docker compose exec kafka kafka-topics \
  --bootstrap-server localhost:9092 \
  --list
```

### 6. CDC イベントの確認
```bash
docker compose exec kafka kafka-console-consumer \
  --bootstrap-server localhost:9092 \
  --topic dbserver1.public.testtable \
  --from-beginning
```

### フォルダ構成
```bash
.
├── docker/                # docker-compose.yaml（サービス定義）
├── postgres/              # PostgreSQL 初期化スクリプト
├── flink/
│   ├── sql/               # Flink SQL ジョブ定義（CDC → OpenSearch など）
│   ├── plugins/           # Flink の外部コネクタ JAR
│   └── entrypoints/       # Flink 実行用スクリプト
└── opensearch/            # OpenSearch インデックス定義
```
補足
- OpenSearch Dashboards は http://localhost:5601 でアクセス可能です。
- Flink Web UI は http://localhost:8081 でアクセス可能です。

### ライセンス
Apache License 2.0

### 本書について
このサンプルは、Zenn にて公開中の技術ガイド：
「RDBと検索を繋ぐ：Flink・Kafka・OpenSearchで学ぶパイプライン設計」
と連動しています。詳しくは以下をご覧ください：

→ [Zennで読む](https://zenn.dev/sisiodos/books/4d81a988255bf0)

