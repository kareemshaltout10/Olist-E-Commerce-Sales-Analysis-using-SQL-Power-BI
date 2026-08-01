 -- total revenue

 select 
 sum(i.price) as total_revenue
 from order_items i
 inner join orders o
 on o.order_id = i.order_id
 where o.order_status = 'delivered'

 -- Find the average selling price
select 
avg(price) as avg_price
from order_items

-- Find the Total number of Orders
select 
count(order_id) as total_orders
from orders

-- Find the total number of products
select
count(product_id) as total_product
from products

-- Find the total number of customers
select
count(DISTINCT customer_unique_id) as total_customer
from customers

