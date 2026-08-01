-- Are a small number of sellers responsible for the majority of the revenue?
-- Pareto Analysis

with saller_revenue as 
(
	select 
	s.seller_id,
	sum(i.price) as total_price
	from sellers s
	inner join order_items i
	on i.seller_id = s.seller_id
	inner join orders o
	on o.order_id = i.order_id
	where o.order_status = 'delivered'
	group by s.seller_id
),
cumulative_revenue as 
(
	select 
	*,
	sum(total_price) over(order by total_price desc) as cumulative_revenue
	from saller_revenue
)

select 
*,
cast(cast(round((cumulative_revenue * 100 / sum(total_price) over() ),2) as decimal(10,2)) as varchar) + '%' as 'Cumulative %'
from cumulative_revenue