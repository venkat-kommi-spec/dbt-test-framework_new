
  create or replace   view dbt_test_demo.src.stg_orders
  
    
    
(
  
    "O_ORDERKEY" COMMENT $$$$, 
  
    "O_CUSTKEY" COMMENT $$$$, 
  
    "O_ORDERSTATUS" COMMENT $$$$, 
  
    "O_TOTALPRICE" COMMENT $$$$, 
  
    "O_ORDERDATE" COMMENT $$$$, 
  
    "O_ORDERPRIORITY" COMMENT $$$$, 
  
    "O_CLERK" COMMENT $$$$, 
  
    "O_SHIPPRIORITY" COMMENT $$$$, 
  
    "O_COMMENT" COMMENT $$$$
  
)

  
  
  
  as (
    with source as (
 SELECT * FROM snowflake_sample_data.tpch_sf1.orders

),

renamed as (

    select
       *

    from source

)

select * from renamed
  );

