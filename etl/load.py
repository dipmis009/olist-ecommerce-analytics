import mysql.connector
from sqlalchemy import create_engine
from urllib.parse import quote_plus
import pandas as pd

DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'xxxxxxxxxx',  # your MySQL password
    'database': 'olist_db'
}

def load(cleaned_dataframes):
    print("\n=== LOAD PHASE ===")
    
    password = quote_plus(DB_CONFIG['password'])
    engine = create_engine(
        f"mysql+mysqlconnector://{DB_CONFIG['user']}:{password}@{DB_CONFIG['host']}/{DB_CONFIG['database']}"
    )
    
    load_order = [
        'customers',
        'orders', 
        'products',
        'sellers',
        'product_category_translation',
        'order_items',
        'order_payments',
        'order_reviews'
    ]
    
    for table_name in load_order:
        df = cleaned_dataframes[table_name]
        try:
            df.to_sql(
                name=table_name,
                con=engine,
                if_exists='replace',
                index=False,
                chunksize=1000
            )
            print(f"✓ Loaded {table_name}: {len(df)} rows")
        except Exception as e:
            print(f"✗ Failed to load {table_name}: {e}")
    
    engine.dispose()
    print("\n✓ All tables loaded successfully!")

if __name__ == "__main__":
    from extract import extract
    from transform import transform
    data = extract()
    cleaned = transform(data)
    load(cleaned)