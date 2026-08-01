-- who are the top 10 sellers in terms of total sales?


with sellers_sales as
(
	select 
	s.seller_id,
	sum(i.price ) as total_revenue,
	count(DISTINCT o.order_id) as total_orders
	from sellers s
	inner join order_items i 
	on s.seller_id = i.seller_id
	inner join orders o
	on o.order_id = i.order_id
	where o.order_status = 'delivered'
	group by s.seller_id
),
rankedseller as
(
	select 
	*,
	dense_rank() over(order by total_revenue desc) as rank_sellers
	from sellers_sales
)

select 
rank_sellers,
seller_id,
total_revenue,
total_orders
from rankedseller
where rank_sellers <= 10
order by rank_sellers 


-- Who are the Top 10 Product Categories by Revenue?

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

--Who are the Top 5 Customers by Total Spending?

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


