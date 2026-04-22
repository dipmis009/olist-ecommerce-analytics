import pandas as pd
import os

# Path to your CSV files
CSV_PATH = "/Users/dipali/Downloads/E_commerce_dataset"

def extract():
    print("=== EXTRACT PHASE ===")
    
    files = {
        'orders': 'olist_orders_dataset.csv',
        'customers': 'olist_customers_dataset.csv',
        'order_items': 'olist_order_items_dataset.csv',
        'products': 'olist_products_dataset.csv',
        'sellers': 'olist_sellers_dataset.csv',
        'order_payments': 'olist_order_payments_dataset.csv',
        'order_reviews': 'olist_order_reviews_dataset.csv',
        'product_category_translation': 'product_category_name_translation.csv'
    }
    
    dataframes = {}
    
    for name, filename in files.items():
        filepath = os.path.join(CSV_PATH, filename)
        try:
            df = pd.read_csv(filepath, encoding='utf-8', on_bad_lines='skip')
            dataframes[name] = df
            print(f"✓ Loaded {name}: {len(df)} rows")
        except Exception as e:
            print(f"✗ Failed to load {name}: {e}")
    
    return dataframes

if __name__ == "__main__":
    data = extract()