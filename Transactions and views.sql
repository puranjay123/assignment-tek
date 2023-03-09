-- steps to be followed
-- 1. use te start Transaction statemnet. the BEGIN or BEGIN WORK are teh aliases of the start transaction
-- 2. Insert new data into table.
-- 3. To commit the current transaction and make changes peramanent, you can use commit statement.
-- 4. To rollback the current transaction and cancel its changes,you can use ROLLBACK statement.
-- 5. To disable/enable auto-commit mode for cureent transaction,you can "SET auto-commit".
-- 6. My sql automatically commits the changes permamentely to your DB
-- 7. Disable it using set autocommit = 0;
-- auto commit[we turn it off because we check if the data is right then we commit in the database]



-- NOtes: In transaction we insert the data but we have more control we can review our insertion and change it and then we can commit it to the database
use tekdb;

DROP TABLE IF EXISTS orderss;

CREATE TABLE orderss(
ordernum int,
order_date date NOT NULL,
required_date date NOT NULL,
shipped_date date default NULL,
status varchar(30) NOT NULL,
comments text,
customernum int(11) NOT NULL,
PRIMARY KEY (ordernum)
) ENGINE=InnoDB DEFAULT CHARSET = latin1;
-- InnoDB is storage engine in mysql8.0(by default)
describe orders;

insert  into orderss(ordernum,order_date,required_date,shipped_date,
`status`,comments,customernum) values
(10100,'2003-01-06','2003-01-13','2003-01-10','Shipped',NULL,363),
(10101,'2003-01-09','2003-01-18','2003-01-11','Shipped',
'Check on availability.',128),
(10102,'2003-01-10','2003-01-18','2003-01-14','Shipped',NULL,181),
(10103,'2003-01-29','2003-02-07','2003-02-02','Shipped',NULL,121),
(10104,'2003-01-31','2003-02-09','2003-02-01','Shipped',NULL,141),
(10105,'2003-02-11','2003-02-21','2003-02-12','Shipped',NULL,145),
(10106,'2003-02-17','2003-02-24','2003-02-21','Shipped',NULL,278),
(10107,'2003-02-24','2003-03-03','2003-02-26','Shipped',
'Customer requested to deliver in office address between 9:30 to 18:30
for this shipping',131),
(10108,'2003-03-03','2003-03-12','2003-03-08','Shipped',NULL,385),
(10109,'2003-03-10','2003-03-19','2003-03-11','Shipped',
'Customer requested for early delivery using Amazon Prime',486);

DROP TABLE IF EXISTS orderdeails;

CREATE TABLE orderdeails(
ordernum int NOT NULL,
productCode varchar(15) NOT NULL,
quantityOrdered int(11) NOT NULL,
priceEach decimal(10,2)  NULL,
orderLineNumber smallint(6) NOT NULL,
-- status varchar(30) NOT NULL,
-- comments text,
-- customernum int(11) NOT NULL,
PRIMARY KEY (ordernum,productCode),
KEY productCode(productCode),
CONSTRAINT `orderdetails_1`
FOREIGN KEY(ordernum) REFERENCES orderss(ordernum)
) ENGINE=InnoDB DEFAULT CHARSET = latin1;
describe orderdeails;

insert  into orderdeails (ordernum,productCode,
quantityOrdered,priceEach,orderLineNumber) values
(10100,'S18_1749',30,'136.00',3),
(10100,'S18_2248',50,'55.09',2),
(10100,'S18_4409',22,'75.46',4),
(10101,'S18_2325',25,'108.06',4),
(10101,'S18_2795',26,'167.06',1),
(10101,'S24_1937',45,'32.53',3),
(10102,'S18_1342',39,'95.55',2),
(10102,'S18_1367',41,'43.13',1),
(10104,'S12_3148',34,'131.44',1),
(10104,'S12_4473',41,'111.39',9),
(10105,'S10_4757',50,'127.84',2),
(10105,'S12_1108',41,'205.72',15),
(10106,'S18_1662',36,'134.04',12),
(10106,'S18_2581',34,'81.10',2);
select column_name,constraint_name,referenced_column_name,
referenced_table_name
from information_schema.KEY_COLUMN_USAGE
where table_name = 'orderdeails';

set autocommit = 0;
-- 1 start a new transaction
START TRANSACTION;

-- 2. Get the latest order number
SELECT
	@ordernum := MAX(ordernum)+1
FROM orderss;

-- 3 . Insert a new order for customer
INSERT INTO orderss(ordernum,order_date,required_date,shipped_date,status,customernum)
VALUES(@ordernum,
'2023-03-01',
'2005-03-05',
'2005-03-08',
'In Process',
1234);

-- 4 . Insert order line items
INSERT INTO orderdeails
(ordernum,productCode,quantityOrdered,priceEach,orderLineNumber)
VALUES(@ordernum,'S18_1749',30,'136',1),
		(@ordernum,'S18_2248',50,'55.09',2);
-- 5. commit changes
COMMIT;
select * from orderss;
START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;

DELETE from orderdeails;
DELETE from orderss;
ROLLBACK;
select * from orderss;


-- VIEWS
-- view will be useful in 
-- views are database objecy
-- views is created over a SQL QUery
-- Views are like virtual table and doesnot store any data.

create table if not exists customer_data(cust_id varchar(20),customer_name varchar(60),phone bigint,email varchar(50),
city_name varchar(50));
create table if not exists product(product_id varchar(20),product_name varchar(50),`brand-company` varchar(60),price int);

create table if not exists order_details (order_id int, product_id varchar(20),quantity int,cust_id varchar(20),discount float,date_of_order date);


INSERT INTO customer_data
VALUES
('C1', 'Divya Parasher', 123456789321, 'parasherdivya@example.com', 'Mathura'),
('C2', 'Mahad Ulah', '456544831568', 'ullahmahad@example.com', 'Bhopal'),
('C3', 'Arya Pratap Singh', '93543168435', 'aryasingh@example.com', 'lucknow'),
('C3', 'Atreya Bag', '78965168321', 'bagatreya@example.com', 'Vizag'),
('C4', 'Mukund Sahu', '673218987351', 'mukund@example.com', 'Mumbai'),
('C5', 'Parth Tyagi', '8989989899', 'parth@example.com', 'Kota');
INSERT INTO product
VALUES
    ('DF12321', 'Mouse', 'Dell', 19.37),
    ('AM12322', 'Laptop', 'Apple Inc.', 999.41),
	('MP12333', 'Books', 'Pustak Mahal', 5.19),
    ('12335M', 'Bottle', 'Milton', 29.35),
    ('SB12387I', 'Backpack', 'Sky Bags', 89.75),
    ('PT12389TS', 'Tshirt', 'Polo', 3.53);
INSERT INTO order_details
(order_id, product_id, quantity, cust_id, discount, date_of_order)
VALUES
    (1111, 'DF12321', 3, 'C2', 0.05, '2022-02-01'),
    (2122, 'AM12322', 2, 'C1', 0.25, '2022-02-02'),
    (3323, 'MP12333', 5, 'C1', 0.15, '2022-02-03'),
    (4447, '12335M', 2, 'C3', 0.10, '2022-02-04'),
    (5655, 'SB12387I', 3, 'C2', 0.10, '2022-02-05'),
    (6686, 'PT12389TS', 1, 'C4', 0.15, '2022-02-06');
select * from order_details;
select * from product;
select * from customer_data;
-- create a query to show order summary to be delivered to client
create view product_order_summary as

select o.order_id,o.date_of_order,p.product_name,c.customer_name,
round((p.price*o.quantity)-((p.price*o.quantity) * discount/100)) as cost
from customer_data c
join order_details o on o.cust_id = c.cust_id
join product p on p.product_id = o.product_id;

-- Display output of view
select * from product_order_summary;

-- show view summary
show create view product_order_summary;

-- security in View is by grant
-- create role username login access and password 'login password'
-- syntax: grant select on 'view-name' to 'username'
grant select on product_order_summary to root;


-- SEcurity in View:
-- Hiding entire query/table names/ used  to generate the view

-- CREATE OR REPLACE VIEW
	--  Cannot changes column name,or column sequence or order
    -- But can add a new column in the end
create or replace view product_order_summary
as 

select o.order_id,o.date_of_order,p.product_name,c.customer_name,
round((p.price*o.quantity)-((p.price*o.quantity) * discount/100)) as cost
from customer_data c
join order_details o on o.cust_id = c.cust_id
join product p on p.product_id = o.product_id;


-- alter view
-- rename existing view columns with new columns

ALTER
 ALGORITHM = MERGE
 VIEW product_order_summary AS
 select o.order_id,o.date_of_order,p.product_name as prod_name,c.customer_name,
round((p.price*o.quantity)-((p.price*o.quantity) * discount/100)) as cost
from customer_data c
join order_details o on o.cust_id = c.cust_id
join product p on p.product_id = o.product_id;

DROP view product_order_summary;

-- update
create or replace view expensive_products
as select * from product where price>80;
select * from expensive_products;
select * from product;
SET sql_safe_updates=0;
update expensive_products
set product_name = 'Airpods Pro' ,`brand-company` = 'Apple',
price = 1000
where product_id = 'AP10010';
select * from expensive_products;

 




