# Week 3 — SQL Query Optimization and Performance Tuning

This project folder contains a Word report and PostgreSQL scripts for the Week 3 SQL Developer Intern task in the **Virtual Retail Database Design** repository.

## Contents
- `Week_3_SQL_Query_Optimization_and_Performance_Tuning.docx` — report template and technical explanation.
- `sql/01_schema.sql` — retail database schema.
- `sql/02_sample_data.sql` — small starter dataset.
- `sql/03_baseline_queries.sql` — baseline query plans.
- `sql/04_optimizations.sql` — indexes and rewritten queries.
- `sql/05_validation_queries.sql` — sanity checks.

## Requirements
- PostgreSQL 14+ recommended.
- A SQL client such as pgAdmin or `psql`.

## Run order
1. Create/select a test database.
2. Execute `sql/01_schema.sql`.
3. Execute `sql/02_sample_data.sql`.
4. Execute `sql/03_baseline_queries.sql` and record actual execution times.
5. Execute `sql/04_optimizations.sql` and record actual execution times again.
6. Execute `sql/05_validation_queries.sql`.
7. Update the report's performance table with your real measurements before submitting.

## Important measurement note
The included sample dataset is intentionally small so the scripts run quickly. It is useful for validating the workflow, but it is not sufficient to prove meaningful performance gains. For realistic testing, scale up the data in a separate test database (for example, use `generate_series` to create at least 100,000–1,000,000 orders and corresponding order items). Record the row counts, PostgreSQL version, machine specs, cache conditions, and execution plans.

Do not present illustrative or example timings as measured results. PostgreSQL may choose a sequential scan for small tables even when an index exists; this is normal. Indexes also add storage and write overhead.

## Suggested GitHub location
Add this folder's contents to the existing public repository:
`https://github.com/Raj-max-pixal/virtual-retail-database-design`

Suggested paths:
- `Week_3_SQL_Query_Optimization_and_Performance_Tuning.docx`
- `week-3/sql/`
- `week-3/README.md`
