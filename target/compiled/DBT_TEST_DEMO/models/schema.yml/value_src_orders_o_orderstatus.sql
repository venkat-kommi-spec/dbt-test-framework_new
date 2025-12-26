
    
    

with all_values as (

    select
        o_orderstatus as value_field,
        count(*) as n_records

    from DBT_TEST_DEMO.src.src_orders
    group by o_orderstatus

)

select *
from all_values
where value_field   in (
    'placed','shipped','completed','returned'
)


