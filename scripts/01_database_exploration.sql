-- How many records are in each table?

select 'customers' as table_name, count(*) as total_records
from customers

union all

select 'orders', count(*)
from orders

union all

select 'order_items', count(*)
from order_items

union all

select 'products', count(*)
from products

union all

select 'sellers', count(*)
from sellers

union all

select 'payments', count(*)
from payments

union all

select 'reviews', count(*)
from reviews

union all

select 'geolocation', count(*)
from geolocation

union all

select 'category_translation', count(*)
from category_translation

order by total_records desc;

-- Number of orders in each order status

select 
count(*) as orders ,
order_status
from orders
group by order_status
order by count(*) desc