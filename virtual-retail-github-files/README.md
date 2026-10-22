# Virtual Retail Database Design

A PostgreSQL portfolio project for a virtual retail business. It models customers, addresses, categories, products, inventory, orders, order items, payments, shipments, and inventory movements.

## Repository layout

```text
virtual-retail-database-design/
├── README.md
├── sql/
│   ├── 01_schema.sql
│   ├── 02_sample_data.sql
│   ├── 03_analytics_queries.sql
│   └── 04_indexes.sql
├── sample-dataset/
│   ├── customers.csv
│   ├── categories.csv
│   ├── products.csv
│   ├── inventory.csv
│   ├── orders.csv
│   ├── order_items.csv
│   ├── payments.csv
│   ├── shipments.csv
│   └── inventory_movements.csv
├── tests/
│   ├── testing_queries.sql
│   └── optional_constraint_tests.sql
├── diagrams/
└── docs/
```

## Run the SQL scripts

Requires PostgreSQL 14 or newer. Create a development database, then run:

```bash
createdb virtual_retail
psql -d virtual_retail -f sql/01_schema.sql
psql -d virtual_retail -f sql/02_sample_data.sql
psql -d virtual_retail -f tests/testing_queries.sql
```

Run selected queries from `sql/03_analytics_queries.sql` to explore reporting. `sql/04_indexes.sql` adds optional indexes; measure query plans before using additional indexes in production.

## Design highlights

- Primary keys, foreign keys, uniqueness, and check constraints
- Decimal currency values with `NUMERIC(12,2)`
- Order-item snapshots and delivery-address snapshot fields
- Inventory movement audit ledger
- Indexes for common joins, order history, and operational filters
- Validation queries for consistency and referential integrity

## Important

Sample data is fictional. The scripts are a learning/portfolio baseline, not a production-ready commerce system. They have not been executed against your PostgreSQL environment; run them and inspect the outputs before claiming that tests passed. The CSV dataset is separate from the SQL insert dataset, so validate it before importing. Put the architecture Word documents in `docs/` and the ERD image in `diagrams/` after aligning the diagram with the schema.
