-- select * from {{ ref("stg_visit_history") }}
with
    visits as (
        select
            customer_id,
            channel_id,
            visit_timestamp,
            bounce_timestamp,
            cast(visit_timestamp as date) as visit_date
        from {{ ref("stg_visit_history") }}
    ),
    purchases as (
        select distinct
            customer_id, 
            channel_id, 
            cast(orderdate as date) as purchase_date
        from {{ ref("stg_purchase_history") }}
    )
select
    v.customer_id,
    v.channel_id,
    v.visit_timestamp,
    v.bounce_timestamp,
    -- Best-effort proxy: same customer, same channel, same calendar day.
    -- No shared transaction key exists between visits and purchases, and purchase timestamps are only DATE-grain,
    -- so same-day is the finest window available.
    case when p.purchase_date is not null then true else false end as flg_converted

from visits v
left join
    purchases p
    on v.customer_id = p.customer_id
    and v.channel_id = p.channel_id
    and v.visit_date = p.purchase_date
