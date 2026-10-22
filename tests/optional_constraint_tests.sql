-- Optional constraint smoke tests (run individually and ROLLBACK after each).
-- These intentionally invalid statements should raise constraint errors.
-- Do NOT run as a batch unless you understand transaction abort behavior.

-- Negative test A: invalid order status (should fail CHECK constraint).
-- INSERT INTO retail.customer_orders
--   (order_number, customer_id, order_status, subtotal, discount_amount, tax_amount, shipping_amount, total_amount)
-- VALUES ('INVALID-STATUS-TEST', 1, 'not_a_status', 0, 0, 0, 0, 0);

-- Negative test B: negative stock (should fail CHECK constraint).
-- UPDATE retail.inventory SET quantity_on_hand = -1 WHERE product_id = 1;

-- Negative test C: zero quantity order item (should fail CHECK constraint).
-- INSERT INTO retail.order_items
--   (order_id, product_id, sku_snapshot, product_name_snapshot, quantity, unit_price, discount_amount, line_total)
-- VALUES (1, 1, 'ELEC-001', 'Wireless Mouse', 0, 799.00, 0.00, 0.00);

-- Uncomment and execute one test at a time in a disposable development database.
