-- select * from {{ ref("dim_channels") }}
-- sk_channel
-- dsc_channel_name
-- select * 
-- from {{ ref("fct_visit_history") }}
-- where mtr_length_of_stay_minutes is not null
-- sk_channel
-- sk_date_visit
-- sk_date_bounce
select ch.dsc_channel_name, 
        round(avg(timestamp_diff(fct.dt_bounce_timestamp, fct.dt_visit_timestamp, minute)), 2) as avg_length,
        round(avg(mtr_length_of_stay_minutes), 2) as avg_length_of_stay_minutes
from {{ ref("fct_visit_history") }} fct
left join {{ ref("dim_channels") }} ch on fct.sk_channel = ch.sk_channel
group by dsc_channel_name
order by 2 desc
