USE DataWarehouseAnalytics;
----------------------------------------------------------------------------------
				 -- Data Understanding
				
SELECT * FROM gold.dim_customers;
SELECT * FROM gold.dim_products;
SELECT * FROM gold.fact_sales;
	
--Meaures Exploration
SELECT 'Total Sales' AS measure_name,SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' AS Meausre, SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Order Value (AOV)' AS Measure, SUM(sales_amount)/COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL 
SELECT 'Total No Of Orders' AS Measure, COUNT(DISTINCT order_number) FROM gold.fact_sales 
WHERE YEAR(order_date) IS NOT NULL
UNION ALL
SELECT 'Total No Of Products' AS Measure, COUNT(DISTINCT product_key) FROM gold.fact_sales
UNION ALL
SELECT 'Total No Of Customers' AS Measure, COUNT(DISTINCT customer_key) FROM gold.fact_sales

------------------------------------------------------------------------------------
                 -- Data Cleaning  

--Check NULL values
SELECT *
FROM gold.fact_sales
WHERE customer_key IS NULL
   OR product_key IS NULL
   OR sales_amount IS NULL;

--Check duplicates
SELECT order_number, product_key, COUNT(*) AS duplicates
FROM gold.fact_sales
GROUP BY order_number, product_key
HAVING COUNT(*) > 1;

--Check negative or zero values
SELECT *
FROM gold.fact_sales
WHERE sales_amount <= 0 OR quantity <= 0;

--Date format check
SELECT DISTINCT order_date
FROM gold.fact_sales;