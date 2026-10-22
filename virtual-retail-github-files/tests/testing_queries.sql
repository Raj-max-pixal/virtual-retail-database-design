-- Virtual Retail Database: Testing / Validation Queries
-- PostgreSQL 14+
-- Run after sql/01_schema.sql and sql/02_sample_data.sql.
-- Most validation queries below should return ZERO rows when data is valid.
SET search_path TO retail, public;

-- TEST 1: Check for orders whose total does not match the order-total formula.
SELECT order_id, order_number, subtotal, discount_amount, tax_amount, shipping_amount, total_amount
FROM customer_orders
WHERE total_amount <> subtotal - discount_amount + tax_amount + shipping_amount;

-- TEST 2: Check whether an order's subtotal matches the sum of its line totals.
-- NOTE: this may return rows if discounts/tax are modelled at different levels;
-- investigate rather than assuming every result is a schema failure.
SELECT o.order_id, o.order_number, o.subtotal,
       COALESCE(SUM(oi.line_total), 0) AS item_subtotal
FROM customer_orders o
LEFT JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, o.order_number, o.subtotal
HAVING o.subtotal <> COALESCE(SUM(oi.line_total), 0);

-- TEST 3: Check for order items without a matching order or product.
-- Foreign keys should prevent these orphan rows.
SELECT oi.order_item_id
FROM order_items oi
LEFT JOIN customer_orders o ON o.order_id = oi.order_id
LEFT JOIN products p ON p.product_id = oi.product_id
WHERE o.order_id IS NULL OR p.product_id IS NULL;

-- TEST 4: Check for duplicate email addresses, ignoring letter case.
-- The schema's UNIQUE constraint is case-sensitive unless a lower-case index is added.
SELECT LOWER(email) AS normalized_email, COUNT(*) AS duplicate_count
FROM customers
GROUP BY LOWER(email)
HAVING COUNT(*) > 1;

-- TEST 5: Check for products without inventory records.
SELECT p.product_id, p.sku, p.product_name
FROM products p
LEFT JOIN inventory i ON i.product_id = p.product_id
WHERE i.product_id IS NULL;

-- TEST 6: Find inventory items at or below their reorder level.
-- This is an operational alert, so rows can be expected.
SELECT p.sku, p.product_name, i.quantity_on_hand, i.reorder_level
FROM inventory i
JOIN products p ON p.product_id = i.product_id
WHERE i.quantity_on_hand <= i.reorder_level
ORDER BY i.quantity_on_hand, p.product_name;

-- TEST 7: Check for invalid order/payment/shipment status values.
-- CHECK constraints should prevent these values.
SELECT order_id AS record_id, 'order' AS record_type, order_status AS status
FROM customer_orders
WHERE order_status NOT IN ('pending','confirmed','processing','shipped','delivered','cancelled','refunded')
UNION ALL
SELECT payment_id, 'payment', payment_status
FROM payments
WHERE payment_status NOT IN ('initiated','authorized','captured','failed','refunded','partially_refunded')
UNION ALL
SELECT shipment_id, 'shipment', shipment_status
FROM shipments
WHERE shipment_status NOT IN ('pending','packed','shipped','in_transit','delivered','returned','lost');

-- TEST 8: Check for negative inventory.
SELECT product_id, quantity_on_hand
FROM inventory
WHERE quantity_on_hand < 0;

-- TEST 9: Check for order items with invalid calculated line totals.
SELECT order_item_id, quantity, unit_price, discount_amount, line_total
FROM order_items
WHERE line_total <> quantity * unit_price - discount_amount;

-- TEST 10: Check for payments whose order does not exist.
-- Foreign keys should prevent these orphan rows.
SELECT p.payment_id, p.order_id
FROM payments p
LEFT JOIN customer_orders o ON o.order_id = p.order_id
WHERE o.order_id IS NULL;

-- TEST 11: Smoke test: row counts for core entities.
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL SELECT 'categories', COUNT(*) FROM categories
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'inventory', COUNT(*) FROM inventory
UNION ALL SELECT 'customer_orders', COUNT(*) FROM customer_orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'payments', COUNT(*) FROM payments
UNION ALL SELECT 'shipments', COUNT(*) FROM shipments
UNION ALL SELECT 'inventory_movements', COUNT(*) FROM inventory_movements
ORDER BY table_name;

-- TEST 12: Confirm expected key relationships by listing orders and customer names.
SELECT o.order_number, c.first_name, c.last_name, o.order_status, o.total_amount
FROM customer_orders o
JOIN customers c ON c.customer_id = o.customer_id
ORDER BY o.order_date DESC;

-- TEST 13: Check inventory movement records referencing unknown products.
SELECT m.movement_id, m.product_id
FROM inventory_movements m
LEFT JOIN products p ON p.product_id = m.product_id
WHERE p.product_id IS NULL;

-- TEST 14: Check shipment date ordering.
SELECT shipment_id, shipped_at, delivered_at
FROM shipments
WHERE delivered_at IS NOT NULL
  AND shipped_at IS NOT NULL
  AND delivered_at < shipped_at;

-- TEST 15: Review query plan for customer order history.
-- EXPLAIN ANALYZE executes the query; use on test data, not blindly on production.
EXPLAIN (ANALYZE, BUFFERS)
SELECT order_id, order_number, order_date, order_status, total_amount
FROM customer_orders
WHERE customer_id = 1
ORDER BY order_date DESC;

-- Interpretation:
-- Tests 1, 3, 5 (if every product must be stocked), 8, 9, 10, 13, 14 should
-- return zero rows for a clean dataset. Test 4 should return zero rows if emails
-- are expected to be unique regardless of case. Test 2 requires business-rule
-- review if order subtotal and line totals use different discount conventions.
-- Test 6 is an alert query and may legitimately return rows.
-- Test 11 should show counts; it is not a pass/fail test.
