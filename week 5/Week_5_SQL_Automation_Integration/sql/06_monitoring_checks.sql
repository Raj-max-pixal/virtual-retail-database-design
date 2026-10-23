-- Basic operational checks for the automation workflow.

-- 1. Products at or below the example threshold
SELECT product_id, product_name, stock_quantity
FROM products
WHERE stock_quantity <= 10
ORDER BY stock_quantity, product_name;

-- 2. Unresolved low-stock alerts
SELECT alert_id, product_id, stock_quantity, threshold_quantity,
       alert_message, created_at
FROM inventory_alerts
WHERE resolved_at IS NULL
ORDER BY created_at DESC;

-- 3. Archive count by status
SELECT status, COUNT(*) AS archived_order_count,
       SUM(total_amount) AS archived_total
FROM archived_orders
GROUP BY status
ORDER BY status;

-- 4. Compare archive/source overlap (should be reviewed as part of archive validation)
SELECT COUNT(*) AS duplicate_ids_still_in_source
FROM archived_orders a
JOIN orders o ON o.order_id = a.order_id;
