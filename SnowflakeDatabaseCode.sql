create database dbt_test_demo;
 use DBT_TEST_DEMO;
create schema dbt_test_report;
create schema src;
create schema curated;
CREATE OR REPLACE SCHEMA DBT_TEST_DEMO.ERROR_CAPTURE;

create schema scd2;
 


Create table if not exists dbt_test_demo.dbt_test_report.log_model_errors( 
                   errortable varchar(100),
                   loaddate timestamp,
                   object variant);



                   CREATE OR REPLACE PROCEDURE dbt_test_demo.dbt_test_report.load_dbt_model_errors()
    RETURNS STRING
    LANGUAGE PYTHON
    RUNTIME_VERSION = 3.10
    PACKAGES = ('snowflake-snowpark-python','pandas')
    HANDLER = 'main'
AS
$$
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import udf
from snowflake.snowpark.functions import col
from snowflake.snowpark.types import StringType, IntegerType

def main(session): 
    tableName = 'dbt_test_demo.information_schema.tables'
    df_tables = session.table(tableName).filter((col("table_schema") == 'DBT_TEST__AUDIT') & (col("row_count") > 0)).select("table_name")
    err_tbl_list = df_tables.toPandas().values.tolist()
    
    create_stmt = 'Create table if not exists dbt_test_demo.dbt_test_report.log_model_errors( \
                   errortable varchar(100),\
                   loaddate timestamp,\
                   object variant);'
    
    session.sql(create_stmt).collect()
    
    for tbl in err_tbl_list:
        query_stmt = 'Insert into dbt_test_demo.dbt_test_report.log_model_errors \
                    Select \'' + tbl[0] + \
                    '\' as errortable, \
                    current_timestamp as loaddate, \
                    array_agg(object_construct(*)) AS object \
                    From dbt_test_demo.dbt_test__audit.' + \
                    tbl[0]
        print(query_stmt)
        session.sql(query_stmt).collect()
    return 'Success : Error Table Loaded'
    #return str(err_tbl_list)
$$;
 

CREATE TABLE DBT_TEST_DEMO.SCD2.DIM_PART (
    PART_SK        INT AUTOINCREMENT PRIMARY KEY,
    P_PARTKEY      INT NOT NULL,
    P_NAME         VARCHAR(55),
    P_MFGR         VARCHAR(25),
    P_BRAND        VARCHAR(10),
    P_TYPE         VARCHAR(25),
    P_SIZE         INT,
    P_CONTAINER    VARCHAR(10),
    P_RETAILPRICE  DECIMAL(15,2),
    P_COMMENT      VARCHAR(23),
    EFFECTIVE_FROM DATE DEFAULT CURRENT_DATE,
    EFFECTIVE_TO   DATE,
    IS_CURRENT     CHAR(1) DEFAULT 'Y' -- 'Y' or 'N'
);


CREATE TABLE DBT_TEST_DEMO.SRC.TPCH_SF1_PART AS
SELECT *
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.PART
LIMIT 10;