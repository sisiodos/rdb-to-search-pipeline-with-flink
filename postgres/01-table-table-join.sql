-- 商品テーブル
CREATE TABLE products (
  product_id VARCHAR(32) PRIMARY KEY,
  product_name VARCHAR(255),
  category_id VARCHAR(32)
);
ALTER TABLE products REPLICA IDENTITY FULL;

-- 初期データ投入
INSERT INTO products (product_id, product_name, category_id) VALUES
('P001', 'スニーカーX', 'C001'),
('P002', 'ジャケットY', 'C002');

-- 注文テーブル
CREATE TABLE orders (
  order_id VARCHAR(32) PRIMARY KEY,
  order_time TIMESTAMP,
  customer_id VARCHAR(32),
  product_id VARCHAR(32),
  quantity INT,
  price NUMERIC(10,2)
);
ALTER TABLE orders REPLICA IDENTITY FULL;

-- 初期データ投入
INSERT INTO orders (order_id, order_time, customer_id, product_id, quantity, price) VALUES
('O1001', '2025-04-27 10:00:00', 'CUST01', 'P001', 1, 9800.00),
('O1002', '2025-04-27 10:05:00', 'CUST02', 'P002', 2, 15800.00);

-- debezium ユーザーに SELECT 権限を与える
GRANT SELECT ON products, orders TO debezium;

-- publication の作成（両テーブル対象）
--CREATE IF NOT EXISTS PUBLICATION debezium_pub FOR TABLE products, orders;
ALTER PUBLICATION debezium_pub ADD TABLE products, orders;
