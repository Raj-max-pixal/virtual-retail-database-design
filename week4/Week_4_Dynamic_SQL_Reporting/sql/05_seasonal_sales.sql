-- Report 5: Monthly trend and year-over-year comparison
-- Requires multiple years of order data for a meaningful YoY comparison.
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date)::date AS sales_month,
        SUM(total_amount) AS sales_amount
    FROM orders
    WHERE status <> 'Cancelled'
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    sales_month,
    sales_amount,
    LAG(sales_amount, 12) OVER (ORDER BY sales_month) AS sales_same_month_previous_year,
    ROUND(
        100.0 * (sales_amount - LAG(sales_amount, 12) OVER (ORDER BY sales_month))
        / NULLIF(LAG(sales_amount, 12) OVER (ORDER BY sales_month), 0),
        2
    ) AS yoy_change_percent
FROM monthly_sales
ORDER BY sales_month;
