-- Report 4: Customer value segments by lifetime spend
WITH customer_spend AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.city,
        COUNT(DISTINCT o.order_id) AS order_count,
        COALESCE(SUM(o.total_amount), 0) AS lifetime_spend
    FROM customers c
    LEFT JOIN orders o
      ON o.customer_id = c.customer_id
     AND o.status <> 'Cancelled'
    GROUP BY c.customer_id, c.customer_name, c.city
)
SELECT
    customer_id,
    customer_name,
    city,
    order_count,
    lifetime_spend,
    CASE
        WHEN lifetime_spend >= 10000 THEN 'High value'
        WHEN lifetime_spend >= 3000 THEN 'Medium value'
        ELSE 'Developing'
    END AS customer_segment
FROM customer_spend
ORDER BY lifetime_spend DESC;
