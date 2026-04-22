import pandas as pd

def transform(dataframes):
    print("\n=== TRANSFORM PHASE ===")
    
    # --- ORDERS ---
    df_orders = dataframes['orders'].copy()
    # Convert date columns
    date_cols = ['order_purchase_timestamp', 'order_approved_at', 
                 'order_delivered_carrier_date', 'order_delivered_customer_date',
                 'order_estimated_delivery_date']
    for col in date_cols:
        df_orders[col] = pd.to_datetime(df_orders[col], errors='coerce')
    # Drop duplicates
    df_orders.drop_duplicates(subset='order_id', inplace=True)
    print(f"✓ orders: {len(df_orders)} rows after cleaning")

    # --- CUSTOMERS ---
    df_customers = dataframes['customers'].copy()
    df_customers.drop_duplicates(subset='customer_id', inplace=True)
    df_customers['customer_city'] = df_customers['customer_city'].str.lower().str.strip()
    df_customers['customer_state'] = df_customers['customer_state'].str.upper().str.strip()
    print(f"✓ customers: {len(df_customers)} rows after cleaning")

    # --- ORDER ITEMS ---
    df_order_items = dataframes['order_items'].copy()
    df_order_items.dropna(subset=['order_id', 'product_id', 'price'], inplace=True)
    df_order_items['price'] = pd.to_numeric(df_order_items['price'], errors='coerce')
    df_order_items['freight_value'] = pd.to_numeric(df_order_items['freight_value'], errors='coerce')
    print(f"✓ order_items: {len(df_order_items)} rows after cleaning")

    # --- PRODUCTS ---
    df_products = dataframes['products'].copy()
    df_products.drop_duplicates(subset='product_id', inplace=True)
    df_products['product_category_name'] = df_products['product_category_name'].str.lower().str.strip()
    print(f"✓ products: {len(df_products)} rows after cleaning")

    # --- SELLERS ---
    df_sellers = dataframes['sellers'].copy()
    df_sellers.drop_duplicates(subset='seller_id', inplace=True)
    df_sellers['seller_city'] = df_sellers['seller_city'].str.lower().str.strip()
    df_sellers['seller_state'] = df_sellers['seller_state'].str.upper().str.strip()
    print(f"✓ sellers: {len(df_sellers)} rows after cleaning")

    # --- ORDER PAYMENTS ---
    df_order_payments = dataframes['order_payments'].copy()
    df_order_payments.dropna(subset=['order_id', 'payment_value'], inplace=True)
    df_order_payments['payment_value'] = pd.to_numeric(df_order_payments['payment_value'], errors='coerce')
    print(f"✓ order_payments: {len(df_order_payments)} rows after cleaning")

    # --- ORDER REVIEWS ---
    df_order_reviews = dataframes['order_reviews'].copy()
    df_order_reviews.drop_duplicates(subset='review_id', inplace=True)
    # Clean text columns - remove special characters
    df_order_reviews['review_comment_message'] = df_order_reviews['review_comment_message'].astype(str).str.encode('ascii', errors='ignore').str.decode('ascii')
    df_order_reviews['review_comment_title'] = df_order_reviews['review_comment_title'].astype(str).str.encode('ascii', errors='ignore').str.decode('ascii')
    print(f"✓ order_reviews: {len(df_order_reviews)} rows after cleaning")

    # --- PRODUCT CATEGORY TRANSLATION ---
    df_translation = dataframes['product_category_translation'].copy()
    df_translation.drop_duplicates(inplace=True)
    print(f"✓ product_category_translation: {len(df_translation)} rows after cleaning")

    cleaned = {
        'orders': df_orders,
        'customers': df_customers,
        'order_items': df_order_items,
        'products': df_products,
        'sellers': df_sellers,
        'order_payments': df_order_payments,
        'order_reviews': df_order_reviews,
        'product_category_translation': df_translation
    }

    return cleaned

if __name__ == "__main__":
    from extract import extract
    data = extract()
    cleaned = transform(data)