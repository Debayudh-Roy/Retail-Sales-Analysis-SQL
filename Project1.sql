-- SQL Project P1
create database sql_project_p1;

-- Selecting the Database
use sql_project_p1;

-- Create Table
drop table if exists retail_sales;
create table retail_sales(
 transactions_id INT PRIMARY KEY,	
 sale_date	DATE,
 sale_time	TIME,
 customer_id   INT,	
 gender	VARCHAR(15),
 age INT,
 category VARCHAR(15),	
 quantiy INT,	
 price_per_unit FLOAT,	
 cogs FLOAT,	
 total_sale FLOAT
);


-- checking for null rows
select * 
from retail_sales
where 
  transactions_id is null
  or
  sale_date is null
  or
  sale_time	is null
  or
  customer_id is null
  or
  gender is null
  or
  age is null
  or
  category is null
  or
  quantiy is null
  or
  price_per_unit is null
  or
  cogs is null
  or
  total_sale is null;
  
-- Delete null rows
delete from retail_sales
where
 transactions_id is null
  or
  sale_date is null
  or
  sale_time	is null
  or
  customer_id is null
  or
  gender is null
  or
  age is null
  or
  category is null
  or
  quantiy is null
  or
  price_per_unit is null
  or
  cogs is null
  or
  total_sale is null;

-- Data exploration

-- How many sales we have
select count(*) as total_sales from retail_sales;

-- How many unique customers we have?
select count(distinct customer_id) as total_sale from retail_sales;

-- How many unique category we have?
select distinct category as total_sale from retail_sales;

-- Data Analysis and Business Key Problems and Answers

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05':
select *
from retail_sales
where sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    date_format(sale_date, '%Y-%m') = '2022-11'
    AND
    quantiy >= 4;
    
-- Write a SQL query to calculate the total sales (total_sale) for each category.:
select category, sum(total_sale) as net_sale, count(*) as total_orders
from retail_sales
group by category;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select round(avg(age),2) as avg_age
from retail_sales
where category = 'Beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select *
from retail_sales
where total_sale > 1000;


-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select category, gender, count(transactions_id) as total_transactions
from retail_sales
group by  category, gender;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select Year, Month, Avg_Sale  
from
(
select year(sale_date) as Year, month(sale_date) as Month, round(avg(total_sale),2) as Avg_Sale,
	   rank() over(partition by year(sale_date) order by avg(total_sale) desc) as ranks
from retail_sales
group by year(sale_date), month(sale_date)
) as t1
where ranks = 1;

-- Write a SQL query to find the top 5 customers based on the highest total sales:
select customer_id , sum(total_sale) as "total sales"
from retail_sales
group by customer_id
order by sum(total_sale) desc
limit 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category.:
select count(distinct customer_id) as unique_customers, category
from retail_sales
group by category; 

-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
with hourly_sales
as
(
select *,
	case
       when hour(sale_time) < 12 then 'Morning'
       when hour(sale_time) between 12 and 17 then 'Afternoon'
       else 'Evening'
	end as shifts
from retail_sales
) 
select shifts, count(total_sale) as Total_Orders
from hourly_sales
group by shifts;

-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
-- alternative way 
create view reta_sales_shifts as
select sale_time,
       total_sale,
       case
          when hour(sale_time) < 12 then 'Morning'
          when hour(sale_time) between 12 and 17 then 'Afternoon'
          else 'Evening'
		end as shifts
from retail_sales;


select shifts, count(total_sale) as Total_Sale
from reta_sales_shifts
group by shifts;


-- end of project 
