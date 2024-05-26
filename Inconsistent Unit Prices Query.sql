WITH AveragePrice AS (
    SELECT CAST(AVG(Unit_Price) AS FLOAT) AS AvgPrice
    FROM Test.dbo.Products
)
SELECT 
    p.Product_ID, 
    p.Product_Name, 
    p.Unit_Price, 
    p.Prev_Price,
    a.AvgPrice,
    CASE
        WHEN p.Unit_Price > a.AvgPrice THEN CONCAT('+', FORMAT(ABS(((p.Unit_Price - a.AvgPrice) / NULLIF(a.AvgPrice, 0) * 100)), '0.00'))
        WHEN p.Unit_Price < a.AvgPrice THEN CONCAT('-', FORMAT(ABS(((p.Unit_Price - a.AvgPrice) / NULLIF(a.AvgPrice, 0) * 100)), '0.00'))
        ELSE '0.00'
    END AS DeviationPercentageFromAvg,
    CONCAT(
        CASE
            WHEN p.Unit_Price > p.prev_price THEN '+' 
            WHEN p.Unit_Price < p.prev_price THEN '-' 
            ELSE '' 
        END,
        FORMAT(ABS(((CAST(p.Unit_Price AS FLOAT) - CAST(p.prev_price AS FLOAT)) / NULLIF(CAST(p.prev_price AS FLOAT), 0) * 100)), '0.00')
    ) AS DeviationPercentageFromPrevPrice
FROM Test.dbo.Products p
CROSS JOIN AveragePrice a
WHERE ABS(CAST(p.Unit_Price AS FLOAT) - CAST(p.prev_price AS FLOAT)) / NULLIF(CAST(p.prev_price AS FLOAT), 0) * 100 > 10
   OR ABS(CAST(p.Unit_Price AS FLOAT) - CAST(p.prev_price AS FLOAT)) / NULLIF(CAST(p.prev_price AS FLOAT), 0) * 100 < -10;
