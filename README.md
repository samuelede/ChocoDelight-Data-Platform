# ChocoDelight Data Platform – Optimization & Analytics (Capstone Project II)

**Dataset**: Chocolate Sales Dataset 2023-2024 (Kaggle)  
**Link**: [https://www.kaggle.com/datasets/ssssws/chocolate-sales-dataset-2023-2024](https://www.kaggle.com/datasets/ssssws/chocolate-sales-dataset-2023-2024)

This capstone project transforms the raw chocolate sales data into a high-performance, normalized relational database in PostgreSQL following **Second Normal Form (2NF)** principles. The focus is on data integrity, query optimization, feature engineering, and delivering actionable business insights.

## Project Structure

```bash
ChocoDelight-Data-Platform/
├── README.md
├── requirements.txt
├── .env
├── .gitignore
├── config/
│   └── db_config.py
├── data/
│   └── raw/                 # Place the 5 CSV files here
├── sql/
│   ├── 01_create_schema.sql
│   ├── 02_constraints_indexes.sql
│   ├── 03_data_cleaning.sql
│   ├── 04_views_analytics.sql
│   ├── 05_segmentation.sql
│   └── schema_final.sql
├── python/
│   └── etl_pipeline.py
├── notebooks/
│   └── 01_eda_chocolate_sales.ipynb
└── docs/
    └── data_dictionary.md

## Tasks Completed

### Task 1: Database Optimization & Constraints
- Applied **2NF** normalization (removed partial and transitive dependencies)
- Defined **PRIMARY KEY** on surrogate keys (`customer_id`, `product_id`, `region_id`, `sale_id`)
- Established **FOREIGN KEY** relationships with `ON DELETE RESTRICT`
- Added **indexes** on frequently filtered columns (`sale_date`, `region_id`, `product_id`, `customer_id`)
- Added `CHECK` constraints and `NOT NULL` where business rules require

### Task 2: Data Cleaning & Feature Engineering
- Standardized date formats, currency, and string values
- Removed duplicates and handled missing values
- Created derived columns:
  - `revenue = quantity * unit_price`
  - `sale_year`, `sale_month`, `sale_quarter`, `sale_season`
  - `customer_segment` (High/Medium/Low value)

### Task 3: Business Analytics & Aggregations
Created the following **SQL Views**:
- `vw_revenue_by_product`
- `vw_revenue_by_region`
- `vw_monthly_trends`

### Task 4: Customer & Sales Segmentation
- Revenue buckets (`Low`, `Medium`, `High`, `Premium`)
- Time-based categories (`season`, `is_weekend`, `fiscal_quarter`)
- Outlier detection and flagging on revenue and quantity

## How to Run the Project

1. **Database Setup**
   ```bash
   psql -U postgres -d chocodelight -f sql/schema_final.sql
   ```

2. **Database Setup**
```bash
    pip install -r requirements.txt
    python python/etl_pipeline.py
```

