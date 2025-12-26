
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from dbt_test_demo.dbt_test__audit.dbt_expect_src_orders_columns
    
      
    ) dbt_internal_test