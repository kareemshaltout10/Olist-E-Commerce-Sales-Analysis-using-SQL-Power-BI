create view vw_ExecutiveKPIs as

select
    cast(datetrunc(month, o.order_purchase_timestamp) as date) as date_month,
    sum(i.price) as total_revenue,
    avg(i.price) as avg_price,
    count(distinct o.order_id) as total_orders,
    count(distinct c.customer_unique_id) as total_customers,
    count(distinct i.product_id) as total_products,
    count(distinct s.seller_id) as total_sellers,
    sum(i.freight_value) as total_freight,
    sum(i.price) * 1.0 / count(distinct o.order_id) as average_order_value,
    avg(r.review_score) as average_review_score
from orders o
inner join customers c
    on c.customer_id = o.customer_id
inner join order_items i
    on i.order_id = o.order_id
inner join sellers s
    on s.seller_id = i.seller_id
left join reviews r
    on r.order_id = o.order_id
where o.order_status = 'delivered'
group by
    datetrunc(month, o.order_purchase_timestamp);