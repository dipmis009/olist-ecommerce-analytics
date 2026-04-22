CREATE TABLE `olist_db`.`orders` (
  `order_id` VARCHAR(50) NOT NULL,
  `customer_id` VARCHAR(50),
  `order_status` VARCHAR(50),
  `order_purchase_timestamp` DATETIME,
  `order_approved_at` DATETIME,
  `order_delivered_carrier_date` DATETIME,
  `order_delivered_customer_date` DATETIME,
  `order_estimated_delivery_date` DATETIME,
  PRIMARY KEY (`order_id`)
);

CREATE TABLE `olist_db`.`customers` (
  `customer_id` VARCHAR(50) NOT NULL,
  `customer_unique_id` VARCHAR(50),
  `customer_zip_code_prefix` VARCHAR(10),
  `customer_city` VARCHAR(100),
  `customer_state` VARCHAR(10),
  PRIMARY KEY (`customer_id`)
);

CREATE TABLE `olist_db`.`order_items` (
  `order_id` VARCHAR(50),
  `order_item_id` INT,
  `product_id` VARCHAR(50),
  `seller_id` VARCHAR(50),
  `shipping_limit_date` DATETIME,
  `price` DECIMAL(10,2),
  `freight_value` DECIMAL(10,2)
);

CREATE TABLE `olist_db`.`products` (
  `product_id` VARCHAR(50) NOT NULL,
  `product_category_name` VARCHAR(100),
  `product_name_lenght` INT,
  `product_description_lenght` INT,
  `product_photos_qty` INT,
  `product_weight_g` INT,
  `product_length_cm` INT,
  `product_height_cm` INT,
  `product_width_cm` INT,
  PRIMARY KEY (`product_id`)
);

CREATE TABLE `olist_db`.`sellers` (
  `seller_id` VARCHAR(50) NOT NULL,
  `seller_zip_code_prefix` VARCHAR(10),
  `seller_city` VARCHAR(100),
  `seller_state` VARCHAR(10),
  PRIMARY KEY (`seller_id`)
);

CREATE TABLE `olist_db`.`order_payments` (
  `order_id` VARCHAR(50),
  `payment_sequential` INT,
  `payment_type` VARCHAR(50),
  `payment_installments` INT,
  `payment_value` DECIMAL(10,2)
);

CREATE TABLE `olist_db`.`order_reviews` (
  `review_id` VARCHAR(50),
  `order_id` VARCHAR(50),
  `review_score` INT,
  `review_comment_title` VARCHAR(100),
  `review_comment_message` TEXT,
  `review_creation_date` DATETIME,
  `review_answer_timestamp` DATETIME
);

CREATE TABLE `olist_db`.`product_category_translation` (
  `product_category_name` VARCHAR(100),
  `product_category_name_english` VARCHAR(100)
);
