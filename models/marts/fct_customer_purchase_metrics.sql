select
    co.sk_customer,
    co.first_order_date,
    co.last_order_date,
    date_diff(cast('2024-12-31' as date), co.last_order_date, day) as recency_days,
    date_diff(co.last_order_date, co.first_order_date, day) as tenure_days,
    co.order_frequency,
    co.avg_order_value,
    co.customer_lifetime_value,
    og.avg_days_between_orders,
    case
        when date_diff(cast('2024-12-31' as date), co.last_order_date, day) > 180 then true
        else false
    end as is_at_risk_of_churn
from {{ ref('int_customer_order_aggregates') }} as co
left join {{ ref('int_customer_order_gaps') }} as og
    on co.sk_customer = og.sk_customer