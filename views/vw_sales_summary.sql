-- total sales by month
create view vw_revenue_by_month as

select 
cast(datetrunc(month,o.order_purchase_timestamp) as date) date_month ,
sum(i.price) as total_sales 
from orders o
join order_items i
on o.order_id = i.order_id
where o.order_status = 'delivered'
group by datetrunc(month,o.order_purchase_timestamp)  


-- Who are the Top 10 Product Categories by Revenue?
create view vw_revenue_by_categories as 

with CategorySales as 
(
	select 
	t.product_category_name_english as category_name ,
	sum(i.price) as total_price,
	count(distinct o.order_id) as total_order
	from products p
	inner join order_items i
	on p.product_id = i.product_id
	inner join orders o
	on i.order_id = o.order_id
	inner join category_translation t
	on t.product_category_name = p.product_category_name
	where o.order_status = 'delivered'
	group by t.product_category_name_english
),
RankedCategories as
(
	select 
	*,
	DENSE_RANK() over(order by total_price desc) as rank_category
	from CategorySales
)

select 
rank_category,
category_name,
total_price,
total_order
from RankedCategories
where rank_category <=10

-- revenue by state by year
create view vw_revenue_by_state as

with totalrevenue as 
(
	select 
	c.customer_state as state,
	sum(i.price) as total_revenue ,
	cast(datetrunc(month,o.order_purchase_timestamp) as date) date_month
	from customers c
	inner join orders o
	on o.customer_id = c.customer_id
	inner join order_items i
	on o.order_id = i.order_id
	where o.order_status = 'delivered'
	group by c.customer_state , datetrunc(month,o.order_purchase_timestamp)
),
rankstate as
(
	select
	*,
	dense_rank() over(order by total_revenue desc) as rank
	from totalrevenue
)

select 
state ,
date_month ,
total_revenue
from rankstate
