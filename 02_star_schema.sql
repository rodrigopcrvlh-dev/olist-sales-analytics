-- Star schema: dimensions + fact table

-- Customer dimension
CREATE TABLE dim_customer AS
SELECT customer_id, customer_unique_id, customer_city, customer_state
FROM customers;
ALTER TABLE dim_customer ADD PRIMARY KEY (customer_id);

-- Product dimension (category translated to English)
CREATE TABLE dim_product AS
SELECT p.product_id,
       p.product_category_name AS category_pt,
       COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category_en,
       p.product_weight_g
FROM products p
LEFT JOIN product_category_name_translation t
  ON t.product_category_name = p.product_category_name;
ALTER TABLE dim_product ADD PRIMARY KEY (product_id);

-- Seller dimension
CREATE TABLE dim_seller AS
SELECT seller_id, seller_city, seller_state
FROM sellers;
ALTER TABLE dim_seller ADD PRIMARY KEY (seller_id);

-- Date dimension (one row per day)
CREATE TABLE dim_date AS
SELECT d::date AS date_id,
       EXTRACT(year FROM d)::int AS year,
       EXTRACT(quarter FROM d)::int AS quarter,
       EXTRACT(month FROM d)::int AS month,
       TO_CHAR(d, 'YYYY-MM') AS year_month,
       EXTRACT(isodow FROM d)::int AS weekday
FROM generate_series('2016-09-01'::date, '2018-12-31'::date, interval '1 day') AS d;
ALTER TABLE dim_date ADD PRIMARY KEY (date_id);

-- Fact table: one row per item within an order
CREATE TABLE fact_sales AS
SELECT oi.order_id,
       oi.order_item_id,
       o.customer_id,
       oi.product_id,
       oi.seller_id,
       o.order_purchase_timestamp::date AS order_date,
       o.order_status,
       oi.price,
       oi.freight_value,
       o.order_delivered_customer_date::date AS delivered_date,
       o.order_estimated_delivery_date::date AS estimated_date
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id;
ALTER TABLE fact_sales ADD PRIMARY KEY (order_id, order_item_id);

-- Check: should return 112650 (same as order_items)
SELECT COUNT(*) FROM fact_sales;
