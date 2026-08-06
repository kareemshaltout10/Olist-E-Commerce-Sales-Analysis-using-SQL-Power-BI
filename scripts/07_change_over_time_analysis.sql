-- total sales by month 

select 
cast(datetrunc(month,o.order_purchase_timestamp) as date) date_month ,
sum(i.price) as total_sales 
from orders o
join order_items i
on o.order_id = i.order_id
where o.order_status = 'delivered'
group by datetrunc(month,o.order_purchase_timestamp)  
order by datetrunc(month,o.order_purchase_timestamp) 

-- How has the company's revenue changed month over month?

with total_sales_month as
(
	select 
	cast(datetrunc(month,o.order_purchase_timestamp) as date) date_month,
	sum(i.price) as total_revenue
	from orders o
	inner join order_items i
	on i.order_id = o.order_id
	where o.order_status = 'delivered'
	group by datetrunc(month,o.order_purchase_timestamp)   
),
previous_month as
(
	select 
	*,
	lag(total_revenue) over(order by date_month ) as previous_month_revenue
	from total_sales_month
)

select 
*,
total_revenue - previous_month_revenue as revenue_difference ,
round((total_revenue - previous_month_revenue) * 100.0 / nullif(previous_month_revenue,0) ,2) as growth_percentage
from previous_month


