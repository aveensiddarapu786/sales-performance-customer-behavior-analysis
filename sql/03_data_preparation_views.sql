USE DataWarehouseAnalytics;
 
-----------------------Data preparation for Power BI---------------------------
-- Customers    

CREATE VIEW gold.vw_customers AS 
SELECT 
	customer_key,
	first_name,
	last_name,
	country
FROM gold.dim_customers;

--Products

CREATE VIEW gold.vw_products AS 
SELECT 
	product_key,
	product_name,
	category
FROM gold.dim_products;

--Sales

CREATE VIEW gold.vw_sales AS 
SELECT 
	order_number,
    customer_key,
    product_key,
    order_date,
    quantity,
    sales_amount
FROM gold.fact_sales
WHERE quantity>0 AND 
	sales_amount>0 AND
	YEAR(order_date) IS NOT NULL AND 
	YEAR(order_date) IN ('2011','2012','2013');