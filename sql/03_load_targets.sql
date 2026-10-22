-- Target merge examples for the Week 1 retail schema.
-- Prerequisite: retail schema exists; etl.v_clean_customers and etl.v_clean_products exist.
-- Mapping source IDs to target surrogate IDs is handled using stable business keys.

BEGIN;

-- Load categories before products.
INSERT INTO retail.categories (category_name, description)
SELECT DISTINCT category_name, 'Loaded through Week 2 ETL demonstration'
FROM etl.v_clean_products
WHERE category_name IS NOT NULL
ON CONFLICT (category_name) DO NOTHING;

-- Load customers using normalized email as the target match key.
INSERT INTO retail.customers (first_name, last_name, email, phone, created_at)
SELECT first_name, last_name, email, phone, COALESCE(source_updated_at, CURRENT_TIMESTAMP)
FROM etl.v_clean_customers
ON CONFLICT (email) DO UPDATE
SET first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    phone = EXCLUDED.phone;

-- Load products using SKU as the stable business key.
INSERT INTO retail.products (sku, product_name, category_id, unit_price, currency_code, updated_at)
SELECT cp.sku, cp.product_name, c.category_id, cp.unit_price, cp.currency_code, COALESCE(cp.source_updated_at, CURRENT_TIMESTAMP)
FROM etl.v_clean_products cp
LEFT JOIN retail.categories c ON c.category_name = cp.category_name
ON CONFLICT (sku) DO UPDATE
SET product_name = EXCLUDED.product_name,
    category_id = EXCLUDED.category_id,
    unit_price = EXCLUDED.unit_price,
    currency_code = EXCLUDED.currency_code,
    updated_at = CURRENT_TIMESTAMP;

COMMIT;

-- Orders intentionally are not merged in this starter script because the source-to-target
-- customer ID mapping and order-item relationship must be defined explicitly before loading.
-- Use source_order_id -> order_number mapping and verify all totals before enabling order loads.
