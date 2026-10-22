# 🛒 Virtual Retail Database Design

A PostgreSQL-based database design project for a virtual retail business. This project demonstrates relational data modeling, database architecture, SQL development, indexing, and data validation.

## 🎯 Project Objective

To design a structured, scalable, and reliable relational database for a virtual retail platform that manages customers, products, inventory, orders, payments, and shipments.

## 🛠️ Technologies Used

* **Database:** PostgreSQL 14+
* **Language:** SQL
* **Data format:** CSV
* **Tools:** PostgreSQL, pgAdmin, GitHub

## ✨ Key Features

* Customer and address management
* Product catalog and category management
* Inventory and stock-level tracking
* Order and order-item management
* Payment status tracking
* Shipment and delivery tracking
* Inventory movement audit records
* Sales and customer analytics queries
* Primary keys, foreign keys, constraints, and indexes
* SQL validation and diagnostic tests

## 🗂️ Project Structure

```text
virtual-retail-database-design/
├── README.md
├── LICENSE
├── docs/
├── diagrams/
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
└── tests/
    ├── testing_queries.sql
    └── optional_constraint_tests.sql
```

## 🧱 Database Entities

| Entity              | Purpose                                  |
| ------------------- | ---------------------------------------- |
| Customers           | Stores customer information              |
| Customer Addresses  | Stores customer addresses                |
| Categories          | Organizes products                       |
| Products            | Stores product details and prices        |
| Inventory           | Tracks available stock                   |
| Customer Orders     | Stores order information                 |
| Order Items         | Records products purchased in each order |
| Payments            | Tracks payment methods and statuses      |
| Shipments           | Tracks order delivery                    |
| Inventory Movements | Records stock changes                    |

## 🚀 Getting Started

### Prerequisites

Install PostgreSQL 14 or newer. You can use pgAdmin or the PostgreSQL command-line client (`psql`).

### 1. Create a database

```sql
CREATE DATABASE virtual_retail;
```

### 2. Create the schema

Run:

```bash
psql -d virtual_retail -f sql/01_schema.sql
```

### 3. Load sample data

```bash
psql -d virtual_retail -f sql/02_sample_data.sql
```

### 4. Run validation queries

```bash
psql -d virtual_retail -f tests/testing_queries.sql
```

### 5. Explore analytics queries

Open `sql/03_analytics_queries.sql` and execute individual queries to explore sales, product performance, inventory alerts, and customer order history.

Optional performance indexes are provided in `sql/04_indexes.sql`.

## 📊 Sample Analytics

The project includes queries for:

* Monthly revenue from delivered orders
* Best-selling products
* Customer lifetime order value
* Low-stock product alerts
* Payment status reports
* Shipment and fulfilment tracking
* Daily order volume
* Inventory movement history

## 🔒 Data Integrity

The schema uses:

* Primary and foreign keys
* Unique constraints
* Check constraints for valid values
* Non-negative price and inventory checks
* Order and order-item total consistency checks
* Indexes to support common queries

## 🧪 Testing

The `tests/` directory contains validation queries and optional constraint tests.

**Testing status:** The scripts have been prepared, but they must be executed against PostgreSQL before test results can be reported as passing.

## 📈 Future Improvements

* Implement transaction-safe inventory reservation
* Add role-based access control
* Introduce database migration tooling
* Build a retail analytics dashboard
* Add automated integration tests
* Implement backup and recovery procedures
* Connect a web application to the database

## ⚠️ Disclaimer

This is an educational and portfolio project. All sample customer records are fictional. The database design is a development baseline and should undergo additional security, performance, and transactional testing before production use.

## 👨‍💻 Author

**Raj**

GitHub: [Raj-max-pixal](https://github.com/Raj-max-pixal)

---

⭐ If you find this project useful, consider starring the repository.
