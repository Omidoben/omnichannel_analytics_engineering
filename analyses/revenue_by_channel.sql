-- KPI: Revenue by Channel

-- select * from {{ ref("dim_channels") }}
-- select * from {{ ref("fct_purchase_history") }}
-- select * from {{ ref("dim_date") }} --- quarter_of_year, year_number
/*
select min(sk_order_date)
from {{ ref("fct_purchase_history") }}
*/

select
    dc.dsc_channel_name,
    dd.year_number,
    dd.quarter_of_year,
    round(sum(fct.mtr_total_amount_net), 2) as revenue_net
from {{ ref("fct_purchase_history") }} fct
left join {{ ref("dim_channels") }} dc on fct.sk_channel = dc.sk_channel
left join {{ ref("dim_date") }} dd on fct.sk_order_date = dd.date_day
group by 1, 2, 3
order by 2, 3, 4 desc