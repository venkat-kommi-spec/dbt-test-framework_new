

with source_data as (
    select
        emp_id,
        emp_name,
        dept,
        updated_at
    from dbt_test_demo.src.src_employee
),

current_dim as (
    select *
    from dbt_test_demo.src.dim_employee
    where is_current = true
),

to_insert as (
    select
        s.emp_id,
        s.emp_name,
        s.dept,
        s.updated_at
    from source_data s
    left join current_dim d
       on s.emp_id = d.emp_id
    where
       d.emp_id is null
       or s.emp_name <> d.emp_name
       or s.dept <> d.dept
)

select
    md5(cast(coalesce(cast(emp_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(updated_at as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as emp_sk,
    emp_id,
    emp_name,
    dept,
    updated_at as effective_from,
    '9999-12-31'::date as effective_to,
    true as is_current
from to_insert





