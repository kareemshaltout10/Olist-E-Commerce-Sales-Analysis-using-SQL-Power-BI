-- What is the time span covered by the Olist dataset?

select 
min(order_purchase_timestamp) as first_order_date,
max(order_purchase_timestamp) as last_order_date,
DATEDIFF(month,min(order_purchase_timestamp),max(order_purchase_timestamp)) as order_range_month,
DATEDIFF(day,min(order_purchase_timestamp),max(order_purchase_timestamp)) as order_range_day
from orders 