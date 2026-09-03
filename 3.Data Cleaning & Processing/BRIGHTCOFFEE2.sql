-- Databricks notebook source
SELECT * 
FROM bright_coffee2.shop.data;
------------------------------------------------------------------
--Checking for duplicate transaction_id--

SELECT transaction_id, COUNT(*) AS duplicate_count
FROM bright_coffee2.shop.data
GROUP BY transaction_id
HAVING COUNT(*) > 1;

--------------------------------------------------------------------
--Transaction_date--
SELECT DISTINCT DATE_FORMAT(transaction_date,'MMMM') AS Month_name
FROM bright_coffee2.shop.data;

-----------------------------------------------------------------
--Transaction Time--
SELECT DISTINCT 
transaction_time
FROM bright_coffee2.shop.data;

SELECT DISTINCT DATE_FORMAT(transaction_time,'HH-MM-SS') AS Time
FROM bright_coffee2.shop.data;

SELECT transaction_time,
HOUR(transaction_time) AS Transaction_Hour
FROM bright_coffee2.shop.data
LIMIT 100;

---Creating time brucket--
SELECT DISTINCT
       CASE
       WHEN HOUR(transaction_time)BETWEEN 7 AND 11 THEN 'Morning'
       ELSE 'Other'
       END AS time_bucket
       FROM bright_coffee2.shop.data;

       --Creating Revenue Column--
       SELECT product_type,
              product_category,
              ROUND(SUM(unit_price*transaction_qty),2) AS Total_Amount
              FROM bright_coffee2.shop.data
              GROUP BY product_type, product_category
              ORDER BY Total_Amount;

              -------------------------------------------------------------------
              --Cecking total revenue per store location--
              SELECT store_location,
                     ROUND(SUM(unit_price*transaction_qty), 2) AS Total_revenue
                     FROM bright_coffee2.shop.data
                     GROUP BY store_location
                     ORDER BY Total_revenue DESC;

  --------------- -----------------------------------------------------
--Checking for high and low performing products--
SELECT product_category,
 ROUND(SUM(unit_price*transaction_qty),2) AS Total_revenue
 FROM bright_coffee2.shop.data
 GROUP BY product_category
 ORDER BY total_revenue DESC;

 
 SELECT DISTINCT product_category,
       CASE
       WHEN product_category IS NULL THEN 'Unknown'
       WHEN product_category = ' ' THEN 'Unknown'
       ELSE product_category
       END AS Product_cat
       FROM bright_coffee2.shop.data;
 --------------------------------------------------------------------
 --Checking for product_type performance--
 SELECT product_type,
 ROUND(SUM(unit_price*transaction_qty),2) AS Total_revenue
 FROM bright_coffee2.shop.data
 GROUP BY product_type
 ORDER BY total_revenue DESC;

 SELECT DISTINCT product_type,
       CASE
       WHEN product_type IS NULL THEN 'Unknown'
       WHEN product_type = ' ' THEN 'Unknown'
       ELSE product_type
       END AS Product_TYP
       FROM bright_coffee2.shop.data;
--------------------------------------------------------------------
--Total units sold--
SELECT SUM(transaction_qty) AS total_units_sold
FROM bright_coffee2.shop.data;
        
SELECT transaction_id,
transaction_date,
CASE DAYOFWEEK(transaction_date)
WHEN 1 THEN 'Sunday'
WHEN 2 THEN 'Monday'
WHEN 3 THEN 'Tuesday'
WHEN 4 THEN 'Wednesday'
WHEN 5 THEN 'Thursday'
WHEN 6 THEN 'Friday'
WHEN 7 THEN 'Saturday'
END AS Day_of_week,
DATE_FORMAT(transaction_date,'MMMM') AS Month_name,
MONTH(transaction_date) AS month_number,
YEAR(transaction_date) AS year,
CASE
WHEN HOUR(transaction_time) BETWEEN 6 AND 8 THEN '06:00-09:00'
WHEN HOUR(transaction_time) BETWEEN 9 AND 11 THEN '09:00-12:00'
WHEN HOUR(transaction_time) BETWEEN 12 AND 14 THEN '12:00-15:00'
WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN '15:00-18:00'
WHEN HOUR(transaction_time) BETWEEN 18 AND 20 THEN '18:00-21:00'
END AS Transaction_time_bucket,
CASE
WHEN HOUR(transaction_time) BETWEEN 7 AND 9 THEN 'Morning'
WHEN HOUR(transaction_time) BETWEEN 10 AND 12 THEN 'Afternoon'
WHEN HOUR(transaction_time) BETWEEN 13 AND 15 THEN 'Evening'
WHEN HOUR(transaction_time) BETWEEN 16 AND 18 THEN 'Night'
WHEN HOUR(transaction_time) >= 19 AND HOUR(transaction_time) <= 20 THEN 'Closing Hours'
ELSE 'Night'
END AS Time_bucket,
transaction_qty,
store_id,
store_location,
product_type AS Product_TYP,
product_id,
product_category,
product_detail,
unit_price,
ROUND(unit_price * transaction_qty, 2) AS Total_amount
FROM bright_coffee2.shop.data;






