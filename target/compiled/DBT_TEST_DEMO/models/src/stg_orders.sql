with source as (
 SELECT * FROM snowflake_sample_data.tpch_sf1.orders

),

renamed as (

    select
       *

    from source

)

select * from renamed