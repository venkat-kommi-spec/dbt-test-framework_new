{{ config(
    materialized='incremental',
    unique_key='P_PARTKEY',
    incremental_strategy='merge',
   
    merge_update_columns=['IS_CURRENT','EFFECTIVE_TO','P_NAME','P_MFGR','P_BRAND','P_TYPE','P_SIZE','P_CONTAINER','P_RETAILPRICE','P_COMMENT']
) }}
 -- 1Type1 columns to update in variable 
-- 1️⃣ Source table
WITH source_data AS (
    SELECT *
    FROM {{ ref('src_part_new') }}
),

-- 2️⃣ Current target rows
current_dim AS (
    {% if is_incremental() %}
        SELECT *
        FROM {{ this }}
        WHERE IS_CURRENT = 'Y'
    {% else %}
        SELECT
            CAST(NULL AS INT) AS P_PARTKEY,
            CAST(NULL AS STRING) AS P_NAME,
            CAST(NULL AS STRING) AS P_MFGR,
            CAST(NULL AS STRING) AS P_BRAND,
            CAST(NULL AS STRING) AS P_TYPE,
            CAST(NULL AS INT) AS P_SIZE,
            CAST(NULL AS STRING) AS P_CONTAINER,
            CAST(NULL AS NUMBER) AS P_RETAILPRICE,
            CAST(NULL AS STRING) AS P_COMMENT,
            CAST(NULL AS DATE) AS EFFECTIVE_FROM,
            CAST(NULL AS DATE) AS EFFECTIVE_TO,
            CAST(NULL AS STRING) AS IS_CURRENT
        WHERE 1 = 0
    {% endif %}
),

-- 3️⃣ Identify changed or new rows based on non-business keys only
delta AS (
    SELECT s.*
    FROM source_data s
    LEFT JOIN current_dim d
        ON s.P_PARTKEY = d.P_PARTKEY
    WHERE d.P_PARTKEY IS NULL
       OR s.P_NAME    <> d.P_NAME
       OR s.P_COMMENT <> d.P_COMMENT
),

-- 4️⃣ Expire old rows (those that are changing)
expired AS (
    SELECT d.P_PARTKEY,
           CURRENT_DATE AS EFFECTIVE_TO
    FROM current_dim d
    INNER JOIN delta s
        ON d.P_PARTKEY = s.P_PARTKEY
),

-- 5️⃣ Stage delta rows for SCD2
staged AS (
    SELECT
        P_PARTKEY,
        P_NAME,
        P_MFGR,
        P_BRAND,
        P_TYPE,
        P_SIZE,
        P_CONTAINER,
        P_RETAILPRICE,
        P_COMMENT,
        CURRENT_DATE AS EFFECTIVE_FROM,
        DATE('9999-12-31') AS EFFECTIVE_TO,
        'Y' AS IS_CURRENT
    FROM delta
)

SELECT * FROM staged
