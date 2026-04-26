USE DataWarehouseAnalytics;

---------------Validations after data preparation for Power BI-------------------

--Check NULL values
SELECT *
FROM gold.vw_sales
WHERE customer_key IS NULL
   OR product_key IS NULL
   OR sales_amount IS NULL;

--Check duplicates
SELECT order_number, product_key, COUNT(*) AS duplicates
FROM gold.vw_sales
GROUP BY order_number, product_key
HAVING COUNT(*) > 1;

--Check negative or zero values
SELECT *
FROM gold.vw_sales
WHERE sales_amount < 0 OR quantity < 0;

--Date format check
SELECT DISTINCT YEAR(order_date)
FROM gold.vw_sales;