-- Transformation and quality-rule examples.
-- This script is intentionally staged: run only after loading source rows into etl.stg_*.
-- It shows deterministic cleaning and reject capture; target merges are in 03_load_targets.sql.

-- 1) Find customer records that fail required-field checks.
INSERT INTO etl.etl_reject (batch_id, source_entity, source_key, reject_reason, raw_record)
SELECT batch_id, 'customers', source_customer_id,
       'Missing required customer key/name/email',
       raw_record
FROM etl.stg_customers
WHERE NULLIF(BTRIM(source_customer_id), '') IS NULL
   OR NULLIF(BTRIM(first_name), '') IS NULL
   OR NULLIF(BTRIM(last_name), '') IS NULL
   OR NULLIF(BTRIM(email), '') IS NULL;

-- 2) Find products with missing SKU/name or invalid price.
INSERT INTO etl.etl_reject (batch_id, source_entity, source_key, reject_reason, raw_record)
SELECT batch_id, 'products', source_product_id,
       CASE
         WHEN NULLIF(BTRIM(sku), '') IS NULL OR NULLIF(BTRIM(product_name), '') IS NULL
           THEN 'Missing SKU or product name'
         WHEN unit_price_text !~ '^[0-9]+(\.[0-9]{1,2})?$' THEN 'Price is not a valid non-negative decimal'
         ELSE 'Price must be non-negative'
       END,
       raw_record
FROM etl.stg_products
WHERE NULLIF(BTRIM(sku), '') IS NULL
   OR NULLIF(BTRIM(product_name), '') IS NULL
   OR unit_price_text !~ '^[0-9]+(\.[0-9]{1,2})?$';

-- 3) Standardized customer view: trim values, lowercase email, uppercase country code.
CREATE OR REPLACE VIEW etl.v_clean_customers AS
SELECT DISTINCT ON (LOWER(BTRIM(email)))
       batch_id,
       NULLIF(BTRIM(source_customer_id), '') AS source_customer_id,
       NULLIF(BTRIM(first_name), '') AS first_name,
       NULLIF(BTRIM(last_name), '') AS last_name,
       LOWER(NULLIF(BTRIM(email), '')) AS email,
       NULLIF(BTRIM(phone), '') AS phone,
       NULLIF(BTRIM(city), '') AS city,
       NULLIF(BTRIM(state), '') AS state,
       UPPER(NULLIF(BTRIM(country_code), '')) AS country_code,
       updated_at_text::timestamptz AS source_updated_at
FROM etl.stg_customers
WHERE NULLIF(BTRIM(email), '') IS NOT NULL
  AND NULLIF(BTRIM(source_customer_id), '') IS NOT NULL
  AND NULLIF(BTRIM(first_name), '') IS NOT NULL
  AND NULLIF(BTRIM(last_name), '') IS NOT NULL
ORDER BY LOWER(BTRIM(email)), updated_at_text::timestamptz DESC NULLS LAST, staging_id DESC;

-- 4) Standardized products view. Invalid numeric values must be rejected before casting.
CREATE OR REPLACE VIEW etl.v_clean_products AS
SELECT DISTINCT ON (UPPER(BTRIM(sku)))
       batch_id,
       NULLIF(UPPER(BTRIM(sku)), '') AS sku,
       NULLIF(BTRIM(product_name), '') AS product_name,
       NULLIF(BTRIM(category_name), '') AS category_name,
       unit_price_text::numeric(12,2) AS unit_price,
       UPPER(COALESCE(NULLIF(BTRIM(currency_code), ''), 'INR')) AS currency_code,
       updated_at_text::timestamptz AS source_updated_at
FROM etl.stg_products
WHERE NULLIF(BTRIM(sku), '') IS NOT NULL
  AND NULLIF(BTRIM(product_name), '') IS NOT NULL
  AND unit_price_text ~ '^[0-9]+(\.[0-9]{1,2})?$'
ORDER BY UPPER(BTRIM(sku)), updated_at_text::timestamptz DESC NULLS LAST, staging_id DESC;

-- 5) Standardized order status mapping. Review mappings against the source system's documented semantics.
CREATE OR REPLACE VIEW etl.v_clean_orders AS
SELECT batch_id,
       NULLIF(BTRIM(source_order_id), '') AS source_order_id,
       NULLIF(BTRIM(order_number), '') AS order_number,
       NULLIF(BTRIM(source_customer_id), '') AS source_customer_id,
       CASE LOWER(BTRIM(order_status))
         WHEN 'pending' THEN 'pending'
         WHEN 'confirmed' THEN 'confirmed'
         WHEN 'processing' THEN 'processing'
         WHEN 'shipped' THEN 'shipped'
         WHEN 'delivered' THEN 'delivered'
         WHEN 'cancelled' THEN 'cancelled'
         WHEN 'refunded' THEN 'refunded'
         ELSE NULL
       END AS normalized_status,
       order_date_text::timestamptz AS order_date,
       subtotal_text::numeric(12,2) AS subtotal,
       discount_amount_text::numeric(12,2) AS discount_amount,
       tax_amount_text::numeric(12,2) AS tax_amount,
       shipping_amount_text::numeric(12,2) AS shipping_amount,
       total_amount_text::numeric(12,2) AS total_amount,
       UPPER(COALESCE(NULLIF(BTRIM(currency_code), ''), 'INR')) AS currency_code,
       raw_record
FROM etl.stg_orders
WHERE NULLIF(BTRIM(source_order_id), '') IS NOT NULL
  AND NULLIF(BTRIM(order_number), '') IS NOT NULL
  AND LOWER(BTRIM(order_status)) IN
      ('pending','confirmed','processing','shipped','delivered','cancelled','refunded')
  AND order_date_text IS NOT NULL
  AND subtotal_text ~ '^[0-9]+(\.[0-9]{1,2})?$'
  AND discount_amount_text ~ '^[0-9]+(\.[0-9]{1,2})?$'
  AND tax_amount_text ~ '^[0-9]+(\.[0-9]{1,2})?$'
  AND shipping_amount_text ~ '^[0-9]+(\.[0-9]{1,2})?$'
  AND total_amount_text ~ '^[0-9]+(\.[0-9]{1,2})?$';
