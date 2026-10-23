-- Small deterministic starter dataset. For meaningful performance testing,
-- scale this dataset up (see README.md) before collecting timing results.
INSERT INTO customers (customer_name, email, city)
VALUES
 ('Aarav Kumar', 'aarav@example.com', 'Chennai'),
 ('Meera Raj', 'meera@example.com', 'Coimbatore'),
 ('Kavin Das', 'kavin@example.com', 'Nagercoil')
ON CONFLICT (email) DO NOTHING;

INSERT INTO products (product_name, category, price, stock_quantity)
SELECT v.product_name, v.category, v.price, v.stock_quantity
FROM (VALUES
 ('Wireless Mouse', 'Accessories', 799.00::numeric, 120),
 ('Mechanical Keyboard', 'Accessories', 2499.00::numeric, 45),
 ('USB-C Hub', 'Accessories', 1599.00::numeric, 70),
 ('Laptop Stand', 'Office', 999.00::numeric, 30)
) AS v(product_name, category, price, stock_quantity)
WHERE NOT EXISTS (
    SELECT 1 FROM products p WHERE p.product_name = v.product_name
);

INSERT INTO orders (customer_id, order_date, status, total_amount)
SELECT c.customer_id,
       TIMESTAMP '2026-01-01 09:00:00' + (g.n || ' days')::interval,
       CASE WHEN g.n % 3 = 0 THEN 'Completed'
            WHEN g.n % 3 = 1 THEN 'Shipped'
            ELSE 'Pending' END,
       (500 + (g.n % 20) * 125)::numeric(12,2)
FROM generate_series(0, 89) AS g(n)
CROSS JOIN LATERAL (
    SELECT customer_id FROM customers ORDER BY customer_id LIMIT 1 OFFSET (g.n % (SELECT COUNT(*) FROM customers))
) c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.order_date = TIMESTAMP '2026-01-01 09:00:00' + (g.n || ' days')::interval
);

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT o.order_id, p.product_id, 1 + (o.order_id % 3)::int, p.price
FROM orders o
CROSS JOIN LATERAL (
    SELECT product_id, price FROM products
    ORDER BY product_id
    LIMIT 1 OFFSET ((o.order_id - 1) % (SELECT COUNT(*) FROM products))
) p
WHERE NOT EXISTS (
    SELECT 1 FROM order_items oi
    WHERE oi.order_id = o.order_id AND oi.product_id = p.product_id
);
