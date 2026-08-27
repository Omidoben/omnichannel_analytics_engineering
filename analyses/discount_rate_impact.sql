-- KPI: Discount rate impact

select
    dc.dsc_channel_name,
    round(sum(fct.mtr_total_amount_gross), 2) as total_gross,
    round(sum(fct.mtr_total_amount_net), 2) as total_net,
    round(sum(fct.mtr_total_amount_gross) - sum(fct.mtr_total_amount_net), 2) as discount_value,
    round(
        (sum(fct.mtr_total_amount_gross) - sum(fct.mtr_total_amount_net))
        / sum(fct.mtr_total_amount_gross) * 100, 2
    ) as discount_rate_pct

from {{ ref('fct_purchase_history') }} fct
left join {{ ref('dim_channels') }} dc on dc.sk_channel = fct.sk_channel

group by dc.dsc_channel_name
order by discount_rate_pct desc