-- Basic validation checks. Each query should return zero rows unless stated.
SET search_path TO retail, public;

-- 1. Orders whose item line totals do not equal the order subtotal.
SELECT o.order_id, o.order_number, o.subtotal,
       COALESCE(SUM(oi.line_total), 0) AS calculated_subtotal
FROM customer_orders o
LEFT JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, o.order_number, o.subtotal
HAVING o.subtotal <> COALESCE(SUM(oi.line_total), 0);

-- 2. Order totals that do not satisfy the configured total formula.
SELECT order_id, order_number, subtotal, discount_amount, tax_amount, shipping_amount, total_amount
FROM customer_orders
WHERE total_amount <> subtotal - discount_amount + tax_amount + shipping_amount;

-- 3. Orphaned order items (foreign keys should prevent these).
SELECT oi.order_item_id
FROM order_items oi
LEFT JOIN customer_orders o ON o.order_id = oi.order_id
LEFT JOIN products p ON p.product_id = oi.product_id
WHERE o.order_id IS NULL OR p.product_id IS NULL;

-- 4. Inventory rows below zero (check constraint should prevent these).
SELECT product_id, quantity_on_hand
FROM inventory
WHERE quantity_on_hand < 0;

-- 5. Duplicate customer emails (unique constraint should prevent these).
SELECT LOWER(email) AS normalized_email, COUNT(*)
FROM customers
GROUP BY LOWER(email)
HAVING COUNT(*) > 1;

-- 6. Useful row-count smoke test; expected counts with sample data:
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'customer_orders', COUNT(*) FROM customer_orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items;

-- Note: sample data contains illustrative inventory movements and is not a
-- production stock reconciliation. Run all scripts in a test database first.
