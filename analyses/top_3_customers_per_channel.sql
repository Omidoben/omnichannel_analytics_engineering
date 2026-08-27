-- select * from {{ ref("dim_channels") }}
-- sk_channel - pk
-- dsc_channel_name

-- select * from {{ ref("dim_customers") }}
-- sk_customer - pk
-- dsc_name - customer name

-- select * from {{ ref("fct_purchase_history")}}

with customer_channel_purchases as (
    select
        dcu.dsc_name,
        dcu.dsc_email_address,
        dc.dsc_channel_name,
        round(sum(fct.mtr_total_amount_net), 2) as sum_total_amount
    from {{ ref("fct_purchase_history") }} fct
    left join {{ ref("dim_customers") }} dcu on fct.sk_customer = dcu.sk_customer
    left join {{ ref("dim_channels") }} dc on fct.sk_channel = dc.sk_channel
    group by dc.dsc_channel_name, dcu.dsc_name, dcu.dsc_email_address
),
customer_ranking as (
    select
        *,
        rank() over(partition by dsc_channel_name order by sum_total_amount desc) as rank_spend
    from customer_channel_purchases
)
select * 
from customer_ranking
where rank_spend <= 3
order by dsc_channel_name, rank_spend