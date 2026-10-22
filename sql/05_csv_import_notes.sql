-- Run these commands in psql from the project root after creating the ETL tables.
-- Replace paths if your extracted folder is elsewhere.
-- Create a batch row first, then use its batch_id in the COPY command.
INSERT INTO etl.etl_batch (source_name, source_file)
VALUES ('customers_csv', 'source_data/customers_source.csv')
RETURNING batch_id;

-- Example: if returned batch_id is 1:
\copy etl.stg_customers(batch_id, source_customer_id, first_name, last_name, email, phone, city, state, country_code, updated_at_text) FROM 'source_data/customers_source.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')
-- NOTE: this direct example needs the batch_id column supplied for each CSV row; use a temporary table
-- or remove batch_id from the \copy target and then INSERT into staging with the batch ID.
-- Recommended practical method: import each CSV into a matching temp/raw table first, then INSERT into etl.stg_* with batch_id and raw_record.
