create view vw_payment_type as

select
    p.payment_type,
    sum(i.price) as total_revenue,
    count(distinct o.order_id) as total_orders,
    avg(i.price) as average_order_value,
    avg(p.payment_installments) as average_installments
from payments p
inner join orders o
    on o.order_id = p.order_id
inner join order_items i
    on i.order_id = o.order_id
where o.order_status = 'delivered'
group by p.payment_type;