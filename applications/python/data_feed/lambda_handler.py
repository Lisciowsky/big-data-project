import boto3
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq
from datetime import datetime, timedelta
import random
import uuid
import os

import settings


s3 = boto3.client('s3')

product_names = ['Widget A', 'Widget B', 'Widget C', 'Gadget A', 'Gadget B']
categories = ['Widgets', 'Gadgets']
regions = ['North America', 'Europe', 'Asia', 'South America']

def generate_data(num_records):
    data = []
    base_date = datetime.now() - timedelta(days=365)
    
    for i in range(num_records):
        sale_id = i + 1
        product_id = random.randint(100, 105)
        product_name = random.choice(product_names)
        category = 'Widgets' if 'Widget' in product_name else 'Gadgets'
        quantity = random.randint(1, 10)
        price = round(random.uniform(10, 50), 2)
        total = round(quantity * price, 2)
        sale_date = base_date + timedelta(days=random.randint(0, 365), 
                                          hours=random.randint(0, 23), 
                                          minutes=random.randint(0, 59))
        customer_id = random.randint(1000, 2000)
        customer_name = f"Customer {uuid.uuid4()}"
        region = random.choice(regions)
        
        data.append([sale_id, product_id, product_name, category, quantity, price, total, sale_date, customer_id, customer_name, region])
        
    return data

def save_to_parquet(data, file_path):
    df = pd.DataFrame(data, columns=['sale_id', 'product_id', 'product_name', 'category', 'quantity', 'price', 'total', 'sale_date', 'customer_id', 'customer_name', 'region'])
    table = pa.Table.from_pandas(df)
    pq.write_table(table, file_path)

def upload_to_s3(file_path, bucket_name, object_name):
    s3.upload_file(file_path, bucket_name, object_name)
    print(f"Uploaded {file_path} to s3://{bucket_name}/{object_name}")

def lambda_handler(*_):
    num_records = 1000
    data = generate_data(num_records)
    
    now = datetime.now()
    year = now.strftime('%Y')
    month = now.strftime('%m')
    day = now.strftime('%d')
    hour = now.strftime('%H')
    
    file_name = f"sales_data_{now.strftime('%Y%m%d_%H%M%S')}.parquet"
    file_path = f"/tmp/{file_name}"
    
    save_to_parquet(data, file_path)
    
    s3_key = f"{settings.FILE_PREFIX}/{year}/{month}/{day}/{hour}/{file_name}"
    upload_to_s3(file_path, settings.BUCKET_NAME, s3_key)
    
    os.remove(file_path)
    return {
        'statusCode': 200,
        'body': f"Uploaded {file_name} to s3://{settings.BUCKET_NAME}/{s3_key}"
    }

if __name__ == "__main__":
    lambda_handler()