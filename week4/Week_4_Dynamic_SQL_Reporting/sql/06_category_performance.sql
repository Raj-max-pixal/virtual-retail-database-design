-- Report 6: Category contribution to revenue
WITH category_sales AS (
    SELECT
        p.category,
        SUM(oi.quantity * oi.unit_price) AS category_revenue
    FROM order_items oi
    JOIN orders o ON o.order_id = oi.order_id
    JOIN products p ON p.product_id = oi.product_id
    WHERE o.status <> 'Cancelled'
    GROUP BY p.category
)
SELECT
    category,
    category_revenue,
    ROUND(
        100.0 * category_revenue / NULLIF(SUM(category_revenue) OVER (), 0),
        2
    ) AS revenue_share_percent
FROM category_sales
ORDER BY category_revenue DESC;
