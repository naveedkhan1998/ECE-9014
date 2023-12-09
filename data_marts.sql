CREATE SCHEMA IF NOT EXISTS data_mart;

CREATE VIEW data_mart.total_sales_by_category_quarter AS
SELECT
    category_name,
    quarter,
    SUM(list_price * quantity) AS total_sales
FROM
    datawarehouse.orders_fact
GROUP BY
    category_name,
    quarter
ORDER BY
    quarter;

CREATE VIEW data_mart.monthly_sales_trend AS
SELECT
    year,
    month,
    SUM(list_price * quantity) AS monthly_sales
FROM
    datawarehouse.orders_fact
GROUP BY
    year,
    month
ORDER BY
    year,
    month;

CREATE VIEW data_mart.top_selling_products AS
SELECT
    product_name,
    SUM(quantity) AS total_sold
FROM
    datawarehouse.orders_fact
GROUP BY
    product_name
ORDER BY
    total_sold DESC
LIMIT
    10;

CREATE VIEW data_mart.sales_distribution_by_state AS
SELECT
    store_state,
    SUM(list_price * quantity) AS total_sales
FROM
    datawarehouse.orders_fact
GROUP BY
    store_state;

CREATE VIEW data_mart.sales_performance_by_brand AS
SELECT
    brand_name,
    SUM(list_price * quantity) AS total_sales
FROM
    datawarehouse.orders_fact
GROUP BY
    brand_name;

CREATE VIEW data_mart.store_performance_metrics AS
SELECT
    store_id,
    store_city,
    store_state,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(list_price * quantity) AS total_sales
FROM
    datawarehouse.orders_fact
GROUP BY
    store_id,
    store_city,
    store_state;

CREATE VIEW data_mart.monthly_sales_by_category_brand AS
SELECT
    year,
    month,
    category_name,
    brand_name,
    SUM(list_price * quantity) AS monthly_sales
FROM
    datawarehouse.orders_fact
GROUP BY
    year,
    month,
    category_name,
    brand_name
ORDER BY
    year,
    month;


-- Create a view for the fact table
CREATE
OR REPLACE VIEW datawarehouse.orders_fact_view AS
SELECT
    *
FROM
    datawarehouse.orders_fact;

-- Create a view from the fact table with daily aggregation
CREATE
OR REPLACE VIEW datawarehouse.orders_daily_view AS
SELECT
    order_date,
    SUM(list_price :: numeric) AS total_sales
FROM
    datawarehouse.orders_fact
GROUP BY
    order_date
ORDER BY
    order_date;

-- association analysis
SELECT
    order_id,
    CONCAT(
        '{',
        STRING_AGG(
            '"{' || category_name || ':' || quantity || '}"',
            ','
        ),
        '}'
    ) AS category_names
FROM
    datawarehouse.orders_fact
GROUP BY
    order_id;

-- another one
SELECT
    order_id,
    ARRAY_AGG(category_name) AS category_names,
    ARRAY_AGG(quantity) AS quantities
FROM
    datawarehouse.orders_fact
GROUP BY
    order_id;

-- another one
SELECT
    order_id,
    ARRAY_AGG(category_name) AS category_names
FROM
    datawarehouse.orders_fact
GROUP BY
    order_id;

