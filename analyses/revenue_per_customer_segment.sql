-- select * from {{ ref("dim_customers") }}
-- sk_customer
-- dsc_customer_segment

select
    dc.dsc_customer_segment,
    count(distinct dc.sk_customer) as customer_count,
    round(sum(fct.mtr_total_amount_net), 2) as segment_revenue,
    round(
        sum(fct.mtr_total_amount_net) / sum(sum(fct.mtr_total_amount_net)) over () * 100, 2
    ) as pct_of_total_revenue

from {{ ref('dim_customers') }} dc
left join {{ ref('fct_purchase_history') }} fct on fct.sk_customer = dc.sk_customer

group by dc.dsc_customer_segment
order by segment_revenue desc
