with order_gaps as (
    select
        sk_customer,
        sk_order_date,
        date_diff(
            sk_order_date,
            lag(sk_order_date) over (partition by sk_customer order by sk_order_date),
            day
        ) as days_since_previous_order
    from {{ ref('fct_purchase_history') }}
)

select
    sk_customer,
    avg(days_since_previous_order) as avg_days_between_orders
from order_gaps
where days_since_previous_order is not null
group by sk_customer