--Who are the Top 5 Customers by Total Spending?
create view vw_customers_spending as

with CustomerSales as
(
	select 
	c.customer_unique_id as customers_id,
	count(distinct o.order_id) as total_order,
	sum(p.payment_value) as total_spending
	from customers c
	inner join orders o
	on o.customer_id = c.customer_id
	inner join payments p
	on p.order_id = o.order_id
	where o.order_status = 'delivered' 
	group by c.customer_unique_id
),
rankcustomer as
(
	select 
	*,
	DENSE_RANK() over(order by total_spending desc) as rank_customer
	from CustomerSales
)

select 
rank_customer,
customers_id,
total_spending,
total_order
from rankcustomer
where rank_customer <= 5


-- total customer by city and state
create view vw_customer_city_state as

select 
c.customer_city,
c.customer_state ,
avg(g.geolocation_lat) as lat,
avg(g.geolocation_lng) as lng,
count(distinct c.customer_unique_id) total_customer 
from customers c
inner join geolocation g
on g.geolocation_zip_code_prefix = c.customer_zip_code_prefix
group by c.customer_city , c.customer_state


-- How can we classify customers based on their total spending?
create view vw_classify_customers_spending as

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



-- customer spending by installments
create view vw_customer_spending_by_installments as

select
    p.payment_installments,
    count(distinct c.customer_unique_id) as total_customers,
    count(distinct o.order_id) as total_orders,
    sum(py.payment_value) as total_spending,
    avg(py.payment_value) as average_order_value
from customers c
inner join orders o
    on c.customer_id = o.customer_id
inner join payments py
    on py.order_id = o.order_id
inner join payments p
    on p.order_id = o.order_id
where o.order_status = 'delivered'
group by p.payment_installments;

-- customer retention
create view vw_customer_retention as

with customer_orders as
(
    select
        c.customer_unique_id,
        count(distinct o.order_id) as total_orders
    from customers c
    inner join orders o
        on o.customer_id = c.customer_id
    group by c.customer_unique_id
)

select
    sum(case when total_orders = 1 then 1 else 0 end) as one_time_customers,
    sum(case when total_orders > 1 then 1 else 0 end) as repeat_customers
from customer_orders;