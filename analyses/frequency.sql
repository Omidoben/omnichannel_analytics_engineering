-- Frequency - total distinct order purchase occassions

/*
select
    sk_customer,
    count(distinct sk_order_date) as num_orders
from {{ ref("fct_purchase_history") }}
group by sk_customer
order by 2 desc
*/

/*
-- Recency - days since last purchase
select
    sk_customer,
    date_diff(current_date(), max(sk_order_date), day) as days_since_last_purchase
from {{ ref("fct_purchase_history") }}
group by sk_customer
order by 2 asc
*/


-- customer tenure - how long they have been a customer
select
    sk_customer,
    min(sk_order_date) as first_order_date,
    max(sk_order_date) as last_order_date,
    date_diff(max(sk_order_date), min(sk_order_date), day) as customer_tenure
from {{ ref("fct_purchase_history") }}
group by sk_customer
order by 4 desc