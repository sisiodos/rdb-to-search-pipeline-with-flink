CREATE TABLE cdc_source (
  id INT,
  message STRING,
  PRIMARY KEY (id) NOT ENFORCED
) WITH (
  'connector' = 'kafka',
  'topic' = 'dbserver1.public.testtable',
  'properties.bootstrap.servers' = 'kafka:9092',
  'format' = 'debezium-json',
  'scan.startup.mode' = 'earliest-offset'
);

CREATE TABLE opensearch_sink (
  doc_id STRING,
  id INT,
  message STRING,
  PRIMARY KEY (id) NOT ENFORCED
) WITH (
  'connector' = 'opensearch-2',
  'hosts' = 'http://opensearch:9200',
  'allow-insecure' = 'true',
  'index' = 'test-index',
  'document-id.key-delimiter' = '$',
  'sink.bulk-flush.max-size' = '1mb');

INSERT INTO opensearch_sink
SELECT
  MD5(CAST(id AS STRING)) AS doc_id,
  id,
  message
FROM cdc_source;
