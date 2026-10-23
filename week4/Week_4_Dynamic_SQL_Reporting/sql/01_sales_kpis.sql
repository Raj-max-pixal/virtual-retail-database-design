-- Report 1: Monthly sales KPIs
-- PostgreSQL | Change the date range as needed.
SELECT
    DATE_TRUNC('month', o.order_date)::date AS sales_month,
    COUNT(DISTINCT o.order_id) AS order_count,
    COUNT(DISTINCT o.customer_id) AS purchasing_customers,
    SUM(o.total_amount) AS gross_sales,
    AVG(o.total_amount) AS average_order_value
FROM orders o
WHERE o.order_date >= TIMESTAMP '2026-01-01'
  AND o.order_date <  TIMESTAMP '2027-01-01'
  AND o.status <> 'Cancelled'
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY sales_month;
