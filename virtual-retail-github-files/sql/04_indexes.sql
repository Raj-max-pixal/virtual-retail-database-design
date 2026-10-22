-- Optional performance indexes.
-- The core indexes are created by 01_schema.sql. Add these only if query plans
-- and production workload justify them; measure with EXPLAIN (ANALYZE, BUFFERS).

CREATE INDEX IF NOT EXISTS idx_orders_date
    ON retail.customer_orders(order_date DESC);

CREATE INDEX IF NOT EXISTS idx_orders_customer_status
    ON retail.customer_orders(customer_id, order_status);

CREATE INDEX IF NOT EXISTS idx_products_category_active
    ON retail.products(category_id, is_active);

CREATE INDEX IF NOT EXISTS idx_payments_status_created
    ON retail.payments(payment_status, created_at DESC);

-- Example query plan:
-- EXPLAIN (ANALYZE, BUFFERS)
-- SELECT order_id, order_number, total_amount
-- FROM retail.customer_orders
-- WHERE customer_id = 1
-- ORDER BY order_date DESC;
