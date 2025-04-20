-- test/sql/cdc_to_console.sql
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

CREATE TABLE print_sink (
  id INT,
  message STRING
) WITH (
  'connector' = 'print'
);

INSERT INTO print_sink
SELECT * FROM cdc_source;
