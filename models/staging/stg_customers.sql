with
    raw_customers as (

        select
            customer_id,
            name,
            date_birth,
            email_address,
            phone_number,
            country,
            created_at,
            updated_at

        from {{ source("omnichannel", "customers") }}

    )

select *
from raw_customers
