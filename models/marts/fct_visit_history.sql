with
    stg_fct_visit_history as (

        select
            customer_id as nk_customer_id,
            channel_id as nk_channel_id,
            cast(visit_timestamp as date) as sk_date_visit,
            cast(bounce_timestamp as date) as sk_date_bounce,
            cast(visit_timestamp as timestamp) as dt_visit_timestamp,
            cast(bounce_timestamp as timestamp) as dt_bounce_timestamp,
            -- bounce_timestamp is NULL when a visit bounced (single-touch, no
            -- further engagement to timestamp). It is populated only when the
            -- visit was engaged, recording when that engagement ended.
            case when bounce_timestamp is null then true else false end as flg_is_bounce

        from {{ ref("stg_visit_history") }}

    )

select
    coalesce(dcust.sk_customer, '-1') as sk_customer,
    coalesce(dchan.sk_channel, '-1') as sk_channel,
    fct.sk_date_visit,
    fct.sk_date_bounce,
    fct.dt_visit_timestamp,
    fct.dt_bounce_timestamp,
    fct.flg_is_bounce,
    -- Only meaningful for engaged (non-bounced) visits; null for bounces,
    -- since there is no engagement duration to measure.
    timestamp_diff(
        fct.dt_bounce_timestamp, fct.dt_visit_timestamp, minute
    ) as mtr_length_of_stay_minutes

from stg_fct_visit_history as fct
left join
    {{ ref("dim_customers") }} as dcust on fct.nk_customer_id = dcust.nk_customer_id
left join {{ ref("dim_channels") }} as dchan on fct.nk_channel_id = dchan.nk_channel_id
