-- Dashboard filter template:
-- Use parameters from your reporting tool where supported, or replace dates.
-- Keep the date filter half-open so timestamp values on the end date are handled correctly.
SELECT
    DATE_TRUNC('month', o.order_date)::date AS sales_month,
    o.status,
    COUNT(*) AS order_count,
    SUM(o.total_amount) AS sales_amount
FROM orders o
WHERE o.order_date >= TIMESTAMP '2026-01-01'
  AND o.order_date <  TIMESTAMP '2026-04-01'
GROUP BY DATE_TRUNC('month', o.order_date), o.status
ORDER BY sales_month, o.status;
