-- back compat for old kwarg name
  
  begin;
    
        
            
	    
	    
            
        
    

    

    merge into dbt_test_demo.curated.dim_part_new as DBT_INTERNAL_DEST
        using dbt_test_demo.curated.dim_part_new__dbt_tmp as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.P_PARTKEY = DBT_INTERNAL_DEST.P_PARTKEY))

    
    when matched then update set
        IS_CURRENT = DBT_INTERNAL_SOURCE.IS_CURRENT,EFFECTIVE_TO = DBT_INTERNAL_SOURCE.EFFECTIVE_TO,P_NAME = DBT_INTERNAL_SOURCE.P_NAME,P_MFGR = DBT_INTERNAL_SOURCE.P_MFGR,P_BRAND = DBT_INTERNAL_SOURCE.P_BRAND,P_TYPE = DBT_INTERNAL_SOURCE.P_TYPE,P_SIZE = DBT_INTERNAL_SOURCE.P_SIZE,P_CONTAINER = DBT_INTERNAL_SOURCE.P_CONTAINER,P_RETAILPRICE = DBT_INTERNAL_SOURCE.P_RETAILPRICE,P_COMMENT = DBT_INTERNAL_SOURCE.P_COMMENT
    

    when not matched then insert
        ("P_PARTKEY", "P_NAME", "P_MFGR", "P_BRAND", "P_TYPE", "P_SIZE", "P_CONTAINER", "P_RETAILPRICE", "P_COMMENT", "EFFECTIVE_FROM", "EFFECTIVE_TO", "IS_CURRENT")
    values
        ("P_PARTKEY", "P_NAME", "P_MFGR", "P_BRAND", "P_TYPE", "P_SIZE", "P_CONTAINER", "P_RETAILPRICE", "P_COMMENT", "EFFECTIVE_FROM", "EFFECTIVE_TO", "IS_CURRENT")

;
    commit;