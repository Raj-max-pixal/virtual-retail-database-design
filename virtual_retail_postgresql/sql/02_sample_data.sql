-- Sample data for the Virtual Retail Database
-- Run after 01_schema.sql.

BEGIN;
SET search_path TO retail, public;

INSERT INTO customers (customer_id, first_name, last_name, email, phone) VALUES
(1, 'Aarav', 'Sharma', 'aarav.sharma@example.com', '+91-9000000001'),
(2, 'Diya', 'Iyer', 'diya.iyer@example.com', '+91-9000000002'),
(3, 'Kabir', 'Nair', 'kabir.nair@example.com', '+91-9000000003');

INSERT INTO customer_addresses
(address_id, customer_id, address_type, recipient_name, address_line1, city, state_region, postal_code, country_code, is_default)
VALUES
(1, 1, 'both', 'Aarav Sharma', '12 Lake View Road', 'Chennai', 'Tamil Nadu', '600028', 'IN', TRUE),
(2, 2, 'shipping', 'Diya Iyer', '44 Temple Street', 'Coimbatore', 'Tamil Nadu', '641001', 'IN', TRUE),
(3, 3, 'shipping', 'Kabir Nair', '8 Marine Drive', 'Kochi', 'Kerala', '682011', 'IN', TRUE);

INSERT INTO categories (category_id, category_name, description) VALUES
(1, 'Electronics', 'Consumer electronics and accessories'),
(2, 'Home', 'Home and kitchen products'),
(3, 'Books', 'Printed and digital books');

INSERT INTO products (product_id, sku, product_name, description, category_id, unit_price, currency_code) VALUES
(1, 'ELEC-001', 'Wireless Mouse', 'Wireless optical mouse', 1, 799.00, 'INR'),
(2, 'ELEC-002', 'USB-C Charger', 'Fast USB-C wall charger', 1, 1299.00, 'INR'),
(3, 'HOME-001', 'Insulated Bottle', '750 ml reusable bottle', 2, 499.00, 'INR'),
(4, 'BOOK-001', 'SQL Fundamentals', 'Introductory SQL learning book', 3, 650.00, 'INR');

INSERT INTO inventory (product_id, quantity_on_hand, reorder_level) VALUES
(1, 40, 10), (2, 25, 8), (3, 60, 12), (4, 18, 5);

INSERT INTO customer_orders
(order_id, order_number, customer_id, order_status, order_date, currency_code,
 subtotal, discount_amount, tax_amount, shipping_amount, total_amount,
 ship_to_name, ship_to_line1, ship_to_city, ship_to_state, ship_to_postal, ship_to_country)
VALUES
(1, 'VR-2026-0001', 1, 'delivered', CURRENT_TIMESTAMP - INTERVAL '7 days', 'INR',
 1598.00, 0.00, 79.90, 40.00, 1717.90,
 'Aarav Sharma', '12 Lake View Road', 'Chennai', 'Tamil Nadu', '600028', 'IN'),
(2, 'VR-2026-0002', 2, 'processing', CURRENT_TIMESTAMP - INTERVAL '2 days', 'INR',
 1299.00, 100.00, 59.95, 40.00, 1298.95,
 'Diya Iyer', '44 Temple Street', 'Coimbatore', 'Tamil Nadu', '641001', 'IN'),
(3, 'VR-2026-0003', 3, 'pending', CURRENT_TIMESTAMP, 'INR',
 650.00, 0.00, 32.50, 0.00, 682.50,
 'Kabir Nair', '8 Marine Drive', 'Kochi', 'Kerala', '682011', 'IN');

INSERT INTO order_items
(order_item_id, order_id, product_id, sku_snapshot, product_name_snapshot, quantity, unit_price, discount_amount, line_total)
VALUES
(1, 1, 1, 'ELEC-001', 'Wireless Mouse', 2, 799.00, 0.00, 1598.00),
(2, 2, 2, 'ELEC-002', 'USB-C Charger', 1, 1299.00, 100.00, 1199.00),
(3, 3, 4, 'BOOK-001', 'SQL Fundamentals', 1, 650.00, 0.00, 650.00);

INSERT INTO payments
(payment_id, order_id, payment_reference, payment_method, payment_status, amount, currency_code, paid_at)
VALUES
(1, 1, 'PAY-DEMO-0001', 'upi', 'captured', 1717.90, 'INR', CURRENT_TIMESTAMP - INTERVAL '7 days'),
(2, 2, 'PAY-DEMO-0002', 'card', 'authorized', 1298.95, 'INR', NULL),
(3, 3, 'PAY-DEMO-0003', 'cash_on_delivery', 'initiated', 682.50, 'INR', NULL);

INSERT INTO shipments
(shipment_id, order_id, carrier, tracking_number, shipment_status, shipped_at, delivered_at)
VALUES
(1, 1, 'Demo Express', 'DEMO-TRACK-0001', 'delivered',
 CURRENT_TIMESTAMP - INTERVAL '6 days', CURRENT_TIMESTAMP - INTERVAL '5 days'),
(2, 2, 'Demo Express', 'DEMO-TRACK-0002', 'pending', NULL, NULL);

INSERT INTO inventory_movements
(product_id, movement_type, quantity_change, reference_type, reference_id, note)
VALUES
(1, 'receipt', 42, 'purchase_order', 1001, 'Opening stock receipt; illustrative audit record'),
(1, 'sale', -2, 'order', 1, 'Two wireless mice sold in order VR-2026-0001'),
(2, 'receipt', 25, 'purchase_order', 1002, 'Opening stock receipt'),
(3, 'receipt', 60, 'purchase_order', 1003, 'Opening stock receipt'),
(4, 'receipt', 19, 'purchase_order', 1004, 'Opening stock receipt'),
(4, 'sale', -1, 'order', 3, 'One SQL Fundamentals book sold');

-- Keep identity sequences aligned after explicit IDs were inserted.
SELECT setval(pg_get_serial_sequence('retail.customers','customer_id'), COALESCE((SELECT MAX(customer_id) FROM retail.customers), 1));
SELECT setval(pg_get_serial_sequence('retail.customer_addresses','address_id'), COALESCE((SELECT MAX(address_id) FROM retail.customer_addresses), 1));
SELECT setval(pg_get_serial_sequence('retail.categories','category_id'), COALESCE((SELECT MAX(category_id) FROM retail.categories), 1));
SELECT setval(pg_get_serial_sequence('retail.products','product_id'), COALESCE((SELECT MAX(product_id) FROM retail.products), 1));
SELECT setval(pg_get_serial_sequence('retail.customer_orders','order_id'), COALESCE((SELECT MAX(order_id) FROM retail.customer_orders), 1));
SELECT setval(pg_get_serial_sequence('retail.order_items','order_item_id'), COALESCE((SELECT MAX(order_item_id) FROM retail.order_items), 1));
SELECT setval(pg_get_serial_sequence('retail.payments','payment_id'), COALESCE((SELECT MAX(payment_id) FROM retail.payments), 1));
SELECT setval(pg_get_serial_sequence('retail.shipments','shipment_id'), COALESCE((SELECT MAX(shipment_id) FROM retail.shipments), 1));

COMMIT;
