-- KPI: Customer Repeat Purchase Rate
-- Share of customers with 2+ distinct order dates in the trailing 12 months
-- from the most recent order date present in the data.
-- select * from {{ ref("fct_purchase_history") }}

with
    max_date as (
        select 
            max(sk_order_date) as last_order_date
        from {{ ref("fct_purchase_history") }}
    ),
    customer_orders as(
        select 
            fct.sk_customer,
           count(distinct fct.sk_order_date) as distinct_order_days
        from {{ ref("fct_purchase_history") }} fct
        cross join max_date
        where date_diff(max_date.last_order_date, fct.sk_order_date, day) <= 365
        group by fct.sk_customer
    )
select 
    count(*) as customers_active_last_12mo,
    countif(distinct_order_days >= 2) as repeat_customers,
    round(countif(distinct_order_days >= 2) / count(*) * 100, 2) as repeat_purchase_rate_pct
from customer_orders