{% snapshot src_snapshot_part_new_type2 %}

{{
    config(
      target_schema='curated',
      database ='DBT_TEST_DEMO',
      unique_key='P_PARTKEY',
      strategy='check',
      check_cols=['P_NAME','P_MFGR','P_BRAND','P_TYPE','P_SIZE','P_CONTAINER','P_RETAILPRICE','P_COMMENT'],
      dbt_valid_to_current="DATE('9999-12-31')",
      hard_deletes='invalidate'
    )
}}

SELECT 
    P_PARTKEY,
    P_NAME,
    P_MFGR,
    P_BRAND,
    P_TYPE,
    P_SIZE,
    P_CONTAINER,
    P_RETAILPRICE,
    P_COMMENT
FROM {{ ref('src_part_new') }}

{% endsnapshot %}
