-- ETL validation queries. Run after loading staging rows and/or target tables.
SET search_path TO etl, retail, public;

-- A. Batch summary (rows extracted/rejected and batch status).
SELECT batch_id, source_name, source_file, batch_status,
       extracted_rows, accepted_rows, rejected_rows, inserted_rows, updated_rows,
       started_at, finished_at, error_message
FROM etl.etl_batch
ORDER BY batch_id DESC;

-- B. Rejected records by reason.
SELECT source_entity, reject_reason, COUNT(*) AS rejected_count
FROM etl.etl_reject
GROUP BY source_entity, reject_reason
ORDER BY rejected_count DESC;

-- C. Duplicate normalized emails in staging (should be reviewed/deduplicated).
SELECT LOWER(BTRIM(email)) AS normalized_email, COUNT(*) AS row_count
FROM etl.stg_customers
WHERE NULLIF(BTRIM(email), '') IS NOT NULL
GROUP BY LOWER(BTRIM(email))
HAVING COUNT(*) > 1;

-- D. Target orders whose totals violate the agreed formula (expect zero rows).
SELECT order_id, order_number, total_amount,
       subtotal - discount_amount + tax_amount + shipping_amount AS calculated_total
FROM retail.customer_orders
WHERE total_amount <> subtotal - discount_amount + tax_amount + shipping_amount;

-- E. Target order items with invalid line totals (expect zero rows).
SELECT order_item_id
FROM retail.order_items
WHERE line_total <> quantity * unit_price - discount_amount;

-- F. Source/target row-count reconciliation template.
-- Replace :batch_id with the batch ID in your SQL client.
-- SELECT ... from staging WHERE batch_id = :batch_id and compare with accepted/rejected counts.
