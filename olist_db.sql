Select * from ocd_customers;
select * from ocd_geolocation;
select * from ocd_order_items;
select * from ocd_order_payments;
select * from ocd_order_reviews;
select * from ocd_orders;
select * from ocd_product_category;
select * from ocd_products;
select * from ocd_sellers;


----------------vw_executive_kpis-------

CREATE OR REPLACE VIEW vw_executive_kpis AS

WITH order_sales AS (
    SELECT
        order_id,
        SUM(price) AS product_value,
        SUM(freight_value) AS freight_value,
        SUM(price + freight_value) AS order_value
    FROM ocd_order_items
    GROUP BY order_id
),

delivered_orders AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.delivery_days,
        o.delivery_delay,
        c.customer_unique_id
    FROM ocd_orders o
    LEFT JOIN ocd_customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
)

SELECT
    COUNT(*) AS total_orders,

    COUNT(DISTINCT customer_unique_id) AS total_customers,

    COALESCE(SUM(os.order_value), 0) AS total_revenue,

    COALESCE(SUM(os.order_value), 0)
     / NULLIF(COUNT(*), 0)AS average_order_value,

     AVG(delivery_days) AS average_delivery_days,

     COUNT(*) FILTER (
         WHERE delivery_delay > 0
        ) * 100.0 / NULLIF(COUNT(*), 0) AS late_delivery_percentage

FROM delivered_orders d
LEFT JOIN order_sales os
    ON d.order_id = os.order_id;

select * from vw_executive_kpis;

-------------------vw_sales_analysis---------------

CREATE OR REPLACE VIEW vw_sales_analysis AS
SELECT
    o.order_id,
	o.order_purchase_timestamp::date AS order_date,
    EXTRACT(YEAR FROM o.order_purchase_timestamp)::int
        AS order_year,
    EXTRACT(MONTH FROM o.order_purchase_timestamp)::int
        AS order_month,
    EXTRACT(QUARTER FROM o.order_purchase_timestamp)::int
        AS order_quarter,
    oi.product_id,
    oi.seller_id,
    COALESCE(
        p.product_category_name,
        'Unknown'
    ) AS product_category_name,
    oi.price,
    oi.freight_value,
    (oi.price + oi.freight_value) AS item_value
FROM ocd_orders o
INNER JOIN ocd_order_items oi
    ON o.order_id = oi.order_id
LEFT JOIN ocd_products p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered';

select * from vw_sales_analysis;


-------------------------vw_customer_analysis----------------------------

CREATE OR REPLACE VIEW vw_customer_analysis AS
WITH order_sales AS (
    SELECT
        order_id,
        SUM(price + freight_value) AS order_value
    FROM ocd_order_items
    GROUP BY order_id
),
customer_orders AS (
    SELECT
        o.order_id,
        o.customer_id,
        c.customer_unique_id,
        c.customer_city,
        c.customer_state,
        o.order_purchase_timestamp,
        COALESCE(os.order_value, 0) AS order_value
    FROM ocd_orders o
    LEFT JOIN ocd_customers c
        ON o.customer_id = c.customer_id
    LEFT JOIN order_sales os
        ON o.order_id = os.order_id
    WHERE o.order_status = 'delivered'
)
SELECT
    customer_unique_id,
    MAX(customer_city) AS customer_city,
    MAX(customer_state) AS customer_state,
    COUNT(DISTINCT order_id) AS total_orders,
	SUM(order_value)AS total_spent,
    AVG(order_value) AS average_order_value,
    MIN(order_purchase_timestamp::date) AS first_order_date,
    MAX(order_purchase_timestamp::date) AS last_order_date,

    CASE
        WHEN COUNT(DISTINCT order_id) > 1
        THEN 'Repeat Customer'
        ELSE 'One-Time Customer'
    END AS customer_type
	
FROM customer_orders
GROUP BY customer_unique_id;

select * from vw_customer_analysis;


--------------------------vw_delivery_analysis--------------------------------

CREATE OR REPLACE VIEW vw_delivery_analysis AS
SELECT
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    o.order_purchase_timestamp::date AS order_date,
    o.delivery_days,
    o.delivery_delay,

    CASE
        WHEN o.delivery_delay > 0
            THEN 'Late'
        WHEN o.delivery_delay <= 0
            THEN 'On Time'
        ELSE 'Unknown'
    END AS delivery_status

FROM ocd_orders o
LEFT JOIN ocd_customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered';

select * from vw_delivery_analysis;


-------------------vw_product_analysis----------------------

CREATE OR REPLACE VIEW vw_product_analysis AS
SELECT
    oi.product_id,
    COALESCE(
        p.product_category_name,
        'Unknown'
    ) AS product_category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(*) AS total_items_sold,
    SUM(oi.price) AS product_revenue,
    SUM(oi.freight_value) AS total_freight,
    SUM(oi.price + oi.freight_value) AS total_order_value,
    AVG(oi.price) AS average_product_price,
    COUNT(DISTINCT oi.seller_id) AS number_of_sellers

FROM ocd_order_items oi
INNER JOIN ocd_orders o
    ON oi.order_id = o.order_id
LEFT JOIN ocd_products p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY
    oi.product_id,
    p.product_category_name;

select * from vw_product_analysis;


-----------------------vw_customer_satisfaction----------------------------

CREATE OR REPLACE VIEW vw_customer_satisfaction AS
WITH review_summary AS (
    SELECT
        order_id,
        AVG(review_score) AS review_score
    FROM ocd_order_reviews
    GROUP BY order_id
)
SELECT
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    c.customer_state,
    o.order_purchase_timestamp::date AS order_date,
    o.delivery_days,
    o.delivery_delay,

    CASE
        WHEN o.delivery_delay > 0
            THEN 'Late'
        WHEN o.delivery_delay <= 0
            THEN 'On Time'
        ELSE 'Unknown'
    END AS delivery_status,
    
	rs.review_score AS review_score
FROM ocd_orders o
LEFT JOIN ocd_customers c
    ON o.customer_id = c.customer_id
LEFT JOIN review_summary rs
    ON o.order_id = rs.order_id
WHERE o.order_status = 'delivered';

select * from vw_customer_satisfaction;



-------------------Delivery vs Customer Satisfaction---------------

SELECT
    delivery_status,
    AVG(review_score) AS avg_review_score,
    COUNT(*) AS total_orders
FROM vw_customer_satisfaction
GROUP BY delivery_status;

-- What is the Monthly revenue trend?

select order_month,sum(item_value)as revenue
from vw_sales_analysis
group by 1
order by 1;

--What is the Revenue by category?

SELECT
    product_category_name,
    ROUND(SUM(item_value)::numeric, 2) AS revenue
FROM vw_sales_analysis
GROUP BY product_category_name
ORDER BY revenue DESC;

--what is the top 10 products?

SELECT
    product_id,
    product_category_name,
    total_order_value
FROM vw_product_analysis
ORDER BY total_order_value DESC
LIMIT 10;

--What is the Average Order Value ?

SELECT average_order_value
FROM vw_executive_kpis;

-- what is the Repeat customer % ?

SELECT
    COUNT(*) FILTER (
        WHERE customer_type = 'Repeat Customer'
    ) * 100.0 / COUNT(*) AS repeat_customer_percentage
FROM vw_customer_analysis;

-- What is the Revenue by state?

SELECT
    customer_state,
    ROUND(SUM(total_spent)::numeric, 2) AS revenue
FROM vw_customer_analysis
GROUP BY customer_state
ORDER BY revenue DESC;

-- What is the Average delivery time?

SELECT
    ROUND(AVG(delivery_days)::numeric, 2) AS average_delivery_days
FROM vw_delivery_analysis;

-- What is the Late delivery % ?

SELECT
    ROUND(
        COUNT(*) FILTER (
            WHERE delivery_status = 'Late'
        ) * 100.0 / COUNT(*),
        2
    ) AS late_delivery_percentage
FROM vw_delivery_analysis;

-----------Delivery status vs review score----------------

SELECT
    delivery_status,
    ROUND(AVG(review_score)::numeric, 2) AS average_review_score,
    COUNT(*) AS total_orders
FROM vw_customer_satisfaction
WHERE review_score IS NOT NULL
GROUP BY delivery_status;




SELECT COUNT(*) FROM ocd_orders;

SELECT
    COUNT(*) AS rows,
    COUNT(DISTINCT order_id) AS unique_orders
FROM vw_customer_satisfaction;