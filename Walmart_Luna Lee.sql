CREATE DATABASE IF NOT EXISTS salesDataWalmart;
CREATE TABLE IF NOT EXISTS sales(invoice_id Varchar(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5)NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL, 
unit_price DECIMAL(10,2) NOT NULL, 
quantity INT NOT NULL, 
VAT FLOAT(6, 4) NOT NULL, 
total DECIMAL(12, 4) NOT NULL,
date DATETIME NOT NULL, 
time TIME NOT NULL, 
payment_method VARCHAR(15) NOT NULL, 
cogs DECIMAL(10, 2) NOT NULL, 
gross_margin_pct FLOAT(11, 9),
gross_income decimal(12, 4) NOT NULL, 
rating FLOAT(2,1) 
);

SELECT * FROM salesdatawalmart.sales;

-- -------------------------------------------------------------------
-- ----------------Feature Engineering-------------------------------

-- time_of_day


SELECT 
    time,
    (CASE 
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'MORNING'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'AFTERNOON'
        ELSE 'EVENING'
     END) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales
SET time_of_day = (
CASE 
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'MORNING'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'AFTERNOON'
        ELSE 'EVENING'
     END
     );
----- day_name
SELECT 
    date,
    DAYNAME(date) AS day_name
FROM
    sales;
    
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

----- MONTH_NAME

SELECT 
date, 
monthname(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales 
SET month_name = monthname(date);

--- -----------------------------------------------------------------------------------------------------------

--- -----------------------------------------------------------------------------------------------------------
--- ------------------------------------ Generic ----------------------------------------------------------------
-- How many unique cities does the data have?

Select Distinct city 
From sales;

Select Distinct branch
From sales;

Select 
distinct City, branch 
From sales; 

------- product--------------------------------------------------------------------------
-- How many unique product lines does the data have?
Select 
Count(Distinct product_line) 
From sales;

--- What is the most common payment method?---------------------
Select 
payment_method,
COUNT(payment_method) AS cnt
FROM sales
group by payment_method
ORDER BY cnt DESC;

----------------------- What is the most selling product line?
Select 
product_line,
COUNT(product_line) AS cnt
FROM sales
group by product_line
ORDER BY cnt DESC
limit 1;

------ What is the total revenue by month?-----------------------------------------------------------
SELECT 
month_name as month,
sum(total) as total_revenue  
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

--- WHAT MONTH HAD THE LARGEST COGS?
select 
	month_name AS month, 
    SUM(cogs) AS cogs 
FROM sales 
GROUP BY month_name 
ORDER BY cogs DESC; 

--- what product line had the largest revenue?
SELECT 
product_line, 
SUM(total) AS total_revenue
FROM sales
group by product_line
order by total_revenue DESC;

--- What is the city with the largest revenue? -----------------------------------
SELECT 
branch, 
CITY, 
SUM(total) AS total_revenue
FROM sales
group by city, BRANCH
order by total_revenue DESC;

--- What product line had the largest VAT?--------------------
SELECT 
product_line, 
AVG(VAT) AS avg_tax
FROM sales
group by product_line
order by avg_tax DESC;

---- Which branch sold more products than average product sold?------------------
SELECT 
branch,
SUM(quantity) AS qty 
FROM sales
GROUP BY branch 
HAVING SUM(quantity) > (select avg(quantity) FROM sales);

--- What is the most common product line by gender?-----------------------------
SELECT 
gender, 
product_line, 
COUNT(gender) AS total_cnt
FROM sales 
GROUP BY gender, product_line 
ORDER BY total_cnt DESC;

------ What is the average rating of each product line? ----------------------------------
SELECT 
round(AVG(rating) ,2) AS avg_rating, 
product_line
FROM sales 
GROUP BY product_line 
ORDER BY avg_rating DESC;

------- Improvement ---------------------
-- Which product line has the highest average unit price?
SELECT 
    product_line, 
    AVG(unit_price) AS avg_unit_price 
FROM sales 
GROUP BY product_line 
ORDER BY avg_unit_price DESC 
LIMIT 1;

-- Which gender spends more on average per transaction?
SELECT 
    gender, 
    AVG(total) AS avg_spending 
FROM sales 
GROUP BY gender 
ORDER BY avg_spending DESC;

-- Which branch has the highest average customer rating?
SELECT 
    branch, 
    AVG(rating) AS avg_rating 
FROM sales 
GROUP BY branch 
ORDER BY avg_rating DESC 
LIMIT 1;

-- What is the average quantity sold per transaction for each product line?
SELECT 
    product_line, 
    AVG(quantity) AS avg_quantity_per_transaction 
FROM sales 
GROUP BY product_line 
ORDER BY avg_quantity_per_transaction DESC;


