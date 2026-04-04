import pandas as pd
from sqlalchemy import create_engine, text
import os
import sys

# ------------------- Fix Python Path -------------------
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from config.db_config import DATABASE_URL

print("🚀 Starting ETL Pipeline for ChocoDelight Chocolate Sales Dataset 2023-2024\n")

# ------------------- User Choice -------------------
raw_folder = 'data/raw'
os.makedirs(raw_folder, exist_ok=True)

print("How would you like to get the dataset?")
print("1. I will manually download the zip file from Kaggle")
print("2. Use files already present in data/raw/ folder")

choice = input("\nEnter your choice (1 or 2): ").strip()

if choice == "1":
    print("\nPlease download the dataset from:")
    print("https://www.kaggle.com/datasets/ssssws/chocolate-sales-dataset-2023-2024")
    print("Extract it and copy the 5 CSV files into data/raw/")
    input("\nPress Enter after placing the files... ")
elif choice == "2":
    print(f"\nUsing existing files in '{raw_folder}' folder...")
else:
    print("❌ Invalid choice. Exiting.")
    sys.exit(1)

# ------------------- Verify Files -------------------
required_files = ['products.csv', 'stores.csv', 'customers.csv', 'calendar.csv', 'sales.csv']
missing = [f for f in required_files if not os.path.exists(os.path.join(raw_folder, f))]

if missing:
    print(f"❌ Missing files: {missing}")
    sys.exit(1)

print("✅ All required CSV files found!\n")

# ------------------- Load Data -------------------
print("Loading CSV files...")
products = pd.read_csv(os.path.join(raw_folder, 'products.csv'))
stores = pd.read_csv(os.path.join(raw_folder, 'stores.csv'))
customers = pd.read_csv(os.path.join(raw_folder, 'customers.csv'))
calendar = pd.read_csv(os.path.join(raw_folder, 'calendar.csv'))
sales = pd.read_csv(os.path.join(raw_folder, 'sales.csv'))

# Standardize column names
for df in [products, stores, customers, calendar, sales]:
    df.columns = [col.strip().lower().replace(' ', '_') for col in df.columns]

# Convert dates
sales['order_date'] = pd.to_datetime(sales['order_date'], errors='coerce')
if 'join_date' in customers.columns:
    customers['join_date'] = pd.to_datetime(customers['join_date'], errors='coerce')
calendar['date'] = pd.to_datetime(calendar['date'], errors='coerce')

print(f"✅ Data loaded | Sales: {len(sales):,} rows")

# ------------------- Connect to Database -------------------
engine = create_engine(DATABASE_URL)

# ------------------- Drop Dependent Objects First -------------------
print("Dropping dependent objects before reload...")

with engine.connect() as conn:
    conn.execute(text("DROP VIEW IF EXISTS vw_revenue_by_product CASCADE;"))
    conn.execute(text("DROP VIEW IF EXISTS vw_revenue_by_store CASCADE;"))
    conn.execute(text("DROP VIEW IF EXISTS vw_monthly_trends CASCADE;"))
    conn.execute(text("ALTER TABLE IF EXISTS sales DROP CONSTRAINT IF EXISTS fk_sales_product;"))
    conn.execute(text("ALTER TABLE IF EXISTS sales DROP CONSTRAINT IF EXISTS fk_sales_store;"))
    conn.execute(text("ALTER TABLE IF EXISTS sales DROP CONSTRAINT IF EXISTS fk_sales_customer;"))
    conn.execute(text("ALTER TABLE IF EXISTS sales DROP CONSTRAINT IF EXISTS fk_sales_date;"))
    conn.commit()

print("✅ Dependencies cleared.")

# ------------------- Load Tables (with replace) -------------------
print("Loading tables into PostgreSQL...")

products.to_sql('products', engine, if_exists='replace', index=False)
stores.to_sql('stores', engine, if_exists='replace', index=False)
customers.to_sql('customers', engine, if_exists='replace', index=False)
calendar.to_sql('calendar', engine, if_exists='replace', index=False)
sales.to_sql('sales', engine, if_exists='replace', index=False)

print("\n🎉 ETL Pipeline completed successfully!")
print("All tables have been reloaded into the database.")