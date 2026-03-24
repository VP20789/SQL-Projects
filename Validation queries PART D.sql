-- 4. Create external table over Gold dataset

-- CREATE EXTERNAL TABLE gold_smartgear_sales_ext
-- (
--     OrderID     VARCHAR(100),
--     OrderDate   VARCHAR(50),
--     Region      VARCHAR(50),
--     StoreID     VARCHAR(50),
--     Product     VARCHAR(100),
--     Quantity    INT,
--     UnitPrice   DECIMAL(18,4)
-- )
-- WITH
-- (
--     LOCATION = 'gold/smartgear_sales.csv',      -- relative to DATA_SOURCE
--     DATA_SOURCE = smartgear_data_source,
--     FILE_FORMAT = CsvFormat
-- );

-- 5. Validation query 1: Revenue per order (PART D – screenshot)
-- SELECT TOP 100
--     OrderID,
--     OrderDate,
--     Region,
--     StoreID,
--     Product,
--     Quantity,
--     UnitPrice,
--     Quantity * UnitPrice AS Revenue
-- FROM gold_smartgear_sales_ext
-- ORDER BY Revenue DESC;

-- 6. Validation query 2: Revenue by region (trend)
SELECT
    Region,
    SUM(Quantity) AS TotalQuantity,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM gold_smartgear_sales_ext
GROUP BY Region
ORDER BY TotalRevenue DESC;

-- 7. Validation query 3: Top 10 products by revenue
SELECT
    Product,
    SUM(Quantity) AS TotalQuantity,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM gold_smartgear_sales_ext
GROUP BY Product
ORDER BY TotalRevenue DESC

-- 8. Optional trend: Monthly revenue
SELECT
    LEFT(OrderDate, 7) AS YearMonth,
    SUM(Quantity * UnitPrice) AS MonthlyRevenue
FROM gold_smartgear_sales_ext
WHERE TRY_CAST(OrderDate AS DATE) IS NOT NULL
GROUP BY LEFT(OrderDate, 7)
ORDER BY YearMonth;