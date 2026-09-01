create database RETAIL_SALES_1;
CREATE TABLE retail_sale (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(20),
    category VARCHAR(40),
    age INT,
    quantity INT,
    price_per_unit DECIMAL(10,2),
    cogs DECIMAL(10,2),
    total_sale DECIMAL(12,2)
);
LOAD DATA LOCAL INFILE 'C:/Users/ANOOP/OneDrive/Pictures/Desktop/EXCEL/SQL - Retail Sales Analysis_utf .csv'
INTO TABLE retail_sale
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    transactions_id,
    sale_date,
    sale_time,
    customer_id,
    gender,
    age,
    category,
    quantity,
    price_per_unit,
    cogs,
    total_sale
);

select * from retail_sale;
-- howmany saleshave
select count(transactions_id)  as total_saless_done from retail_sale;
-- howmnay customers
select count(distinct(customer_id)) as customers from retail_sale;
-- --categories are
select distinct category from retail_sale;
-- Data Analysis & Business Key Problems
-- Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
select * from retail_sale where sale_date='2022-11-05';
-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity > 10 for the month of Nov‑2022.
SELECT 
  *
FROM retail_sale
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
and quantity>4;
--  Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select avg(age) as avg_age
from retail_sale
where category='Beauty';
-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale)
from retail_sale
group by category;
-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select avg(age) as avg_age
from retail_sale
where category='Beauty';
-- Q5. Write a SQL query to find all transactions where total_sale > 1000.
select  transactions_id,total_sale from retail_sale where total_sale > 1000;
-- Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select count(distinct  transactions_id), gender from retail_sale
group by  gender;
-- Q7. Write a SQL query to calculate the average sale for each month. Find out the best-selling month in each year.
with mntly_avg_sales as(
select year(sale_date) as year,
 month(sale_date) as month,
 avg(total_Sale) as avg_sales
 from  retail_sale
 group by year(sale_date), month(sale_date)),
 ranking as (
 select year,month,avg_sales,
 rank()over(partition by year order by avg_sales desc) as rnk
 from mntly_avg_sales)

 select * from  ranking where rnk=1;

-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales.
select customer_id,sum(total_sale)
from retail_sale
group by customer_id
limit 1;
-- Q9. Write  a SQL query to find the number of unique customers who purchased items from each category.
select category,count(distinct customer_id) from retail_sale
group by category;
-- Q10. Write a SQL query to create each shift and number of orders:
select 
case
when sale_time<'12:00:00' then 'MORNING'
when sale_time<'17:00:00' then 'AFTERNOON'
else 'Evening'
end
as time_period,
count(*) as toatl_sales
from retail_sale
group by
case
when sale_time<'12:00:00' then 'MORNING'
when sale_time<'17:00:00' then 'AFTERNOON'
else 'Evening'
end
-- Morning: < 12
-- Afternoon: 12–17
-- Evening: > 17
