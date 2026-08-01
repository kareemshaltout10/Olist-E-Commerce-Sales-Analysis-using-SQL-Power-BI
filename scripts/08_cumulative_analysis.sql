-- How much of the total revenue is accumulated by states?

with state_revenue as
(
select 
c.customer_state as state,
sum(i.price) as total_revenue
from customers c
inner join orders o
on o.customer_id = c.customer_id
inner join order_items i
on o.order_id = i.order_id
where o.order_status = 'delivered'
group by c.customer_state
),

cumulativerevenue as
(
select 
*,
sum(total_revenue) over(order by total_revenue desc) as cumulative_revenue
from state_revenue
)

select
*,
cast(round((cumulative_revenue * 100.0 / sum(total_revenue) over()),2) as decimal(10,2) ) as cumulative_percentage
from cumulativerevenue



-- Key Insights

-- São Paulo (SP) is the largest revenue-generating state, contributing approximately **38.33%** of the total revenue.
-- The top **2 states (SP and RJ)** account for over **51.64%** of total revenue.
-- The top **6 states** contribute around **77.77%** of the company's total revenue.
-- The top **7 states** generate approximately **81.50%** of the total revenue, indicating that revenue is highly concentrated in a small number of states.
-- This concentration suggests that marketing campaigns, logistics improvements, and inventory planning should prioritize these high-performing states.