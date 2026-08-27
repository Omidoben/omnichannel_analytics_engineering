select
    sk_customer,
    min(sk_order_date) as first_order_date,
    max(sk_order_date) as last_order_date,
    count(distinct sk_order_date) as order_frequency,
    avg(mtr_total_amount_net) as avg_order_value,
    sum(mtr_total_amount_net) as customer_lifetime_value
from {{ ref('fct_purchase_history') }}
group by sk_customer