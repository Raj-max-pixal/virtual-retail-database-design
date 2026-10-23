# Week 5 — Automation and Integration of SQL Processes

PostgreSQL-oriented examples for the virtual retail database internship task.

## Files
- `Week_5_SQL_Automation_and_Integration_Report.docx` — report with automation strategy, code explanations, flow diagram, error handling, and scheduler setup.
- `sql/01_inventory_procedure.sql` — controlled stock deduction procedure.
- `sql/02_inventory_trigger.sql` — prevents negative stock.
- `sql/03_low_stock_alerts.sql` — records low-stock events in an alert table.
- `sql/04_archive_old_orders.sql` — example completed-order archive procedure.
- `sql/05_scheduled_tasks.md` — pg_cron and OS scheduler setup examples.
- `sql/06_monitoring_checks.sql` — operational verification queries.

## Assumed schema
The Week 3/4 project tables are expected: `products`, `orders`, `order_items`, and `customers`.

## Suggested run order
1. Confirm the base schema exists.
2. Run `01_inventory_procedure.sql`.
3. Run `02_inventory_trigger.sql`.
4. Run `03_low_stock_alerts.sql`.
5. Run `04_archive_old_orders.sql`.
6. Review `05_scheduled_tasks.md`; choose one scheduler appropriate to your PostgreSQL host.
7. Run `06_monitoring_checks.sql` and test failure scenarios in a non-production database.

## Important implementation notes
- The inventory procedure must be called once per order, within a transaction, after order items are available. Production systems need idempotency to prevent double deductions on retries.
- The low-stock trigger records an alert row; it does not send email/SMS or call external APIs.
- The archive procedure copies eligible completed orders but does not delete source rows. Related order items and retention rules require a reviewed multi-table archive plan.
- Thresholds and cutoff dates are examples. Validate business rules, permissions, concurrency, backups, monitoring, and rollback procedures before production use.
