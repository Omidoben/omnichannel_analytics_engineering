select
    dc.dsc_channel_name,
    count(*) as total_visits,
    countif(fct.flg_converted) as converted_visits,
    round(countif(fct.flg_converted) / count(*) * 100, 2) as conversion_rate_pct

from {{ ref('fct_visit_history') }} fct
left join {{ ref('dim_channels') }} dc on dc.sk_channel = fct.sk_channel

group by dc.dsc_channel_name
order by conversion_rate_pct desc