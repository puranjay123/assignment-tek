create database if not exists bankingDB;
show databases;
use amitdb;
drop table banking;
create table if not exists banking(age INT,job VARCHAR(50),martial VARCHAR(50),
education VARCHAR(50),default_value VARCHAR(50),housing VARCHAR(10),loan VARCHAR(50),
contact VARCHAR(50),contact_month VARCHAR(30),day_of_week VARCHAR(20),duration INT,
campaign INT,pdays INT,previous INT,poutcome VARCHAR(20),
emp_var_rate DECIMAL(3,1),
cons_price_idx DECIMAL(6,3),
cons_conf_idx DECIMAL(6,3),
euribor3m DECIMAL(5,3),
nr_employed DECIMAL(6,1),y INT);
desc banking;

-- DML
-- 1.SELECT

select 1+1;
select now();

-- 2 . LIMIT - LIMIT the number of records
select age,job,martial from banking limit 5;

select concat('Harry','potter') as name;


-- 3. LOAD -It inserts records into table using CSV files



-- LOCAL: IT represents data location is in local disk
-- Enable READ FROM LOCAL DRIVE


SET GLOBAL local_infile = true;
LOAD DATA INFILE 'C:\Users\pkwatra\Downloads'
INTO table banking
fields terminated by ',' -- delimiter of columns
lines terminated by '\n' -- lines seperated by '\n' or '\r\n'
IGNORE 1 lines;
select * from banking limit 5;

-- 4. COUNT
select COUNT(*) as NUM_ROWS from banking;

-- 5 . DISPLAY NUM OF MISSING Rows
SELECT COUNT(*) AS 'num(total)',
COUNT(y) AS 'num (non-missing)',
COUNT(*) -COUNT(y) AS 'num (non-missing)',
(COUNT(*) -COUNT(y)) * 100/COUNT(*) AS '% missing'
FROM banking;

-- 7 . MAX,MIN,AVG OR MEAN
SELECT MIN(age) AS min_age,MAX(AGE) AS max_age,
AVG(AGE) AS mean_age FROM banking;

select MIN(duration) as min_duration,MAX(duration) as max_duration,
AVG(age) as mean_duration from banking;

-- 8 SUM
select SUM(duration)/3600 as Total_Duration_Hours from banking;

-- 9 STD,VAR
-- standard deviation is calculated the difference in values wrt mean
select variance(duration) as varaince,std(duration) as std_duration from banking;

select variance(age) as var_age,std(age) as std_age from banking;

-- 10. WHERE CLAUSE
-- Where clause allows you to specify a condition to search condition for
-- rows returned by a query. Where clause filter rows based on 
-- specified conditions.
select count(*) as position_customers from banking where y=1;

-- show only not null values from education
select education,duration from banking where y=1 and education is not null;

-- 11. ORDER BY

-- TO sort the rows in the result set, you add ORDER BY CLAUSE to select statement
-- ORDER BY ASC, desc
select age,contact_month,duration from banking where y =1
ORDER BY contact_month;

-- First month is in DESCENDING Order & then Duration in Ascending Order
select age,contact_month,duration from banking where y=1
ORDER BY contact_month DESC,duration asc;

-- 12 DISTINCT : show unique values from each column

-- T drop duplicate set from all result set.
-- MySQL evaluates DISTINCT clause  after from,where and select
-- before ORDER BY clause

select DISTINCT(education) as education from banking;
select DISTINCT(martial) as marital_status from banking;

-- LIKE:
-- LIKE Operator is a logical operator that tests whether a string
-- contains specified pattern or not;
select count(*) as success_customer from banking where poutcome LIKE 's%';

-- COunt of Customer with education basic 6 year
select count(*) as my_customer from banking where education LIKE '%.6%';

-- Group BY 
-- MYsql evaluates GROUP By clause after from and WHERE and before
-- having, select,distinct,order by LIMIT
-- from > where> GROUPBY >having>select>distinct>ORDERBY>LIMIT
-- Total customers contacted in each month
select contact_month,count(*) as target_customer from banking
group by contact_month;

-- Total target customers contact every week for each month
select contact_month,day_of_week,count(*) as target_customer
from banking group by contact_month,day_of_week;

-- show duration of call in hours for each weekday in each month
-- select duration,count(*) as call_duration from banking group by contact_month,day_of_week;

select contact_month,day_of_week,SUM(duration)/3600 as Duration_Hours from banking group by contact_month,day_of_week;

-- 15 . Having
-- MYSql Evaluates having CLAUSE after FROM,WHERE and GROUPBY
-- BEFORE SELET DISTINCT ORDERBY LIMIT
-- FInd total duration in hours customer contacted in month
-- and total number of positive customer
select contact_month,sum(y) as ordercount,
SUM(duration)/3600 as total_duration_hours
FROM banking
GROUP BY contact_month;


-- Use having clause on group by result set
select contact_month,sum(y) as ordercount,
SUM(duration)/3600 as total_duration_hours
FROM banking
-- WHERE y=1
GROUP BY contact_month
HAVING ordercount>100 and contact_month like 'a%';

-- 16 . ROLLUP
-- ROLLUP generates multiple grouping sets based on columns or 
-- expression specified in group by clause.alter
-- ROLL UP clause generates not only subtotals but along with the grand total of columns order clause.
-- The ROLL UP assumes that there is following hierarchy: c1>c2>c3
-- It generates grouping sets :(c1,c2,c3),(c1,c2),(c1),()
-- Those columns which are missing is termed as NULL
select job,SUM(y) as success_count
from banking
GROUP BY job WITH ROLLUP ORDER BY success_count;

select job,day_of_week,SUM(y) as success_count
from banking
GROUP BY job ,day_of_week WITH ROLLUP ORDER BY job;


-- select job,day_of_week,sum(y) from banking where job like 'm%' and day_of_week IS NULL job,day_of_week WITH ROLLUP;

select job,martial,day_of_week,COUNT(y) as success_count
from banking
WHERE y>0
GROUP BY job,martial,day_of_week WITH ROLLUP
ORDER BY job DESC;

-- 1. Each set of day_of_week rows for a given Job and marital status generates an extra aggregated summary.
-- martial satus generates an extra aggregated summary.

-- 2. Each set of marital rows for a given job  generates and extra  aggregated summary.


-- 17. SUBQUERY
-- A Mysql query is query nested within another query
-- such as SELECT,INSERT,UPDATE or DELETE
-- A Subquery can be nested within another subquery

-- Write a Query to show all success count where call duration 
-- was greater than avg duration
select contact_month, sum(y) from banking where (duration) > ( select avg(duration) from banking ) group by contact_month; -- from banking where sum(duration)>avg(duration))

-- FROM clause in Subquery
-- SELECT * FROM (subquery)
-- WHen you use subquery in the FROM Clause, the result set
-- returned from a subquery will be used as temporary table.

-- Write a Query to show WeeklWise MAX,MIN,MEAN Success status.
--  sum(y) from (select day_of_week,MAX(y) from(select day_of_week,MIN(y) from (select day_of_week,AVG(y) from banking group by day_of_week )));
-- SELECT day_of_week,sum(y),MIN(y),MAX(y),AVG(Y) from banking group by day_of_week;

SELECT max(sucess_count) as maxi,min(sucess_count) as mini,avg(sucess_count) as avgi from(select day_of_week,sum(y) as sucess_count from banking group by day_of_week) as t1;

-- 18. update
select age from banking;

select age,sum(y) as sucess_count from banking
group by age order by sucess_count desc;

ALTER TABLE banking ADD COLUMN age_group varchar(20);
SET SQL_SAFE_UPDATES = 0;
UPDATE banking
set age_group = if(age<=25,'<25',
if(age>40,'40+','25-40'));

select age_group,SUM(y) as success_count from banking
GROUP BY age_group order by success_count desc;
















avg = 920
job,
marital,
education,
default,
housing loan,
contact,
month,
day_of_week,
duration,
campaign
pdays,
previous,
poutcome,
emp_var_rate,
cons_price_idx,
cons_conf_idx,
euribor3m,