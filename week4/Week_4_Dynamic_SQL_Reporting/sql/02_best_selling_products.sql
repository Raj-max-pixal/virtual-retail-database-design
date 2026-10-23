-- Report 2: Best-selling products by units and revenue
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.unit_price) AS item_revenue
FROM order_items oi
JOIN orders o   ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_date >= TIMESTAMP '2026-01-01'
  AND o.order_date <  TIMESTAMP '2027-01-01'
  AND o.status <> 'Cancelled'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY units_sold DESC, item_revenue DESC
LIMIT 10;
