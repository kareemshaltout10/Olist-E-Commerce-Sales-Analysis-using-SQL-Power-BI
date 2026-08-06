create view vw_delivery_status as

select
count(*) as orders,
delivery_status 
from(
	select
	case 
		when DATEDIFF(day, order_delivered_customer_date, order_estimated_delivery_date) > 0 then 'Delivered Early'
		when DATEDIFF(day, order_delivered_customer_date, order_estimated_delivery_date) = 0 then 'Delivered On Time'
		else 'Delivered Late'
	end delivery_status
	from orders
	where order_delivered_customer_date is not null 
)t
group by delivery_status	