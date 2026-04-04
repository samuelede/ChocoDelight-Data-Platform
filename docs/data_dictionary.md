# Data Dictionary - ChocoDelight Chocolate Sales Dataset

## Dimension Tables

### products
- `product_id`: Primary Key, Unique product identifier
- `product_name`: Name of the chocolate product
- `brand`: Brand of the product
- `category`: Product category (e.g., Dark, Milk, White)
- `cocoa_percent`: Cocoa percentage
- `weight_g`: Weight in grams

### stores
- `store_id`: Primary Key
- `store_name`: Name of the store
- `city`: City location
- `country`: Country location
- `store_type`: Type of store (e.g., Flagship, Mall, Online)

### customers
- `customer_id`: Primary Key
- `age`: Customer age
- `gender`: Gender
- `loyalty_member`: Boolean (True if loyalty member)
- `join_date`: Date customer joined

### calendar
- `date`: Primary Key, Date of transaction
- `year`, `month`, `day`, `week`, `day_of_week`: Date parts

## Fact Table: sales
- `order_id`: Primary Key, Unique order ID
- `order_date`: Foreign Key to calendar.date
- `product_id`: Foreign Key to products
- `store_id`: Foreign Key to stores
- `customer_id`: Foreign Key to customers
- `quantity`: Number of units sold
- `unit_price`: Price per unit
- `discount`: Discount amount
- `revenue`: Total revenue after discount
- `cost`: Estimated cost
- `profit`: revenue - cost

## Views Available
- `vw_revenue_by_product`
- `vw_revenue_by_store`
- `vw_monthly_trends`