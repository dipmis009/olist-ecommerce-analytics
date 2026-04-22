from extract import extract
from transform import transform
from load import load
import time

if __name__ == "__main__":
    start = time.time()
    
    print("🚀Starting Olist ETL Pipeline...")
    print("=" * 40)
    
    # Step 1 - Extract
    raw_data = extract()
    
    # Step 2 - Transform
    cleaned_data = transform(raw_data)
    
    # Step 3 - Load
    load(cleaned_data)
    
    end = time.time()
    duration = round(end - start, 2)
    
    print("=" * 40)
    print(f"✅ Pipeline completed in {duration} seconds!")