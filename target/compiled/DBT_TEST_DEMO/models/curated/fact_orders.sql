

WITH orders AS (
    SELECT *
    FROM dbt_test_demo.src.stg_orders
),

final AS (
    SELECT
       *
    FROM orders o
    
        -- Incremental filter: Only new/changed data
        WHERE o.o_orderdate > (
            SELECT COALESCE(MAX(o_orderdate), '1900-01-01') 
            FROM dbt_test_demo.curated.fact_orders
        )
    
)

SELECT *
FROM final