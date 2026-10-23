-- Report 3: Inventory risk / replenishment list
-- The threshold is illustrative; a real threshold should reflect lead time and demand.
SELECT
    product_id,
    product_name,
    category,
    stock_quantity,
    CASE
        WHEN stock_quantity = 0 THEN 'Out of stock'
        WHEN stock_quantity <= 10 THEN 'Critical'
        WHEN stock_quantity <= 25 THEN 'Low'
        ELSE 'Healthy'
    END AS stock_status
FROM products
WHERE stock_quantity <= 25
ORDER BY stock_quantity ASC, product_name;
