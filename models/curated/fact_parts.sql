{{ config(
    materialized='incremental',
    unique_key='p_partkey',                           
    incremental_strategy='append'                    
) }}

WITH orders AS (
    SELECT *
    FROM {{ ref('src_part_new') }}
),

final AS (
    SELECT
       *
    FROM orders o
    {% if is_incremental() %}
        -- Incremental filter: Only new/changed data
        WHERE o.p_partkey > (
            SELECT COALESCE(MAX(p_partkey), '0') 
            FROM {{ this }}
        )
    {% endif %}
)

SELECT *
FROM final
