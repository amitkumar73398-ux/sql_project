DROP TABLE IF EXISTS zepto;


create table zepto (
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,	
quantity INTEGER
);

--2.Data Exploration

--Count records
Select count(*) from zepto

--sample dataset
select * from zepto
limit 2;

--null value
Select * from zepto
where  category IS NULL
or name IS NULL
or mrp IS NULL
or discountpercent IS NULL
or availablequantity IS NULL
or discountedsellingprice IS NULL
or weightingms IS NULL
or outofstock IS NULL
or quantity IS NULL

--Identified distinct product categories available in the dataset
select category, count(category) as c from zepto
group by category;

--products in stock vs out of stock
select name, count(availablequantity) as c from zepto
GROUP BY name
HAVING count(availablequantity) >=1 

select outofstock, count(sku_id) from zepto
group by outofstock

--product names present multiple times
select name , count(sku_id) as "no.of sku" from zepto
group by name 
having count(sku_id) >1
order by count(sku_id) desc;


-- Data cleaning
select * from zepto
where discountedsellingprice=0 or mrp=0; 

delete from zepto
where discountedsellingprice=0 or mrp=0; 


--BUSINESS INSIGHTS
-- Q1. Find the top 10 best-value products based on the discount percentage.
select distinct name , discountpercent, mrp from zepto
order by discountpercent desc
limit 10;
-- Q2. Identified high-MRP products that are currently out of stock
select distinct name ,mrp from zepto
where outofstock ='true'
order by mrp desc
limit 5;

-- Q.3 Estimated potential revenue for each product category
select category,sum(availablequantity * discountedsellingprice) as total
from zepto
group by category
order by sum(availablequantity * discountedsellingprice )desc

--Q.4 Filtered expensive products (MRP > ₹500) with minimal discount
select distinct name ,mrp,discountpercent from zepto
where mrp>500 AND discountpercent < 10.00
Order by mrp desc;

--Q.5 Ranked top 5 categories offering highest average discounts
select category , round(AVG(discountpercent),2) as discount from zepto
GROUP BY category
order  by avg_value desc
limit 5;

--Q6. Find the price per gram for products above 100g and sort by best value.
select distinct name ,discountedsellingprice,weightingms ,ROUND(discountedsellingprice /weightingms,2) as PRICE_PER_GRAM 
from zepto
where weightingms >=100 
order by ROUND(discountedsellingprice /weightingms,2) ;

--Q7. Grouped products based on weight into Low, Medium, and Bulk categories
select DISTINCT name , weightingms, 
CASE WHEN weightingms <1000 then 'LOW'
     WHEN weightingms < 5000 then 'MEDIUM'
	 ELSE 'BULK'
END AS weight_status
FROM zepto
ORDER BY weight_status;

--Q8.Measured total inventory weight per product category
SELECT category, sum(weightingms*availablequantity) AS avg_weight FROM zepto
GROUP BY category
ORDER BY  avg_weight DESC;

