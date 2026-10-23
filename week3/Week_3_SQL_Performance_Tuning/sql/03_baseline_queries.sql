-- Run each query with EXPLAIN (ANALYZE, BUFFERS) before adding the new indexes.
-- Record the actual execution time reported by PostgreSQL.

-- Q1: Recent orders
EXPLAIN (ANALYZE, BUFFERS)
SELECT order_id, customer_id, order_date, total_amount
FROM orders
WHERE order_date >= TIMESTAMP '2026-01-01'
ORDER BY order_date DESC;

-- Q2: Exact product lookup
EXPLAIN (ANALYZE, BUFFERS)
SELECT product_id, product_name, price, stock_quantity
FROM products
WHERE product_name = 'Wireless Mouse';

-- Q3: Daily sales; baseline intentionally applies DATE() to the filtered column
EXPLAIN (ANALYZE, BUFFERS)
SELECT DATE(order_date) AS sales_date, SUM(total_amount) AS total_sales
FROM orders
WHERE DATE(order_date) = DATE '2026-02-15'
GROUP BY DATE(order_date);

-- Q4: Customer order history
EXPLAIN (ANALYZE, BUFFERS)
SELECT order_id, customer_id, order_date, status, total_amount
FROM orders
WHERE customer_id = 1
ORDER BY order_date DESC;
