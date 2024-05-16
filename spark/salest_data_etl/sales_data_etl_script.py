import sys
from typing import Tuple
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from datetime import datetime

import settings

def _get_year_and_month() -> Tuple[str,str]:
    return datetime.now().strftime('%Y'), datetime.now().strftime('%m')

## @params: [JOB_NAME]
args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

year, month = _get_year_and_month() 
s3_input_path = f"s3://{settings.DATA_BUCKET_NAME}/sales_data/{year}/{month}/"

df = spark.read.format("parquet").load(s3_input_path)
df_transformed = df.withColumnRenamed("sale_id", "id")

rds_url = f"jdbc:postgresql://{settings.RDS_ENDPOINT}:{settings.RDS_PORT}/{settings.RDS_DATABASE_NAME}"

rds_properties = {
    "user": settings.RDS_USER,
    "password": settings.RDS_PASSWORD,
    "driver": settings.RDS_DRIVER
}

df_transformed.write.jdbc(url=rds_url, table=settings.RDS_TABLE_NAME, mode="append", properties=rds_properties)

job.commit()
