# Olist E-Commerce Analytics

An end-to-end data analytics project using the Brazilian E-Commerce dataset (Olist) covering SQL analysis, Python ETL pipeline, and Power BI dashboards.

## Project Overview

This project simulates a real-world analytics workflow for an e-commerce marketplace. It covers data ingestion, cleaning, SQL-based analysis, and visualization — answering key business questions around revenue, customer behavior, delivery performance, and seller metrics.

**Dataset:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)  
**Period:** September 2016 — August 2018  
**Scale:** ~550,000 rows across 8 tables

---

## Project Structure

```
olist-ecommerce-analytics/
│
├── sql/
│   ├── create_tables.sql        # DDL scripts for all 8 tables
│   └── analysis_queries.sql     # 8 business analysis queries
│
├── etl/
│   ├── extract.py               # Reads raw CSVs into dataframes
│   ├── transform.py             # Cleans and validates data
│   ├── load.py                  # Loads clean data into MySQL
│   └── pipeline.py              # Orchestrates full ETL run
│
├── data/                        # Raw CSVs (not tracked by Git)
└── README.md
```

---

## Tech Stack

- **SQL** — MySQL 8.0
- **Python** — pandas, SQLAlchemy, mysql-connector-python
- **Visualization** — Power BI Service
- **Version Control** — Git / GitHub

---

## Database Schema

The dataset contains 8 tables with the following relationships:

```
customers ──< orders ──< order_items >── products
                  │                         │
                  └──< order_payments    product_category_translation
                  └──< order_reviews
                  └── sellers (via order_items)
```

---

## ETL Pipeline

The Python ETL pipeline runs in 3 phases:

**Extract** — Reads all 8 raw CSV files with UTF-8 encoding support  
**Transform** — Handles encoding issues, removes duplicates, standardizes data types and text fields  
**Load** — Pushes clean data into MySQL via SQLAlchemy, replacing existing tables  

**To run the pipeline:**
```bash
python3 pipeline.py
```

**Output:**
```
🚀 Starting Olist ETL Pipeline...
=== EXTRACT PHASE === ✓ 8 files loaded
=== TRANSFORM PHASE === ✓ 8 tables cleaned
=== LOAD PHASE === ✓ 8 tables loaded
✅ Pipeline completed in ~13 seconds
```

---

## SQL Analysis

8 business questions answered using advanced SQL:

| # | Business Question | Concepts Used |
|---|---|---|
| 1 | Top 10 product categories by revenue | JOINs, COALESCE, aggregation |
| 2 | Monthly revenue trend | DATE_FORMAT, GROUP BY |
| 3 | Month-over-month revenue growth % | CTE, LAG window function |
| 4 | Top 10 customers by total spend | RANK window function |
| 5 | Average delivery time by state | DATEDIFF, AVG |
| 6 | Payment type breakdown | Subquery, percentage calculation |
| 7 | Top 10 sellers by revenue | Multi-table JOINs, RANK |
| 8 | Repeat vs one-time customers | Double CTE, CASE WHEN |

---

## Key Findings

- **Health & Beauty** is the top revenue category at ~1.2M BRL
- **November 2017** saw a 52% revenue spike — driven by Black Friday
- **São Paulo** has the fastest average delivery at 8.7 days vs **Roraima** at 29.3 days
- **76.9%** of orders are paid by credit card
- **97%** of customers never made a repeat purchase — significant retention gap
- Revenue grew approximately **20x** from early 2017 to 2018

---

## Data Quality Notes

- 6 cancelled orders excluded from revenue analysis
- 13 products with missing English category translation handled via COALESCE fallback
- Order reviews contained Portuguese special characters — handled via UTF-8 encoding in ETL
- 2016 data excluded from trend analysis (incomplete — platform launch phase)

---

## Setup Instructions

### Prerequisites
- MySQL 8.0+
- Python 3.9+
- Required packages: `pip install pandas sqlalchemy mysql-connector-python`

### Steps
1. Clone this repository
2. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
3. Place CSV files in the `data/` folder
4. Run the DDL script to create tables: `sql/create_tables.sql`
5. Update DB credentials in `etl/load.py`
6. Run the pipeline: `python3 etl/pipeline.py`

---

## Author

**Dipali** — Data Analyst  
[LinkedIn](#) | [GitHub](#)
