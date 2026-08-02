with raw_purchase_history as (

    select
        customer_id,
        product_sku,
        channel_id,
        quantity,
        discount,
        orderdate,
        created_at,
        updated_at

    from {{ source('omnichannel', 'purchasehistory') }}

)

select * from raw_purchase_history
