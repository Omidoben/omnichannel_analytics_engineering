-- KPI: Average Order Value (AOV) by Channel

-- select * from {{ ref("fct_purchase_history") }}
-- select * from {{ ref("dim_channels") }}

select
    ch.dsc_channel_name,
    count(*) as total_orders,
    sum(mtr_total_amount_net) / count(*) as avg_order_value
from {{ ref("fct_purchase_history") }} fct
left join {{ ref("dim_channels") }} ch on fct.sk_channel = ch.sk_channel
group by ch.dsc_channel_name
order by 3 desc
