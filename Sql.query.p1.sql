--- SQL Retail Sales Analysis - P1

CREATE DATABASE sql_project_p1;

--- Create TABLE

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

--- Quick Data Exploration and Looking up fields with Null

SELECT COUNT(*)
FROM retail_sales;

SELECT COUNT(DISTINCT customer_id)
FROM retail_sales;

SELECT DISTINCT category
FROM retail_sales;

SELECT * 
from dbo.retail_sales
where transactions_id is null
or
sale_date is null
or 
sale_time is null
or 
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantity is null
or
price_per_unit is null
or 
cogs is null
or 
total_sale is null;

--- deleting all rows with a NUll in it

delete from dbo.retail_sales
where transactions_id is null
or
sale_date is null
or 
sale_time is null
or 
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantity is null
or
price_per_unit is null
or 
cogs is null
or 
total_sale is null;

--- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05.

select *
from retail_sales
where sale_date = '2022-11-05';

---2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022.

select *
from retail_sales
where category = 'Clothing'
and quantity > 3
and sale_date like '2022-11-%%';

---3. Write a SQL query to calculate the total sales (total_sale) for each category.

select category, sum(total_sale) as 'Total Sales'
from retail_sales
group by category;

---4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select avg(age) as Average_Age
from retail_sales
where category = 'Beauty';

---5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

select *
from retail_sales
where total_sale > 1000;

---6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category, gender, count(transactions_id) as 'Number of sales'
from retail_sales
group by category, gender;

---7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

WITH MonthlySales AS (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        ) as rank
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT 
    year,
    month,
    avg_sale
FROM MonthlySales
WHERE rank = 1;

---8. Write a SQL query to find the top 5 customers based on the highest total sales.

select top (5) customer_id, sum(total_sale) as 'Sum of Sales'
from retail_sales
group by customer_id
order by 'Sum of Sales' desc;

---9. Write a SQL query to find the number of unique customers who purchased items from each category.

select count(distinct(customer_id)) as 'Unique Customers',category
from retail_sales
group by category;

---10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).

with HourlySales as
(
select *, 
case
    when datepart(hour, sale_time) < 12 then 'Morning'
    when datepart(hour, sale_time) > 17 then 'Evening'
    else 'Afternoon' 
End as Shift
from retail_sales
)
select Shift, count(*) as 'Sales per Hour'
from HourlySales
group by Shift;


----End of project


