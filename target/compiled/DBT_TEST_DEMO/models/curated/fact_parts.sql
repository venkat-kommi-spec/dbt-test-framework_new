

WITH orders AS (
    SELECT *
    FROM dbt_test_demo.src.src_part_new
),

final AS (
    SELECT
       *
    FROM orders o
    
        -- Incremental filter: Only new/changed data
        WHERE o.p_partkey > (
            SELECT COALESCE(MAX(p_partkey), '0') 
            FROM dbt_test_demo.curated.fact_parts
        )
    
)

SELECT *
FROM final