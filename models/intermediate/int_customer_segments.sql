-- select * from {{ ref("stg_purchase_history")}}
with
    purchase_amounts as (
        select
            p.customer_id,
            p.product_sku,
            p.quantity,
            p.discount,
            round(p.quantity * pr.unit_price * (1 - p.discount), 2) as amount_net
        from {{ ref("stg_purchase_history") }} p
        left join {{ ref("stg_products") }} pr on p.product_sku = pr.product_sku
    ),

    customer_purchase_counts as (
        select
            customer_id,
            count(*) as total_orders,
            round(sum(amount_net), 2) as total_spend
        from purchase_amounts
        group by 1
    )

select
    customer_id,
    total_orders,
    total_spend,
    case
        when total_orders >= 15
        then 'VIP'
        when total_orders >= 5
        then 'Regular'
        when total_orders >= 2
        then 'Occasional'
        else 'One-time'
    end as customer_segment
from customer_purchase_counts
