

WITH source_data AS (
    SELECT *
    FROM dbt_test_demo.src.src_part_new
),

current_dim AS (
    SELECT *
    FROM dbt_test_demo.src.dim_part_new
    WHERE IS_CURRENT = 'Y'
),

delta AS (
    SELECT s.*
    FROM source_data s
    LEFT JOIN current_dim d
      ON s.P_PARTKEY = d.P_PARTKEY
    WHERE d.P_PARTKEY IS NULL
       OR s.P_NAME <> d.P_NAME
       OR s.P_MFGR <> d.P_MFGR
       OR s.P_BRAND <> d.P_BRAND
       OR s.P_TYPE <> d.P_TYPE
       OR s.P_SIZE <> d.P_SIZE
       OR s.P_CONTAINER <> d.P_CONTAINER
       OR s.P_RETAILPRICE <> d.P_RETAILPRICE
       OR s.P_COMMENT <> d.P_COMMENT
)

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