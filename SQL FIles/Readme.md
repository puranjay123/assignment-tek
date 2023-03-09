
# SQL Joins
SQL lets you join multiple data from muliptle tables.


You have the tools to obtain data from a single table in whatever format you want it. But what if the data you want is spread across multiple tables?

That's where JOIN comes in! JOIN is incredibly important in practical SQL workflows. So let's get started.
 ## Types of joins 
 #### Inner join 
 ![image](https://user-images.githubusercontent.com/55429956/223373090-e178e1de-0b2e-4769-832f-89be2433dbbd.png)
In inner join it has common elements of both of the tables

### Left outer join - when the left side of table is complete and has common elemets of both the elements which is releveant to the left side is left outer join
![image](https://user-images.githubusercontent.com/55429956/223375288-2b944ce5-8043-465d-906e-e91084c1338a.png)

* example
  * Find all product which been ordered as well as not ordered from past 15 days.
### Right outer join.
Fetch all records present orders. transaction for products wheather it is present in product table or not.
![image](https://user-images.githubusercontent.com/55429956/223377041-be959731-cc38-4d28-a3b4-55c5ac5243f9.png)

*** Full Outer Join- It is union of both left outer join and right outer join
Union of all rows present in all tables.

Transactions:
Database - > Orderers,order details,customer details,product details.
1) New Sales will be added to as new value to table orders. -> Query this table to get sales order
2) Insert new sales order into orders table
3) get newly inseryed sales order id
4) afte rthis ipdaye order details into order details tables with same order id
5) select data from both tables to finally commit changes

 
