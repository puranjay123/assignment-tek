
#   Notes-TEK
RDBMS-Relational Database managemnet system
### it consist of 
  * collection of objects and relation
  * set of operations to act on the relations
  * data integrity for accuracy and consistency



## Replace by Central tendency
* Drop rows
* Continous - Apply mean()
* Discrete-> Apply mean,median


#### Note *[Replace by mode in categorical data]
* categorical Data -> Nominal
                   -> Ordinal(Grades,Position,Econimic states)
                   -> Dichotomus(only two category)[male,female]
                   
<pre><code>This is a code block.


--create a table with given schema
create table if not exists Employee(
empid varchar(20) NOT NULL,
empname varchar(50),

age int,
gender varchar(10),
department varchar(40),
salary(int),primary key(empid));

show tables;

INSERT INTO employee VALUES('TEK10001','Tarandeep',22,'MALE','Finance','10000');
select * from emloyee;

</code></pre>
