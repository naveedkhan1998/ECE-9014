-- Create 'datawarehouse' schema if it does not exist
CREATE SCHEMA IF NOT EXISTS datawarehouse;

-- Create denormalized 'order_items' table with product details, product categories, and brands
CREATE TABLE IF NOT EXISTS datawarehouse.denormalized_order_items AS
SELECT
    oi.item_id,
    oi.order_id,
    oi.quantity,
    oi.list_price,
    p.product_id,
    p.product_name,
    p.category_id,
    p.brand_id,
    p.model_year,
    c.category_name,
    b.brand_name
FROM
    sales.order_items oi
    JOIN production.products p ON oi.product_id = p.product_id
    JOIN production.brands b ON p.brand_id = b.brand_id
    JOIN production.categories c ON p.category_id = c.category_id
ORDER BY
    oi.order_id,
    oi.item_id;

-- Create the stores table
CREATE TABLE IF NOT EXISTS datawarehouse.stores AS
SELECT
    store_id,
    city,
    state
FROM
    sales.stores
ORDER BY
    store_id;

-- Create 'time_dimension' table
CREATE TABLE IF NOT EXISTS datawarehouse.time_dimension AS
SELECT
    DISTINCT order_date,
    EXTRACT(
        DAY
        FROM
            order_date
    ) AS day,
    EXTRACT(
        MONTH
        FROM
            order_date
    ) AS month,
    EXTRACT(
        YEAR
        FROM
            order_date
    ) AS year,
    EXTRACT(
        QUARTER
        FROM
            order_date
    ) AS quarter,
    EXTRACT(
        WEEK
        FROM
            order_date
    ) AS week
FROM
    sales.orders
ORDER BY
    order_date;

-- Create the fact table 'orders_fact' in the 'datawarehouse' schema
CREATE TABLE IF NOT EXISTS datawarehouse.orders_fact AS
SELECT
    -- order table
    DISTINCT o.order_id,
    o.order_date,
    o.store_id,
    -- time dimension
    td.day,
    td.month,
    td.year,
    td.quarter,
    td.week,
    -- denormalized order items table
    doi.quantity,
    doi.list_price,
    doi.product_name,
    doi.category_name,
    doi.brand_name,
    -- store table 
    s.city AS store_city,
    s.state AS store_state
FROM
    sales.orders o
    JOIN datawarehouse.denormalized_order_items doi ON o.order_id = doi.order_id
    JOIN datawarehouse.stores s ON o.store_id = s.store_id
    JOIN datawarehouse.time_dimension td ON o.order_date = td.order_date
ORDER BY
    o.order_id;