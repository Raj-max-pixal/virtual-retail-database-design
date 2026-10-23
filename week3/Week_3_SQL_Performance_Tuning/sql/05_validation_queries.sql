-- Sanity checks: use these to verify that data and query results remain sensible.
SELECT COUNT(*) AS customer_count FROM customers;
SELECT COUNT(*) AS product_count FROM products;
SELECT COUNT(*) AS order_count FROM orders;
SELECT COUNT(*) AS order_item_count FROM order_items;

-- Check for order items whose order or product is missing (should return zero rows).
SELECT oi.*
FROM order_items oi
LEFT JOIN orders o ON o.order_id = oi.order_id
LEFT JOIN products p ON p.product_id = oi.product_id
WHERE o.order_id IS NULL OR p.product_id IS NULL;

-- Query timing worksheet helper: note results manually after running EXPLAIN ANALYZE.
-- Run baseline and optimized versions against the SAME data and environment.
