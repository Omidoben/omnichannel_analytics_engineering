with raw_channels as(
    select 
        channel_id,
        channel_name,
        created_at,
        updated_at
    from {{ source("omnichannel", "channels")}}
)

select * from raw_channels