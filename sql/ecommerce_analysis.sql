create database Ecommerce_Analysis;
use Ecommerce_Analysis;

create table customers (
   customer_id int primary key,
   country varchar(100),
   signup_date date
);

Create table products (
   product_id INT PRIMARY KEY,
   product_name VARCHAR(150),
   category VARCHAR(100)
);

create table orders (
   order_id int primary key,
   customer_id int,
   order_date date,
   status varchar(50)
);

create table order_items (
   order_id int, 
   product_id int,
   quantity int,
   price decimal(10,2)
);
select * from customers;
select * from products;
select * from orders;
select * from order_items;

-- 1) understanding dataset
select count(*) as total_customers
from customers;

select count(*) as total_orders
from orders;

-- 2) Analyze order status
select status, count(*) as total_orders
from orders 
group by status
order by total_orders desc;

-- 3) customers by country
select country, count(*) as total_customers
from customers
group by country
order by total_customers;

-- 4) Total sales revenue
select sum(quantity * price) as total_revenue
from order_items;

-- 5) Total units sold
select sum(quantity) as total_units_sold
from order_items;

-- 6) Revenue by product category
select category, sum(quantity * price) as revenue
from order_items as oi
join products as p on oi.product_id=p.product_id
group by p.category
order by revenue desc;

-- 7) Top 10 products by revenue
select p.product_name, sum(quantity * price) as revenue
from order_items as oi
join products as p on oi.product_id=p.product_id
group by p.product_name
order by revenue desc
limit 10;

-- 8) Top 5 products by category
select p.product_name, p.category, sum(quantity * price) as revenue
from order_items as oi
join products as p on oi.product_id=p.product_id
group by p.product_name, p.category
order by revenue desc
limit 5;

-- 9) customer spending
select c.customer_id,c.country,sum(oi.quantity*oi.price) as total_spent
from customers c
join orders o on c.customer_id=o.customer_id
join order_items oi on o.order_id=oi.order_id
group by  c.customer_id,c.country
order by total_spent desc;

-- 10) monthly revenue trend
select year(o.order_date) as year, month(o.order_date) as month, sum(oi.quantity*oi.price) as revenue
from orders o
join order_items oi on o.order_id=oi.order_id
group by year(o.order_date),  month(o.order_date)
order by year,month;

-- 11) average order value
select round(sum(oi.quantity*oi.price)/count(distinct o.order_id),2) as average_order_value
from orders o
join order_items oi on o.order_id=oi.order_id;

-- 12) Revenue by country
select c.country, sum(oi.quantity*oi.price) as revenue
from customers c
join orders o on c.customer_id=o.customer_id
join order_items oi on o.order_id=oi.order_id
group by c.country
order by revenue desc;

-- 13) customers who have never placed order
select c.customer_id,c.country,o.status
from customers c
left join orders o on c.customer_id = o.customer_id
where o.order_id is null;

-- 14) Products that have never been sold
select p.product_id,p.product_name,p.category
from products p
left join order_items oi on p.product_id= oi.product_id
Where oi.product_id is null;

-- 15) Revenue from completed orders
select  sum(oi.quantity*oi.price) as completed_revenue
from order_items oi
join orders o on oi.order_id=o.order_id
where o.status='Completed';



