-- Q1- What are the top 10 product categories by total revenue?

SELECT 
    COALESCE(t.product_category_name_english, p.product_category_name) AS category,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM olist_db.order_items oi
JOIN olist_db.orders o ON oi.order_id = o.order_id
JOIN olist_db.products p ON oi.product_id = p.product_id
JOIN olist_db.product_category_translation t ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 10;


-- Q2 — Monthly Revenue Trend:
SELECT 
    DATE_FORMAT(olist_db.o.order_purchase_timestamp, '%Y-%m') AS month,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM olist_db.order_items oi
JOIN olist_db.orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month ASC;


-- Q3 - What is the month-over-month revenue growth percentage?
WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
        ROUND(SUM(oi.price), 2) AS total_revenue
    FROM olist_db.order_items oi
    JOIN olist_db.orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY month
    ORDER BY month ASC
)
SELECT 
    month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY month) AS prev_month_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY month)) 
        * 100.0 
        / NULLIF(LAG(total_revenue) OVER (ORDER BY month), 0)
    , 2) AS pct_change
FROM monthly_revenue;


-- Q4 -  Top 10 customers by total spend with rank
WITH customer_spend AS (
    SELECT 
        c.customer_id,
        c.customer_city,
        ROUND(SUM(oi.price), 2) AS total_spend
    FROM olist_db.order_items oi
    JOIN olist_db.orders o ON oi.order_id = o.order_id
    JOIN olist_db.customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_id, c.customer_city
)
SELECT 
    RANK() OVER (ORDER BY total_spend DESC) AS `rank`,
    customer_id,
    customer_city,
    total_spend
FROM customer_spend
LIMIT 10;


-- Q5 — Order Delivery Performance
SELECT 
    c.customer_state,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 1) AS avg_delivery_days,
    COUNT(*) AS total_orders
FROM olist_db.orders o
JOIN olist_db.customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days ASC;


-- Q6. — Payment Type Breakdown
SELECT 
payment_type,  
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(COUNT(DISTINCT order_id) * 100.0 / (SELECT COUNT(DISTINCT order_id) FROM olist_db.order_payments), 2) AS percentage
FROM olist_db.order_payments  
GROUP BY payment_type
ORDER BY total_orders desc; 



-- Q7. — Seller Performance Analysis
WITH sale AS (
    SELECT 
        s.seller_id,
        s.seller_city,
        ROUND(SUM(oi.price), 2) AS total_revenue,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM olist_db.order_items oi
    JOIN olist_db.orders o ON oi.order_id = o.order_id
    JOIN olist_db.sellers s ON oi.seller_id = s.seller_id
    WHERE o.order_status = 'delivered'
    GROUP BY s.seller_id, s.seller_city
)
SELECT 
    RANK() OVER (ORDER BY total_revenue DESC) AS `rank`,
    seller_id,
    seller_city,
    total_revenue,
    total_orders
FROM sale
LIMIT 10;

-- Q8. — Repeat vs One-Time Customers

WITH customer_orders AS (
    SELECT 
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM olist_db.orders o
    JOIN olist_db.customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
customer_type AS (
    SELECT 
        CASE 
            WHEN order_count > 1 THEN 'repeat'
            ELSE 'one_time'
        END AS customer_type,
        COUNT(*) AS total_customers
    FROM customer_orders
    GROUP BY customer_type
)
SELECT 
    customer_type,
    total_customers,
    ROUND(total_customers * 100.0 / (SELECT SUM(total_customers) FROM customer_type), 2) AS percentage
FROM customer_type
ORDER BY total_customers DESC;