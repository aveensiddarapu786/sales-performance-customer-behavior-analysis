USE DataWarehouseAnalytics;
-----------------------------------------------------------------------------------------------
				--EDA(Exploratory Data Analysis)

--Top 5 Customers by Sales
SELECT TOP 5
	c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS customer_fullname,
	SUM(s.sales_amount) AS total_sales
FROM gold.fact_sales s
INNER JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY 
	c.customer_id,
	CONCAT(c.first_name,' ',c.last_name)
ORDER BY total_sales DESC;

--Top 5 products by Sales

SELECT TOP 5
	p.product_name,
	SUM(s.sales_amount) AS total_sales
FROM gold.fact_sales s
INNER JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY 
	p.product_name
ORDER BY total_sales DESC;

-- Sales by country

SELECT TOP 5
	c.country,
	SUM(s.sales_amount) AS total_sales
FROM gold.fact_sales s
INNER JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY 
	c.country
ORDER BY total_sales DESC;
-----------------------------------------------------------------------------------------------
			    -- Advanced Data Analytics

--1)Monthly Regional Trends

		--Which region is declining over time (M-o-M)?
		--Any region showing consistent growth?

WITH region_sales AS
(SELECT 
	c.country AS country,
	MONTH(order_date) AS order_month,
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales s
INNER JOIN gold.dim_customers c ON
	s.customer_key=c.customer_key
WHERE YEAR(s.order_date) IS NOT NULL AND 
	  YEAR(s.order_date) in ('2011','2012','2013') AND
	  c.country!='n/a'
GROUP BY 
	c.country,
	MONTH(s.order_date)
)
SELECT 
	country,
	order_month,
	total_sales,
	LAG(total_sales) OVER(PARTITION BY country ORDER BY order_month) AS previous_month_sales,
	total_sales - LAG(total_sales) OVER(PARTITION BY country ORDER BY order_month) AS sales_diff
FROM region_sales;


--2)Customers Behaviour

		--Customers and their orders information
SELECT 
    customer_key,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(sales_amount) / COUNT(DISTINCT order_number), 2) AS avg_order_value
FROM gold.fact_sales
GROUP BY customer_key;

		--Identify Customer Types
		--1)Premium Customers (Customers with highest sales with less orders)
SELECT TOP 10
	*
FROM (
    SELECT 
        customer_key,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    GROUP BY customer_key
) t
ORDER BY total_sales DESC;

		--2)Frequent customers (Customers with highest orders but less sales)
SELECT TOP 10
	*
FROM (
    SELECT 
        customer_key,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    GROUP BY customer_key
) t
ORDER BY 
	total_orders DESC,
	total_sales DESC;


		--3)Low Value customers (Customers with highest orders but less sales)
SELECT TOP 10
	*
FROM (
    SELECT 
        customer_key,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    GROUP BY customer_key
) t
ORDER BY 
	total_orders,
	total_sales;


