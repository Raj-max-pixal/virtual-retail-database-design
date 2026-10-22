# Virtual Retail Database Design (PostgreSQL)

A portfolio project modelling a virtual retail environment with customers, addresses, categories, products, inventory, orders, order items, payments, shipments, and an inventory movement audit ledger.

## Technology
- PostgreSQL 14+
- SQL DDL, constraints, indexes, joins, aggregation, and validation queries

## Repository layout
```text
sql/
  01_schema.sql
  02_sample_data.sql
  03_analytics_queries.sql
  04_indexes.sql
tests/
  validation_queries.sql
```

## Setup
1. Create a development database in PostgreSQL, for example `virtual_retail`.
2. Open a SQL client such as `psql` or pgAdmin and run these scripts in order:
   - `sql/01_schema.sql`
   - `sql/02_sample_data.sql`
   - `sql/03_analytics_queries.sql` (run individual queries as needed)
   - `sql/04_indexes.sql` (optional; includes additional indexes)
3. Run `tests/validation_queries.sql` to inspect the data and validate key assumptions.

Example using `psql`:
```bash
createdb virtual_retail
psql -d virtual_retail -f sql/01_schema.sql
psql -d virtual_retail -f sql/02_sample_data.sql
psql -d virtual_retail -f tests/validation_queries.sql
```

## Main design choices
- Primary and foreign keys maintain entity relationships.
- `NUMERIC(12,2)` stores currency values without floating-point rounding.
- `CHECK` constraints validate status values and non-negative amounts.
- Order item name/SKU and delivery address snapshots preserve transaction-time details.
- Inventory movements record stock events for auditability.
- Indexes support common joins, customer order history, status filters, and reporting.

## Important notes
- The included sample records are fictional demonstration data.
- These scripts are a learning/portfolio baseline, not a production-ready commerce system.
- A real deployment should add transaction-safe stock reservation, payment-provider integration, role-based access control, migrations, backup/restore procedures, and automated integration tests.
- The validation script is provided for you to run; do not claim tests passed until you have executed them in PostgreSQL and reviewed the results.

## Documentation
Upload your Week 1 architecture/design Word document into `docs/` in this repository, then update this README with its exact filename and any ERD/architecture images you add.
