-- debezium user
CREATE ROLE debezium WITH LOGIN PASSWORD 'dbz' REPLICATION;

-- CDC test table
CREATE TABLE testtable (
  id INTEGER PRIMARY KEY,
  message VARCHAR(255)
);
INSERT INTO testtable (id, message) VALUES (1, 'CDC test row');

-- debezium ユーザーに SELECT 権限を与える
GRANT SELECT ON testtable TO debezium;

-- publication作成
CREATE PUBLICATION debezium_pub FOR TABLE testtable;
