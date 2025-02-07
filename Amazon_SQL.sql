DROP DATABASE IF EXISTS Amazondata; 
CREATE DATABASE Amazondata;
 USE Amazondata; 
 CREATE TABLE amazondata(invoice_id VARCHAR(30), branch VARCHAR(5), 
 
 city VARCHAR(30), customer_type VARCHAR(30), gender VARCHAR(10), 
 
 product_line VARCHAR(100), unit_price DECIMAL(10, 2), quantity INT, VAT FLOAT(6, 4), 
 total DECIMAL(10, 2), date DATE, time TIME, payment_method VARCHAR(30), 
 cogs DECIMAL(10, 2), gross_margin_percentage FLOAT(11, 9), gross_income DECIMAL(10, 2), 
 rating FLOAT(5, 3) ); 
 SELECT * FROM amazondata;
 LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/uploads/Amazon.csv' 
 INTO TABLE amazondata FIELDS TERMINATED BY ',' 
 OPTIONALLY ENCLOSED BY '"' 
 LINES TERMINATED BY '\r\n' IGNORE 1 LINES; 
 SHOW WARNINGS; 
 SELECT COUNT(*) FROM amazondata;
 SELECT @@secure_file_priv;
 
 -- 1 What is the count of distinct cities in the dataset?
 
select distinct city from amazondata ;
select count(distinct city) from amazondata;

-- 2 For each branch, what is the corresponding city?

select branch,city from amazondata group by branch,city;

-- 3 What is the count of distinct product lines in the dataset?

select count(distinct product_line) from amazondata;

-- 4 Which payment method occurs most frequently?

select payment_method, count(payment_method) as frequently_method from amazondata
 group by payment_method order by frequently_method desc limit 1;
 
 -- 5 Which product line has the highest sales?
 select product_line,sum(total) as total_sale from amazondata group by product_line order by total_sale desc limit 1;
 
 -- 6 How much revenue is generated each month?
 
SELECT date_format(Date, '%Y-%m') AS Month,monthname(Date) as monthname, SUM(Total) AS Revenue
FROM Amazondata GROUP BY month,monthname;

-- 7 In which month did the cost of goods sold reach its peak?
select date_format(Date,'%y-%m') as month,monthname(Date) as monthname,sum(cogs) as total_cogs 
from  amazondata group by month,monthname order by total_cogs desc limit 1;

-- 8 Which product line generated the highest revenue?
select product_line,sum(total) as revenue from amazondata group by product_line order by revenue desc limit 1;

-- 9 In which city was the highest revenue recorded?
select city,sum(total) as revenue from amazondata group by city order by revenue desc limit 1;

-- 10 Which product line incurred the highest Value Added Tax?
select product_line, sum(VAT) AS total_vat  from amazondata group by product_line order by total_vat desc limit 1;

-- 11 For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."

select product_line, sum(total) as total_sales,avg(total) as avg_total,
CASE
when sum(total)> (select avg(total)  from amazondata) then "Good" 
ELSE 
"Bad"
end as sales_performance
from amazondata group by product_line order by total_sales desc;

-- 12 Identify the branch that exceeded the average number of products sold.

select branch ,sum(quantity) as total_quantity_sold from amazondata group by branch having sum(quantity)>(select 
avg(branch_sales)  from (select sum(quantity) as branch_sales from amazondata group by branch) as quantity_sold);

-- 13 Which product line is most frequently associated with each gender?

select product_line,gender,count(*) as frequency from amazondata group by product_line,gender order by gender,frequency desc;

-- 14 Calculate the average rating for each product line.
select product_line,avg(rating) from amazondata group by product_line;

-- 15 Count the sales occurrences for each time of day on every weekday.
 SELECT dayname(DATE) AS Weekday, HOUR(Time) AS Hour, COUNT(*) AS SalesCount from amazondata GROUP BY Weekday, Hour;
 
 -- 16 Identify the customer type contributing the highest revenue.
 
 select customer_type,sum(total) as Totalrevenue from amazondata group by customer_type order by Totalrevenue desc limit 1;
 
 -- 17 Determine the city with the highest VAT percentage
 select city ,Avg((VAT*100)/Total) as AVG_VAT_Percentage from amazondata group by city order by AVG_VAT_Percentage DESC limit 1;
 
 -- 18-Identify the customer type with the highest VAT payments.
 select customer_type ,sum(vat) highest_vat from amazondata group by customer_type order by highest_VAT desc limit 1;
 
 -- 19 What is the count of distinct customer types in the dataset?
 
 select count(distinct customer_type) as count_of_distinct_customer from amazondata;
 
 -- 20 What is the count of distinct payment methods in the dataset?
 select count(distinct payment_method) as count_of_distinct_payment_method from amazondata;
 
 -- 21 Which customer type occurs most frequently?
 select customer_type ,count(*) as frequency from amazondata 
 group by customer_type order by frequency desc limit 1;
 
 -- 22 Identify the customer type with the highest purchase frequency.
 select customer_type ,count(*) as purchase_frequency from amazondata group by customer_type order by purchase_frequency desc limit 1;
 
 -- 23 Determine the predominant gender among customers.
 select gender ,count(*) as total_count from amazondata group by gender order by total_count desc limit 1;
 
 -- 24 Examine the distribution of genders within each branch.
 select branch,gender,count(gender) from amazondata group by branch ,gender order by branch ;
 
 -- 25 Identify the time of day when customers provide the most ratings.
 select dayname(date) as weekday,count(*) as rating_count,case 
 WHEN HOUR(time) BETWEEN 6 AND 11 THEN 'Morning' 
 WHEN HOUR(time) BETWEEN 12 AND 17 THEN 'Afternoon' 
 WHEN HOUR(time) BETWEEN 18 AND 23 THEN 'Evening' ELSE 'Night' End  as Hour
 from amazondata group by weekday,
 hour order by rating_count desc limit 1;
 
 -- 26-Determine the time of day with the highest customer ratings for each branch.
  select branch,avg(rating) as average_rating,case 
 WHEN HOUR(time) BETWEEN 6 AND 11 THEN 'Morning' 
 WHEN HOUR(time) BETWEEN 12 AND 17 THEN 'Afternoon' 
 WHEN HOUR(time) BETWEEN 18 AND 23 THEN 'Evening' ELSE 'Night' End  as Hour from amazondata group by 
 branch,hour order by branch,average_rating desc ;
 
 -- 27 Identify the day of the week with the highest average ratings.
 
 select avg(rating) as average_rating ,case 
 WHEN DAYOFWEEK(date) = 1 THEN 'Sunday' 
 WHEN DAYOFWEEK(date) = 2 THEN 'Monday'
 WHEN DAYOFWEEK(date) = 3 THEN 'Tuesday'
 WHEN DAYOFWEEK(date) = 4 THEN 'Wednesday' 
 WHEN DAYOFWEEK(date) = 5 THEN 'Thursday' 
 WHEN DAYOFWEEK(date) = 6 THEN 'Friday' 
 WHEN DAYOFWEEK(date) = 7 THEN 'Saturday' 
 END as week_day_name from amazondata group by week_day_name order by average_rating desc7 limit 1;
 
 -- 28 Determine the day of the week with the highest average ratings for each branch.
 
 select branch,dayname(date) as day_name,avg(rating) as average_rating,case 
 WHEN DAYOFWEEK(date) = 1 THEN 'Sunday' 
 WHEN DAYOFWEEK(date) = 2 THEN 'Monday'
 WHEN DAYOFWEEK(date) = 3 THEN 'Tuesday'
 WHEN DAYOFWEEK(date) = 4 THEN 'Wednesday' 
 WHEN DAYOFWEEK(date) = 5 THEN 'Thursday' 
 WHEN DAYOFWEEK(date) = 6 THEN 'Friday' 
 WHEN DAYOFWEEK(date) = 7 THEN 'Saturday' 
 END as week_day_name from amazondata 
 group by branch ,day_name,week_day_name order by average_rating desc limit 1 ;
 



 
 





 
