WITH AverageCost AS (
    SELECT CAST(AVG(Unit_Cost) AS FLOAT) AS AvgCost
    FROM Test.dbo.Products
)
SELECT 
    p.Product_ID, 
    p.Product_Name, 
    p.Unit_Cost, 
    p.prev_cost,
    a.AvgCost,
    CASE
        WHEN p.Unit_Cost > a.AvgCost THEN CONCAT('+', FORMAT(ABS(((p.Unit_Cost - a.AvgCost) / NULLIF(a.AvgCost, 0) * 100)), '0.00'))
        WHEN p.Unit_Cost < a.AvgCost THEN CONCAT('-', FORMAT(ABS(((p.Unit_Cost - a.AvgCost) / NULLIF(a.AvgCost, 0) * 100)), '0.00'))
        ELSE '0.00'
    END AS DeviationPercentageFromAvg,
    CONCAT(
        CASE
            WHEN p.Unit_Cost > p.prev_cost THEN '+' 
            WHEN p.Unit_Cost < p.prev_cost THEN '-' 
            ELSE '' 
        END,
        FORMAT(ABS(((CAST(p.Unit_Cost AS FLOAT) - CAST(p.prev_cost AS FLOAT)) / NULLIF(CAST(p.prev_cost AS FLOAT), 0) * 100)), '0.00')
    ) AS DeviationPercentageFromPrevCost
FROM Test.dbo.Products p
CROSS JOIN AverageCost a
WHERE ABS(CAST(p.Unit_Cost AS FLOAT) - CAST(p.prev_cost AS FLOAT)) / NULLIF(CAST(p.prev_cost AS FLOAT), 0) * 100 > 10
   OR ABS(CAST(p.Unit_Cost AS FLOAT) - CAST(p.prev_cost AS FLOAT)) / NULLIF(CAST(p.prev_cost AS FLOAT), 0) * 100 < -10;
