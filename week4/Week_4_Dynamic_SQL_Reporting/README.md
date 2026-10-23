# Week 4 — Dynamic Reporting and Data Visualization Using SQL

## Deliverables
- `Week_4_Dynamic_Reporting_and_Data_Visualization_SQL.docx` — structured report with business questions, SQL examples, mock outputs, visualization guidance, and recommendations.
- `sql/01_sales_kpis.sql` — monthly retail KPIs.
- `sql/02_best_selling_products.sql` — best-selling products.
- `sql/03_inventory_alerts.sql` — low-stock and out-of-stock alerts.
- `sql/04_customer_segments.sql` — customer value segmentation.
- `sql/05_seasonal_sales.sql` — monthly and year-over-year trends.
- `sql/06_category_performance.sql` — category revenue share.
- `sql/07_dashboard_refresh.sql` — date-filtered dashboard dataset.

## Database
These scripts target PostgreSQL and expect the `customers`, `products`, `orders`, and `order_items` tables from the Week 3 virtual retail database project.

## Run
1. Create the schema and load data from your Week 3 scripts.
2. Run each SQL file in a PostgreSQL client.
3. Check the mock outputs in the Word report against your actual data.
4. Replace the illustrative output values with results from your own database before submitting.
5. Use the chart suggestions in the report to build charts in Excel, Power BI, Tableau, or another visualization tool.

## Notes
- Mock outputs are examples, not actual query results.
- Customer segments and inventory thresholds are illustrative and should be calibrated to the business.
- Year-over-year comparisons need at least 13 months of usable data; preferably use multiple full years.
- For dashboards, use parameterized filters in the reporting tool and refresh data according to business needs.
