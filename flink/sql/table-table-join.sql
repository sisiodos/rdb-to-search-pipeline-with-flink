-- products テーブル（lookup 用）
-- Debezium JSON として扱う
CREATE TABLE products (
  product_id STRING,
  product_name STRING,
  category_id STRING,
  PRIMARY KEY (product_id) NOT ENFORCED
) WITH (
  'connector' = 'kafka',
  'topic' = 'dbserver1.public.products',
  'properties.bootstrap.servers' = 'kafka:9092',
  'format' = 'debezium-json',
  'scan.startup.mode' = 'earliest-offset'
);

-- orders テーブル（Debeziumから受け取る raw データ）
-- Debezium JSON として扱う
CREATE TABLE orders (
  order_id STRING,
  order_time STRING,
  customer_id STRING,
  product_id STRING,
  quantity INT,
  price DOUBLE,
  proc_time AS PROCTIME()
) WITH (
  'connector' = 'kafka',
  'topic' = 'dbserver1.public.orders',
  'properties.bootstrap.servers' = 'kafka:9092',
  'format' = 'debezium-json',
  'scan.startup.mode' = 'earliest-offset'
);

-- マテビュー的な結合テーブル
CREATE TABLE orders_with_products (
  order_id STRING,
  product_id STRING,
  product_name STRING,
  category_id STRING,
  quantity INT,
  price DOUBLE,
  PRIMARY KEY (order_id, product_id) NOT ENFORCED
) WITH (
  -- 検証用。後に OpenSearch に差し替え可能
  -- 'connector' = 'print'
  'connector' = 'opensearch-2',
  'hosts' = 'http://opensearch:9200',
  'allow-insecure' = 'true',
  'index' = 'orders_with_products',
  'document-id.key-delimiter' = '$',
  'sink.bulk-flush.max-size' = '1mb'
);

-- ビュー定義も可能（オプション）
CREATE VIEW orders_with_products_view AS
SELECT
  o.order_id,
  o.product_id,
  p.product_name,
  p.category_id,
  o.quantity,
  o.price
FROM orders o
LEFT JOIN products p ON o.product_id = p.product_id;

-- テーブル同士の結合
INSERT INTO orders_with_products
SELECT *
FROM orders_with_products_view;