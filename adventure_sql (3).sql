create database adventure;
use adventure;
show databases;
show tables;
desc factinternetsales;
select *from factinternetsales;
select *from sales;
select carriertrackingnumber,customerponumber from factinternetsales;
rename table factinternetsales to Sales;
rename table fact_internet_sales_new to sales_New;
alter table sales_new
drop column CarrierTrackingNumber,
drop column CustomerPONumber;
alter table sales 
modify column unitprice decimal (10,2);
alter table sales 
modify column ProductStandardCost decimal (10,2);
alter table sales 
modify column TotalProductCost decimal (10,2);
alter table sales 
modify column TaxAmt decimal (10,2);
alter table sales 
modify column Freight decimal (10,2);

show tables;
select * from sales;
select *from sales_new;
alter table sales_new
drop column CarrierTrackingNumber,
drop column CustomerPONumber;
alter table sales_new
modify column unitprice decimal (10,2);
alter table sales_new
modify column ProductStandardCost decimal (10,2);
alter table sales_new
modify column TotalProductCost decimal (10,2);
alter table sales_new
modify column TaxAmt decimal (10,2);
alter table sales_new 
modify column Freight decimal (10,2);
select *from sales_new;
select *from sales;
select *from sales_new;
alter table sales 
change column ï»¿ProductKey productkey varchar(20);
alter table sales_new
change column ï»¿ProductKey productkey varchar(20);
select count(*) from sales;
select count(*) from sales_new;

select count(*) from combined_sales;
SELECT ROUND(SUM(SalesAmount) / 1000000, 2) AS SalesInMillions
FROM combined_sales;

show tables;
select *from combined_sales;
select * from dimproduct;
select * from dimcustomer;
select * from dimdate;
select * from dimproductcategory;
select * from dimproductsubcategory;
select *from dimsalesterritory;
alter table dimcustomer
change column ï»¿CustomerKey customerkey int;

alter table dimsalesterritory
change column ï»¿SalesTerritoryKey SalesTerritoryKey int;
alter table dimsalesterritory
change column SalesTerritoryRegion Region varchar(30);
alter table dimsalesterritory
change column SalesTerritoryCountry country varchar(30);
alter table dimsalesterritory
change column SalesTerritoryGroup salesgroup varchar(30);

create table combined_sales as
select *from sales
union all 
select *from sales_new;

select *from combined_sales;
select count(*) from combined_sales;
alter table combined_sales
add column profit decimal(10,2);
#---------------profit---------------------------
UPDATE combined_sales
SET profit = SalesAmount - TotalProductCost ;

ALTER TABLE combined_sales
add column profit decimal(10,2),
ADD COLUMN year INT,
ADD COLUMN month_name VARCHAR(20),
ADD COLUMN month_number INT,
ADD COLUMN quarter INT;

UPDATE combined_sales
SET month_name = monthname(OrderDate);
UPDATE combined_sales
SET year = year(OrderDate);
UPDATE combined_sales
SET month_number = month(OrderDate);
UPDATE combined_sales
SET quarter = quarter(OrderDate);

select *from combined_sales;
#--------------- Totalsales(M)------------------------------------
SELECT ROUND(SUM(SalesAmount) / 1000000, 2) AS SalesInMillions
FROM combined_sales;
#----------------Totalprofit(M)-----------------------
select round(sum(profit) / 1000000,2) `profit%` from combined_sales;
#----------------Year/sales---------------------
select  year,round(sum(salesamount)/1000000,2) Totalsales from combined_sales
group by 1
order by 1;
#-----------------year,month & Totalsales---------------------
select year,month_name,month_number,round(sum(salesamount),2) Totalsales from combined_sales
group by 1,2,3
order by 1,3;
#------------Totalorders----------------
select count(orderquantity) Total_orders from combined_sales;
#---------------Region/Totalsales----------------------
select t.region, round(sum(c.salesamount),2) Totalsales 
from dimsalesterritory t
join 
combined_sales c on t.SalesTerritoryKey = c.SalesTerritoryKey
group by 1
order by 2;
#-------------------country/Totalsales--------------------
select t.country, round(sum(c.salesamount) / 1000000,2) Totalsales 
from dimsalesterritory t
join 
combined_sales c on t.SalesTerritoryKey = c.SalesTerritoryKey
group by 1
order by 2;
#-----------------sales amount--------------------------------------
SELECT 
SalesOrderNumber,
unitprice,
OrderQuantity,
UnitPriceDiscountPct,
unitprice * OrderQuantity  * (1 - UnitPriceDiscountPct) AS sales_amount
FROM 
combined_sales
order by sales_amount desc
limit 10 ;
#------------------------production cost---------------------------
SELECT 
unitprice,
OrderQuantity,
unitprice * OrderQuantity AS production_cost
FROM 
combined_sales
order by 3 desc
limit 5;

