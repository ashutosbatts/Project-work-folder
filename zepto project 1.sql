create table zepto(
sku_id serial primary key,
category varchar(120),
name varchar(150) not null,
mrp numeric(10,2),
discountpercent numeric(5,2),
availablequantity integer,
discountedsellingprice numeric(10,2),
weightingrams integer,
outofstock boolean,
quantity integer
);
--data exploration
--count of rows
select count(*) from zepto;
--sample data 
select*from zepto
limit 10
--null values
select * from zepto
where 
name is null
or
category is null
or 
mrp is null
or
discountpercent is null
or
availablequantity is null
or
discountedsellingprice is null
or
weightingrams is null
or
outofstock is null
or
quantity is null;
--different product category
select distinct category
from zepto
order by category;
--products in stock vs out of stock
select outofstock,count(sku_id)
from zepto 
group by outofstock;
--product names present multiple times
select name,count(sku_id) as "number of skus"
from zepto
group by name
having count(sku_id)>1
order by count(sku_id) desc;
--data cleaning
--products with price = 0
select *
from zepto
where mrp = 0 or discountedsellingprice = 0;

delete from zepto
where mrp = 0 ;
--convert paise to rupees
update zepto
set mrp = mrp/100.0,discountedsellingprice = discountedsellingprice/100.0; 

select mrp,discountedsellingprice from zepto

--1. find the top 10 most valued product based on the discount percentage
select sku_id,name,discountpercent
from zepto
order by discountpercent desc;
--2. what are the products with high mrp but out of stock
select distinct name,mrp 
from zepto
where outofstock = True and mrp>300
order by mrp desc;
--3. calculate estimated revenue for each category
select category,sum(discountedsellingprice*availablequantity)as total_revenue
from zepto
group by category
order by total_revenue
--4. find all products where mrp is greater than 500 and discount is less than 10%
select distinct name,mrp,discountpercent
from zepto
where mrp>500 and discountpercent< 10
order by mrp desc , discountpercent desc
--5. identify the top 5 categories offering the highest average discount percentage.
select category,round(avg(discountpercent),2)as highest_average_discount
from zepto
group by category
order by highest_average_discount desc
limit 5
--6. find the price per gram for products above 100g and sort by best value.
select distinct name,weightingrams,discountedsellingprice,
Round(discountedsellingprice/weightingrams,2) 
as price_per_gram
from zepto
where weightingrams >= 100
order by price_per_gram desc;
--7. group the group products into categories like low,medium,bulk.
select distinct name,weightingrams,
case when weightingrams<1000 then 'low'
    when weightingrams<5000 then 'medium'
	else 'bulk'
	end as weight_category
from zepto;