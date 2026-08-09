with
    stg_dim_customers as (

        select
            customer_id as nk_customer_id,
            name as dsc_name,
            date_birth as dt_date_birth,
            email_address as dsc_email_address,
            phone_number as dsc_phone_number,
            country as dsc_country,
            created_at as dt_created_at,
            updated_at as dt_updated_at

        from {{ ref("stg_customers") }}

    ),

    segments as (

        select 
            customer_id, 
            customer_segment 
        from {{ ref("int_customer_segments") }}

    )

select
    {{ dbt_utils.generate_surrogate_key(["stg_dim_customers.nk_customer_id"]) }}
    as sk_customer,
    stg_dim_customers.*,
    coalesce(segments.customer_segment, 'No Purchases') as dsc_customer_segment

from stg_dim_customers
left join segments on stg_dim_customers.nk_customer_id = segments.customer_id
