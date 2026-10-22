# Virtual Retail Sample Dataset

All records in this dataset are fictional and intended for learning/demo use.

## CSV files
- `customers.csv`
- `categories.csv`
- `products.csv`
- `inventory.csv`
- `orders.csv`
- `order_items.csv`
- `payments.csv`
- `shipments.csv`
- `inventory_movements.csv`

## Notes
- Monetary values are stored as decimal strings to avoid floating-point representation issues.
- Empty fields represent SQL `NULL` or an unknown/not-yet-applicable value.
- Import parent/reference tables before dependent tables: customers/categories/products first, then inventory/orders, then order items/payments/shipments/movements.
- This CSV dataset is separate from the SQL insert sample file in the PostgreSQL project package. Review consistency before loading into a database.
