-- select * from {{ ref("dim_channels") }}
-- sk_channel
-- dsc_channel_name
-- select * from {{ ref("dim_products") }}
-- sk_product
-- dsc_product_name
-- select * from {{ ref("fct_purchase_history") }}
-- sk_channel
-- sk_product
-- mtr_total_amount_net
with
    total_amount_product_channel as (
        select
            ch.dsc_channel_name,
            pr.dsc_product_name,
            round(sum(fct.mtr_total_amount_net), 2) as total_amount
        from {{ ref("fct_purchase_history") }} fct
        left join {{ ref("dim_channels") }} ch on fct.sk_channel = ch.sk_channel
        left join {{ ref("dim_products") }} pr on fct.sk_product = pr.sk_product
        group by ch.dsc_channel_name, pr.dsc_product_name
        order by total_amount desc
    ),
    product_ranking as (
        select
            *,
            rank() over (
                partition by dsc_channel_name order by total_amount desc
            ) as prod_rank
        from total_amount_product_channel
    )
select *
from product_ranking
where prod_rank <= 3
order by dsc_channel_name, prod_rank
