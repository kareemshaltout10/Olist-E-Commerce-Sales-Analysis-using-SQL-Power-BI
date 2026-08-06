-- Number of orders in each order status

create view vw_orders_status_summary as

select 
count(*) as orders ,
order_status
from orders
group by order_status



