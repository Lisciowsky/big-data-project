import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql.utils import AnalysisException

import settings

def get_existing_table_schema(url: str, table: str, properties: dict):
    try:
        return spark.read.jdbc(url=url, table=table, properties=properties).schema
    except AnalysisException:
        return None

def update_table_schema(new_schema, existing_schema, table: str):
    new_columns = set(new_schema.names) - set(existing_schema.names)
    altered_columns = {field.name: field.dataType for field in new_schema.fields if field.name in existing_schema.names and field.dataType != existing_schema[field.name].dataType}

    # Alter table to add new columns
    for column in new_columns:
        dtype = new_schema[column].dataType.simpleString()
        spark.sql(f"ALTER TABLE {table} ADD COLUMN {column} {dtype}")

    # Alter table to modify column types
    for column, dtype in altered_columns.items():
        dtype_str = dtype.simpleString()
        spark.sql(f"ALTER TABLE {table} ALTER COLUMN {column} TYPE {dtype_str}")

## @params: [JOB_NAME, DATABASE_NAME, TABLE_NAME]
args = getResolvedOptions(sys.argv, ['JOB_NAME', 'DATABASE_NAME', 'TABLE_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Read from Glue Data Catalog
datasource = glueContext.create_dynamic_frame.from_catalog(
    database=args['DATABASE_NAME'],
    table_name=args['TABLE_NAME']
)

# Convert DynamicFrame to DataFrame
df = datasource.toDF()

# Transform DataFrame
df_transformed = df.withColumnRenamed("sale_id", "id")

rds_url = f"jdbc:postgresql://{settings.RDS_ENDPOINT}:{settings.RDS_PORT}/{settings.RDS_DATABASE_NAME}"
rds_properties = {
    "user": settings.RDS_USER,
    "password": settings.RDS_PASSWORD,
    "driver": settings.RDS_DRIVER
}

# Get existing table schema
existing_schema = get_existing_table_schema(rds_url, settings.RDS_TABLE_NAME, rds_properties)

# If the table exists, update schema if necessary
if existing_schema:
    update_table_schema(df_transformed.schema, existing_schema, settings.RDS_TABLE_NAME)

# Write data to RDS
df_transformed.write.jdbc(url=rds_url, table=settings.RDS_TABLE_NAME, mode="append", properties=rds_properties)

job.commit()
