-- Retrieve a list of unique cities to which the customers belong
select distinct
customer_city
from customers
order by customer_city

-- Retrieve a list of unique states to which the customers belong

select distinct
customer_state
from customers
order by customer_state

-- Retrieve a list of unique cities to which the sellers belong

select distinct
seller_city
from sellers
order by seller_city

-- Retrieve a list of unique states to which the sellers belong

select distinct
seller_state
from sellers
order by seller_state

-- Retrieve a list of unique categories

select distinct
t.product_category_name_english
from products p
inner join category_translation t
on t.product_category_name = p.product_category_name
order by t.product_category_name_english

-- Which payment methods are available?

select distinct
payment_type
from payments

-- How many review scores are available?

select distinct
count(review_comment_message) as comment
from reviews


