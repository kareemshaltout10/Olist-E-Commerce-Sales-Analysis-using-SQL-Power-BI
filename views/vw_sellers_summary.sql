create view vw_sellers_sales as

with sellers_sales as
(
	select 
	s.seller_id,
	sum(i.price ) as total_sales,
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
	dense_rank() over(order by total_sales desc) as rank_sellers
	from sellers_sales
)

select 
rank_sellers,
seller_id,
total_sales,
total_orders
from rankedseller
where rank_sellers <= 10




create view vw_seller_review_analysis as

select
    i.seller_id,
    sum(i.price) as total_revenue,
    count(distinct o.order_id) as total_orders,
    avg(r.review_score) as avg_review_score,
    avg(i.price) as avg_product_price
from order_items i
inner join orders o
    on o.order_id = i.order_id
left join reviews r
    on r.order_id = o.order_id
where o.order_status = 'delivered'
group by i.seller_id;


-- Are a small number of sellers responsible for the majority of the revenue?

create view vw_seller_revenue_pareto as

with seller_revenue as
(
    select
        s.seller_id,
        sum(i.price) as total_revenue
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
        sum(total_revenue) over(order by total_revenue desc) as cumulative_revenue
    from seller_revenue
)

select
    seller_id,
    total_revenue,
    cumulative_revenue,
    round(
        cumulative_revenue * 100.0 /
        sum(total_revenue) over(),
        2
    ) as cumulative_percentage
from cumulative_revenue;


-- Orders per Seller

create view vw_top_sellers_by_orders as

select
    s.seller_id,
    count(distinct o.order_id) as total_orders
from sellers s
inner join order_items i
    on s.seller_id = i.seller_id
inner join orders o
    on o.order_id = i.order_id
where o.order_status = 'delivered'
group by s.seller_id;


--Top 10 Sellers by Fastest Delivery

create view vw_fastest_delivery_sellers as

select
    i.seller_id,
    avg(datediff(day,o.order_purchase_timestamp,o.order_delivered_customer_date)) as avg_delivery_days,
    cast(round(100.0 /avg(datediff(day,o.order_purchase_timestamp,o.order_delivered_customer_date)),2) as decimal(10,2)) as delivery_speed_score,
    count(distinct o.order_id) as total_orders
from order_items i
inner join orders o
on o.order_id = i.order_id
where
o.order_status = 'delivered'
and o.order_delivered_customer_date is not null
group by
i.seller_id
having count(distinct o.order_id) >= 10;
