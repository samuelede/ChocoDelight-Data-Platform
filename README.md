# ChocoDelight Data Platform – Optimization & Analytics (Capstone Project II)

**Dataset**: Chocolate Sales Dataset 2023-2024 (Kaggle)  
**Link**: [https://www.kaggle.com/datasets/ssssws/chocolate-sales-dataset-2023-2024](https://www.kaggle.com/datasets/ssssws/chocolate-sales-dataset-2023-2024)

This capstone project transforms the raw chocolate sales data into a high-performance, normalized relational database in PostgreSQL following **Second Normal Form (2NF)** principles. The focus is on data integrity, query optimization, feature engineering, and delivering actionable business insights.

## Project Structure

```bash
ChocoDelight-Data-Platform/
├── README.md                          # Technical README (mandatory for submission)
├── requirements.txt                   # Python 
├── .env                               # (use env vars in production)
├── .gitignore                         # Standard Python + data gitignore
├── config/
│   └── db_config.py                   # Database connection settings 
├── data/
│   └── raw/                           # Place the 5 CSV files here (add to .gitignore if large)
├── sql/
│   ├── 01_create_schema.sql           # Dimension + Fact tables (2NF)
│   ├── 02_constraints_indexes.sql     # PK, FK, UNIQUE, CHECK, indexes
│   ├── 03_data_cleaning.sql           # Standardize, handle NULLs/duplicates (optional helper)
│   ├── 04_views_analytics.sql         # Revenue by product, region, monthly trends
│   ├── 05_segmentation.sql            # Revenue buckets, time categories, outlier handling
│   └── schema_final.sql               # FINAL consolidated script
├── python/
│   └── etl_pipeline.py                # COMPLETE Python ETL script
├── notebooks/                         # Optional but recommended
│   └── 01_eda_chocolate_sales.ipynb   # Exploratory Data Analysis (for reference)
└── docs/
    └── data_dictionary.md             # Optional but excellent for professionalism

```

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

### Technologies Used
- Database: PostgreSQL
- Language: Python 3
- Libraries: pandas, SQLAlchemy, psycopg2-binary, python-dotenv, kaggle, matplotlib, seaborn
- Design: Star Schema (4 Dimension Tables + 1 Fact Table)

## How to Run
### 1. Clone the repository
```bash 
   git clone https://github.com/yourusername/ChocoDelight-Data-Platform.git
   cd ChocoDelight-Data-Platform
```
### 2. Install dependencies
```bash
pip install -r requirements.txt
```
### 3. Configure database credentials
Create a `.env` file in the root with:
```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=chocodelight
DB_USER=postgres
DB_PASSWORD=your_actual_password
```
### 4. Create the database
```sql
CREATE DATABASE chocodelight;
```
### 5. Run the schema
```bash
psql -U postgres -d chocodelight -f sql/schema_final.sql
```
### 6. Run the ETL pipeline
```bash
python python/etl_pipeline.py
```
- Choose option 1 and follow the instructions to place the CSV files in data/raw/

### 7. Explore insights
```sql
SELECT * FROM vw_revenue_by_product LIMIT 10;
SELECT * FROM vw_revenue_by_store ORDER BY total_revenue DESC;
SELECT * FROM vw_monthly_trends;
```

## Author
Samuel Ede | 
Data Engineering Capstone Project II
## License
This project is for academic and portfolio purposes only.