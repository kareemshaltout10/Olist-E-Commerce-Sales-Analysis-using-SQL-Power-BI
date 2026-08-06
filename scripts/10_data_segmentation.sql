-- How can we classify customers based on their total spending?


select 
c.customer_unique_id as customers_id,
sum(p.payment_value) as total_spending,
case 
	when sum(p.payment_value) >= 1000 then 'VIP'
	when sum(p.payment_value) >= 500 then 'High Value'
	when sum(p.payment_value) >=100 then 'Medium Value'
	else 'Low Value'
end customer_segment
from customers c
inner join orders o
on o.customer_id = c.customer_id
inner join payments p
on p.order_id = o.order_id
where o.order_status = 'delivered' 
group by c.customer_unique_id

--==============================================

with customersegment as
(
	select 
	c.customer_unique_id as customers_id,
	sum(p.payment_value) as total_spending,
	case 
		when sum(p.payment_value) >= 1000 then 'VIP'
		when sum(p.payment_value) >=500 then 'High Value'
		when sum(p.payment_value) >=100 then 'Medium Value'
		else 'Low Value'
	end customer_segment
	from customers c
	inner join orders o
	on o.customer_id = c.customer_id
	inner join payments p
	on p.order_id = o.order_id
	where o.order_status = 'delivered' 
	group by c.customer_unique_id
)

select 
customer_segment,
sum(total_spending) as total_spending ,
count(customers_id) as Number_of_Customers ,
avg(total_spending) as average_spending
from customersegment 
group by customer_segment
order by total_spending desc




--Which products should the company prioritize based on their contribution to total revenue?

with ProductCategoryRevenue as
(
	select 
	t.product_category_name_english,
	sum(i.price) as total_revenue
	from products p
	inner join order_items i
	on p.product_id = i.product_id
	inner join category_translation t
	on t.product_category_name = p.product_category_name
	inner join orders o
	on o.order_id = i.order_id
	where o.order_status = 'delivered'
	group by t.product_category_name_english
),

CumulativeRevenue as 
(
	select 
	*,
	sum(total_revenue) over(order by total_revenue desc) as cumulative
	from ProductCategoryRevenue
),

cumulativepercentage as
(
	select 
	*,
	cast(round((cumulative * 100.0 / sum(total_revenue) over() ),2) as decimal(10,2))as cumulative_percentage
	from CumulativeRevenue 
)

select
*,
case 
	when cumulative_percentage <= 80 then 'A'
	when cumulative_percentage <= 95 then 'B'
	else 'C'
end product_class
from cumulativepercentage 


-- Number of customers who made a one-time purchase.

with One_Time_Customers as
(
select 
customer_unique_id,
count(order_id) as orders
from customers c
inner join orders o
on o.customer_id = c.customer_id
group by customer_unique_id
having count(order_id) = 1
)

select 
'One Time Customers' as metric,
count(*) as value
from One_Time_Customers

union all

select 
'total_customer' as metric ,
count(customer_unique_id) as value
from customers


