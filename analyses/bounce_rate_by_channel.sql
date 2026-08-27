-- KPI: Bounce Rate by Channel

-- select * from {{ ref("fct_visit_history") }}
-- flg_is_bounce is true when bounce_timestamp is null (no engagement was recorded)

select
    dc.dsc_channel_name,
    count(*) as num_visits,
    countif(fct.flg_is_bounce) as bounced_visits,
    round(countif(fct.flg_is_bounce) / count(*) * 100, 2) as bounce_rate_pct
from {{ ref("fct_visit_history") }} fct
left join {{ ref("dim_channels") }} dc on fct.sk_channel = dc.sk_channel
group by dc.dsc_channel_name
order by bounce_rate_pct desc
