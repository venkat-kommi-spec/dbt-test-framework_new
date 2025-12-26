SELECT 
    *,
    -- Create a flag for easy reporting
    CASE 
        WHEN dbt_valid_to = DATE('9999-12-31') THEN 'Y' 
        ELSE 'N' 
    END AS IS_CURRENT
FROM {{ ref('src_snapshot_part_new_type2') }}

