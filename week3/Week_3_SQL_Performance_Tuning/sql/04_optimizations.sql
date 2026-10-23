-- Apply after recording baseline results.
-- Indexes should be justified by query patterns and measured on representative data.
CREATE INDEX IF NOT EXISTS idx_orders_order_date
    ON orders (order_date);

CREATE INDEX IF NOT EXISTS idx_products_product_name
    ON products (product_name);

CREATE INDEX IF NOT EXISTS idx_orders_customer_date
    ON orders (customer_id, order_date DESC);

ANALYZE orders;
ANALYZE products;
ANALYZE order_items;

-- Q1 optimized: explicit projection, date index can support filtering/order.
EXPLAIN (ANALYZE, BUFFERS)
SELECT order_id, customer_id, order_date, total_amount
FROM orders
WHERE order_date >= TIMESTAMP '2026-01-01'
ORDER BY order_date DESC;

-- Q2 optimized: same logical lookup, now supported by product_name index.
EXPLAIN (ANALYZE, BUFFERS)
SELECT product_id, product_name, price, stock_quantity
FROM products
WHERE product_name = 'Wireless Mouse';

-- Q3 optimized: half-open range avoids wrapping order_date in DATE().
EXPLAIN (ANALYZE, BUFFERS)
SELECT DATE(order_date) AS sales_date, SUM(total_amount) AS total_sales
FROM orders
WHERE order_date >= TIMESTAMP '2026-02-15'
  AND order_date <  TIMESTAMP '2026-02-16'
GROUP BY DATE(order_date);

-- Q4 optimized: composite index supports customer filter and descending date order.
EXPLAIN (ANALYZE, BUFFERS)
SELECT order_id, customer_id, order_date, status, total_amount
FROM orders
WHERE customer_id = 1
ORDER BY order_date DESC;
