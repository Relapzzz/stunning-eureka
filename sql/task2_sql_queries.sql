-- ============================================================
--  TASK 2: SQL for Data Extraction
--  ApexPlanet Data Analytics Internship
--  Dataset: Superstore Sales
-- ============================================================


-- ============================================================
-- DAY 7-8: SQL FUNDAMENTALS
-- ============================================================

-- 1. View all records (first 10 rows)
SELECT * FROM superstore LIMIT 10;

-- 2. View column names and structure (SQLite compatible)
PRAGMA table_info(superstore);

-- 3. Count total number of orders
SELECT COUNT(*) AS total_orders FROM superstore;

-- 4. Distinct regions
SELECT DISTINCT Region FROM superstore;

-- 5. Select specific columns
SELECT "Order ID", "Customer Name", Sales, Profit
FROM superstore
LIMIT 10;

-- 6. Filter: Orders where Profit is negative (loss-making)
SELECT "Order ID", "Product Name", Sales, Profit
FROM superstore
WHERE Profit < 0
ORDER BY Profit ASC
LIMIT 20;

-- 7. Filter: Orders from a specific region
SELECT * FROM superstore
WHERE Region = 'West'
LIMIT 10;

-- 8. ORDER BY: Top 10 highest-value sales
SELECT "Order ID", "Customer Name", "Product Name", Sales
FROM superstore
ORDER BY Sales DESC
LIMIT 10;

-- 9. GROUP BY: Total sales by Region
SELECT Region, ROUND(SUM(Sales), 2) AS total_sales
FROM superstore
GROUP BY Region
ORDER BY total_sales DESC;

-- 10. GROUP BY + HAVING: Categories with total sales > 100,000
SELECT Category, ROUND(SUM(Sales), 2) AS total_sales
FROM superstore
GROUP BY Category
HAVING SUM(Sales) > 100000
ORDER BY total_sales DESC;

-- 11. JOIN example (self-join to find customers with multiple orders)
SELECT a."Customer Name", COUNT(DISTINCT a."Order ID") AS order_count
FROM superstore a
GROUP BY a."Customer Name"
HAVING order_count > 5
ORDER BY order_count DESC
LIMIT 10;


-- ============================================================
-- DAY 9-10: ADVANCED SQL
-- ============================================================

-- 12. CTE: Top 5 products by total sales
WITH product_sales AS (
    SELECT
        "Product Name",
        ROUND(SUM(Sales), 2)   AS total_sales,
        ROUND(SUM(Profit), 2)  AS total_profit,
        COUNT(*)               AS times_ordered
    FROM superstore
    GROUP BY "Product Name"
)
SELECT *
FROM product_sales
ORDER BY total_sales DESC
LIMIT 5;

-- 13. CTE: Monthly revenue trend
WITH monthly_sales AS (
    SELECT
        SUBSTR("Order Date", 1, 7) AS year_month,   -- 'YYYY-MM' from 'MM/DD/YYYY'
        ROUND(SUM(Sales), 2)        AS monthly_revenue
    FROM superstore
    GROUP BY SUBSTR("Order Date", 1, 7)
)
SELECT *
FROM monthly_sales
ORDER BY year_month;

-- 14. Subquery: Products that generated above-average profit
SELECT "Product Name", ROUND(SUM(Profit), 2) AS total_profit
FROM superstore
GROUP BY "Product Name"
HAVING SUM(Profit) > (
    SELECT AVG(product_profit)
    FROM (
        SELECT SUM(Profit) AS product_profit
        FROM superstore
        GROUP BY "Product Name"
    )
)
ORDER BY total_profit DESC
LIMIT 15;

-- 15. Window Function: Row number by sales within each Category
SELECT
    "Product Name",
    Category,
    ROUND(Sales, 2) AS Sales,
    ROW_NUMBER() OVER (PARTITION BY Category ORDER BY Sales DESC) AS rank_in_category
FROM superstore
LIMIT 30;

-- 16. Window Function: RANK of customers by total spend
SELECT
    "Customer Name",
    ROUND(SUM(Sales), 2) AS total_spend,
    RANK() OVER (ORDER BY SUM(Sales) DESC) AS spend_rank
FROM superstore
GROUP BY "Customer Name"
LIMIT 20;

-- 17. Window Function: LAG – month-over-month sales change
WITH monthly AS (
    SELECT
        SUBSTR("Order Date", 1, 7)  AS yr_month,
        ROUND(SUM(Sales), 2)         AS revenue
    FROM superstore
    GROUP BY SUBSTR("Order Date", 1, 7)
),
with_lag AS (
    SELECT
        yr_month,
        revenue,
        LAG(revenue) OVER (ORDER BY yr_month) AS prev_month_revenue
    FROM monthly
)
SELECT
    yr_month,
    revenue,
    prev_month_revenue,
    ROUND(revenue - prev_month_revenue, 2)                          AS change,
    ROUND((revenue - prev_month_revenue) * 100.0 / prev_month_revenue, 1) AS pct_change
FROM with_lag
WHERE prev_month_revenue IS NOT NULL;

-- 18. Window Function: Running total of sales over time
SELECT
    SUBSTR("Order Date", 1, 7)                          AS yr_month,
    ROUND(SUM(Sales), 2)                                 AS monthly_sales,
    ROUND(SUM(SUM(Sales)) OVER (ORDER BY SUBSTR("Order Date",1,7)), 2) AS running_total
FROM superstore
GROUP BY SUBSTR("Order Date", 1, 7)
ORDER BY yr_month;

-- 19. CREATE VIEW: Reusable profit summary by Sub-Category
CREATE VIEW IF NOT EXISTS v_subcategory_profit AS
SELECT
    Category,
    "Sub-Category",
    ROUND(SUM(Sales), 2)    AS total_sales,
    ROUND(SUM(Profit), 2)   AS total_profit,
    ROUND(AVG(Discount), 3) AS avg_discount,
    COUNT(*)                AS order_count,
    ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS profit_margin_pct
FROM superstore
GROUP BY Category, "Sub-Category";

-- Query the view
SELECT * FROM v_subcategory_profit ORDER BY profit_margin_pct DESC;

-- 20. CREATE VIEW: Customer lifetime value
CREATE VIEW IF NOT EXISTS v_customer_ltv AS
SELECT
    "Customer ID",
    "Customer Name",
    Segment,
    Region,
    ROUND(SUM(Sales), 2)    AS lifetime_value,
    ROUND(SUM(Profit), 2)   AS lifetime_profit,
    COUNT(DISTINCT "Order ID") AS total_orders
FROM superstore
GROUP BY "Customer ID", "Customer Name", Segment, Region;

-- Query the view
SELECT * FROM v_customer_ltv ORDER BY lifetime_value DESC LIMIT 10;


-- ============================================================
-- DAY 11-13: 10 BUSINESS QUESTIONS ANSWERED WITH SQL
-- ============================================================

-- Q1: Top 5 products by total sales
SELECT
    "Product Name",
    ROUND(SUM(Sales), 2) AS total_sales
FROM superstore
GROUP BY "Product Name"
ORDER BY total_sales DESC
LIMIT 5;

-- Q2: Monthly sales trend (year + month)
SELECT
    SUBSTR("Order Date", 7, 4) AS year,
    SUBSTR("Order Date", 1, 2) AS month,
    ROUND(SUM(Sales), 2)        AS monthly_sales
FROM superstore
GROUP BY year, month
ORDER BY year, month;

-- Q3: Customer segmentation by total spend (High / Mid / Low)
SELECT
    "Customer Name",
    Segment,
    ROUND(SUM(Sales), 2) AS total_spend,
    CASE
        WHEN SUM(Sales) >= 5000 THEN 'High Value'
        WHEN SUM(Sales) >= 1000 THEN 'Mid Value'
        ELSE 'Low Value'
    END AS customer_tier
FROM superstore
GROUP BY "Customer Name", Segment
ORDER BY total_spend DESC;

-- Q4: Which shipping mode is most profitable?
SELECT
    "Ship Mode",
    ROUND(SUM(Sales), 2)  AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    COUNT(*)              AS order_count
FROM superstore
GROUP BY "Ship Mode"
ORDER BY total_profit DESC;

-- Q5: Top 5 loss-making sub-categories
SELECT
    "Sub-Category",
    ROUND(SUM(Profit), 2)  AS total_profit,
    ROUND(SUM(Sales), 2)   AS total_sales
FROM superstore
GROUP BY "Sub-Category"
ORDER BY total_profit ASC
LIMIT 5;

-- Q6: Which states generate the most revenue?
SELECT
    State,
    ROUND(SUM(Sales), 2)  AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM superstore
GROUP BY State
ORDER BY total_sales DESC
LIMIT 10;

-- Q7: Impact of discount on profit margin
SELECT
    CASE
        WHEN Discount = 0    THEN 'No Discount'
        WHEN Discount <= 0.1 THEN '1-10%'
        WHEN Discount <= 0.2 THEN '11-20%'
        WHEN Discount <= 0.3 THEN '21-30%'
        ELSE 'Above 30%'
    END AS discount_band,
    COUNT(*)                      AS orders,
    ROUND(AVG(Profit), 2)         AS avg_profit,
    ROUND(SUM(Profit), 2)         AS total_profit
FROM superstore
GROUP BY discount_band
ORDER BY
    CASE discount_band
        WHEN 'No Discount' THEN 1
        WHEN '1-10%' THEN 2
        WHEN '11-20%' THEN 3
        WHEN '21-30%' THEN 4
        ELSE 5
    END;

-- Q8: Average order value by customer segment
SELECT
    Segment,
    ROUND(AVG(order_value), 2) AS avg_order_value
FROM (
    SELECT Segment, "Order ID", SUM(Sales) AS order_value
    FROM superstore
    GROUP BY Segment, "Order ID"
)
GROUP BY Segment
ORDER BY avg_order_value DESC;

-- Q9: Year-over-year sales comparison
SELECT
    SUBSTR("Order Date", 7, 4) AS year,
    ROUND(SUM(Sales), 2)        AS annual_sales,
    ROUND(SUM(Profit), 2)       AS annual_profit
FROM superstore
GROUP BY year
ORDER BY year;

-- Q10: Top 10 most valuable customers by lifetime profit
SELECT
    "Customer Name",
    Segment,
    Region,
    ROUND(SUM(Sales), 2)           AS total_sales,
    ROUND(SUM(Profit), 2)          AS total_profit,
    COUNT(DISTINCT "Order ID")     AS total_orders
FROM superstore
GROUP BY "Customer Name", Segment, Region
ORDER BY total_profit DESC
LIMIT 10;
