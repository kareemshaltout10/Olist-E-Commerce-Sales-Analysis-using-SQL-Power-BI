-- How many customers does the company have?

select 
count(distinct customer_unique_id) as total_customers
from customers

-- Which states have the highest number of customers?

select top 10
customer_state as state ,
count(distinct customer_unique_id) as total_customers
from customers
group by customer_state
order by count(distinct customer_unique_id) desc

-- Which cities have the highest number of customers?

select top 10
customer_city as city,
count(distinct customer_unique_id) as total_customers
from customers
group by customer_city
order by count(distinct customer_id)desc


