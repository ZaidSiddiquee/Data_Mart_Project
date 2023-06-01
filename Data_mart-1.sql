 SELECT * FROM Weekly_sales limit 10;
 
 # Data Cleansing
 drop table Clean_weekly_sales;
 CREATE TABLE Clean_weekly_sales as SELECT week_date, week(week_date) AS week_number, month(week_date) as month_number,
 year(week_date) as calender_year, region, platform, 
 CASE
    WHEN segment = 'null'  THEN "Unknown"
    ELSE segment
    end as segment,
 CASE  
     WHEN right(segment,1) = "1" then "Young Adults"
     WHEN right(segment,1) = "2" then "Middle Age"
     WHEN right(segment,1) in ('3','4') then "Retirees"
     else "Unknown"
     END AS age_band, 
     
     CASE
         WHEN LEFT(segment,1) = "C" THEN "Couples"
          WHEN LEFT(segment,1) = "F" THEN "Families"
          else "Unknown"
          end as demograohic ,
          customer_type, transactions, sales,
ROUND(sales/transactions,2) as "Avg_transaction"
FROM weekly_sales;
ALTER TABLE  Clean_weekly_sales change column  demograohic demographic varchar(50);
select * from clean_weekly_sales LIMIT 10;  

# Data Exploration
#Q1.  which week numbers are missing from the dataset?  (52 weeks in a year)
CREATE TABLE 	seq100(
X  INT not null auto_increment primary key);
select * from SEQ100;
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into SEQ100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 select  X+50 from seq100;

create table seq52 as ( SELECT X FROM SEQ100 LIMIT 52);
select * from seq52;
SELECT DISTINCT X as week_day from seq52 
WHERE X NOT IN ( SELECT distinct week_number  from clean_weekly_sales);

SELECT DISTINCT week_number FROM Clean_weekly_sales;

#Q2.  How many total transaction were there for each year in the dataset?
SELECT sum(transactions) AS Total_transaction, calender_year from clean_weekly_sales
group by calender_year;

#Q3. What are total sales for each region for each month?

SELECT SUM(sales) as Total_sales, region, month_number FROM clean_weekly_sales
group by region, month_number;

#Q4. What is the total count of transactions for each platform 

SELECT sum(transactions) as Total_transaction, platform from clean_weekly_sales
GROUP BY platform;

#Q5. What is the percentage of sales for Retail vs Shopify for each month?
WITH cte_monthly_platform_sales as (
SELECT month_number, calender_year, platform, SUM(sales) as monthly_sales from clean_weekly_sales
GROUP BY month_number, calender_year, platform)

SELECT month_number, calender_year, 
ROUND(100 * MAX(
CASE
	WHEN platform = "Retail" then monthly_sales else NULL END)/ SUM(monthly_sales),2) as retail_percentage,
ROUND(100 * MAX(
CASE
    WHEN platform = "Shopify" then monthly_sales else NULL END)/SUM(monthly_sales),2) as shopify_percentage
FROM cte_monthly_platform_sales

group by month_number, calender_year;


#Q6.  what is the percentage of sales by demographic for each year in the dataset?
SELECT calender_year, demographic, sum(sales) as Yearly_sales,
ROUND(100*SUM(sales)/SUM(SUM(sales)) over (partition by demographic),2) as Percentage
FROM clean_weekly_sales
GROUP BY calender_year, demographic;


#Q7. Which age_band and demographic values contribute the most to Retail sales?

SELECT age_band, demographic, SUM(sales) as Total_sales FROM clean_weekly_sales
WHERE platform = "Retail"
GROUP BY age_band, demographic
ORDER BY Total_sales DESC;




 





 
 
 
          
          

         








