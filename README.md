# Week 2 — Virtual Retail ETL Implementation

This project extends the Week 1 PostgreSQL retail schema with an ETL implementation scaffold.

## Folder layout
- `source_data/`: fictional source CSVs. They intentionally include a duplicate customer, a missing email, an invalid price, an unknown customer reference, and an invalid status to demonstrate data-quality handling.
- `sql/01_etl_staging_schema.sql`: batch audit, staging, and reject tables.
- `sql/02_transformations.sql`: cleaning, standardization, duplicate selection, and validation views.
- `sql/03_load_targets.sql`: example idempotent upserts for customers, categories, and products.
- `sql/04_etl_validation.sql`: reconciliation and quality queries.
- `sql/05_csv_import_notes.sql`: notes for loading source CSVs into staging.
- `logs/`: reserved for actual run logs after execution.
- `docs/`: place the Week 2 ETL planning report and flowchart here.

## Prerequisites
- PostgreSQL 14+
- Week 1 target schema (`retail`) created using the Week 1 `01_schema.sql`.
- Run these scripts in a development database, not production.

## Suggested execution order
1. Run `sql/01_etl_staging_schema.sql`.
2. Import the CSVs into staging tables. Use `psql \copy` or pgAdmin import. Since staging tables require a `batch_id`, create a batch row first and add the batch ID during the staging insert. A robust approach is to import each CSV into a temporary/raw import table first, then insert rows into `etl.stg_*` with the batch ID.
3. Run `sql/02_transformations.sql`.
4. Inspect `etl.etl_reject` and the `etl.v_clean_*` views.
5. Run `sql/03_load_targets.sql` only after reviewing the clean views and confirming the Week 1 schema exists.
6. Run `sql/04_etl_validation.sql` and record actual results.

## Important implementation notes
- The SQL is a starter scaffold and requires review in your own database. Do not run the target load repeatedly without understanding upsert effects.
- The transformation views cast date/numeric fields; malformed values must be filtered or rejected before casts are attempted.
- The sample source CSVs include invalid examples deliberately. Check rejection counts and correct source data before accepting a batch.
- The load script currently merges customers/categories/products. Order loading is intentionally deferred until source-to-target customer ID mapping and order-item mapping are implemented.
- These scripts have not been executed against your PostgreSQL instance. Do not claim they passed until you run them and inspect the outputs.
