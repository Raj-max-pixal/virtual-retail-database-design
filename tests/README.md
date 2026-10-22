# PostgreSQL Testing Queries

This folder contains validation SQL for the Virtual Retail Database project.

## Run
After creating the schema and loading sample data, run:
```bash
psql -d virtual_retail -f tests/testing_queries.sql
```

## What it checks
- Order total calculations
- Order subtotal vs. line totals
- Referential integrity / orphan records
- Duplicate customer emails (case-insensitive check)
- Inventory coverage and reorder alerts
- Allowed order, payment, and shipment statuses
- Negative inventory and invalid line totals
- Inventory movement references and shipment date consistency
- Query plan for customer order history

Some queries are diagnostic rather than strict pass/fail checks. Read the comments in `testing_queries.sql` before interpreting the results. The scripts have been generated but have not been executed against your local PostgreSQL database; run them and record the actual results before claiming tests passed.
