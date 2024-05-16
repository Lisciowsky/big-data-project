import os

DATA_BUCKET_NAME = os.getenv("DATA_BUCKET_NAME")
RDS_ENDPOINT = os.getenv("RDS_ENDPOINT")
RDS_PORT = os.getenv("RDS_PORT")
RDS_DATABASE_NAME = os.getenv("RDS_DATABASE_NAME")
RDS_TABLE_NAME = os.getenv("RDS_TABLE_NAME")
RDS_USER = os.getenv("RDS_USER")
RDS_PASSWORD = os.getenv("RDS_PASSWORD")

RDS_DRIVER = "org.postgresql.Driver"

