
  create or replace   view dbt_test_demo.src.src_part_new
  
    
    
(
  
    "P_PARTKEY" COMMENT $$$$, 
  
    "P_NAME" COMMENT $$$$, 
  
    "P_MFGR" COMMENT $$$$, 
  
    "P_BRAND" COMMENT $$$$, 
  
    "P_TYPE" COMMENT $$$$, 
  
    "P_SIZE" COMMENT $$$$, 
  
    "P_CONTAINER" COMMENT $$$$, 
  
    "P_RETAILPRICE" COMMENT $$$$, 
  
    "P_COMMENT" COMMENT $$$$
  
)

  
  
  
  as (
    WITH part AS (
   SELECT *
    FROM  DBT_TEST_DEMO.SRC.TPCH_SF1_PART
)


select * from  part
  );

