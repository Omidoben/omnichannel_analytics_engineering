--select * from {{ ref("dim_date") }}

-- year_number
-- quarter_of_year
-- date_day

select 
    dd.year_number,
    dd.quarter_of_year,
    round(sum(fct.mtr_total_amount_net), 2) as total_amount_sold
from {{ ref("fct_purchase_history") }} fct
left join {{ ref("dim_date") }} dd on fct.sk_order_date = dd.date_day
group by dd.year_number, dd.quarter_of_year
order by dd.year_number, dd.quarter_of_year

