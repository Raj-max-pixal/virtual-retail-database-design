-- Analytics and operational queries
SET search_path TO retail, public;

-- 1. Revenue by calendar month (uses order totals for delivered orders).
SELECT DATE_TRUNC('month', order_date)::date AS month,
       currency_code,
       COUNT(*) AS delivered_orders,
       SUM(total_amount) AS revenue
FROM customer_orders
WHERE order_status = 'delivered'
GROUP BY 1, 2
ORDER BY 1 DESC, 2;

-- 2. Best-selling products by units sold (exclude cancelled orders).
SELECT oi.product_id, oi.product_name_snapshot,
       SUM(oi.quantity) AS units_sold,
       SUM(oi.line_total) AS merchandise_revenue
FROM order_items oi
JOIN customer_orders o ON o.order_id = oi.order_id
WHERE o.order_status NOT IN ('cancelled', 'refunded')
GROUP BY oi.product_id, oi.product_name_snapshot
ORDER BY units_sold DESC, merchandise_revenue DESC
LIMIT 10;

-- 3. Customer lifetime order value, excluding cancelled orders.
SELECT c.customer_id, c.first_name, c.last_name, c.email,
       COUNT(o.order_id) FILTER (WHERE o.order_status <> 'cancelled') AS order_count,
       COALESCE(SUM(o.total_amount) FILTER (WHERE o.order_status NOT IN ('cancelled','refunded')), 0) AS lifetime_value
FROM customers c
LEFT JOIN customer_orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
ORDER BY lifetime_value DESC;

-- 4. Products at or below reorder threshold.
SELECT p.product_id, p.sku, p.product_name,
       i.quantity_on_hand, i.reorder_level
FROM inventory i
JOIN products p ON p.product_id = i.product_id
WHERE i.quantity_on_hand <= i.reorder_level
ORDER BY i.quantity_on_hand, p.product_name;

-- 5. Orders with payment status.
SELECT o.order_number, o.order_status, o.total_amount,
       p.payment_method, p.payment_status, p.amount AS payment_amount
FROM customer_orders o
LEFT JOIN payments p ON p.order_id = o.order_id
ORDER BY o.order_date DESC;

-- 6. Fulfilment queue: orders awaiting shipment or delivery.
SELECT o.order_number, o.order_date, o.order_status,
       s.shipment_status, s.carrier, s.tracking_number
FROM customer_orders o
LEFT JOIN shipments s ON s.order_id = o.order_id
WHERE o.order_status IN ('confirmed','processing','shipped')
ORDER BY o.order_date;

-- 7. Daily order volume and gross order value.
SELECT order_date::date AS order_day,
       COUNT(*) AS orders,
       SUM(total_amount) AS gross_order_value
FROM customer_orders
WHERE order_status <> 'cancelled'
GROUP BY order_date::date
ORDER BY order_day DESC;

-- 8. Inventory movement history for one product (replace SKU as needed).
SELECT p.sku, p.product_name, m.movement_type, m.quantity_change,
       m.reference_type, m.reference_id, m.note, m.created_at
FROM inventory_movements m
JOIN products p ON p.product_id = m.product_id
WHERE p.sku = 'ELEC-001'
ORDER BY m.created_at DESC, m.movement_id DESC;
