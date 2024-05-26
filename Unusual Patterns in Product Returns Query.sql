WITH ReturnRates AS (
    SELECT
        Product_ID,
        SUM(CASE WHEN Returned = 'Yes' THEN 1 ELSE 0 END) AS Return_Count,
        SUM(Sales) AS Total_Sales_Qty,
        ROUND((SUM(CASE WHEN Returned = 'Yes' THEN 1 ELSE 0 END) / CAST(SUM(Sales) AS FLOAT)) * 100, 2) AS Return_Rate_Percentage
    FROM
        Test.dbo.[Sales returns]
    GROUP BY
        Product_ID
)
SELECT DISTINCT
    r.Product_ID,
    r.Return_Count,
    r.Total_Sales_Qty,
    r.Return_Rate_Percentage,
    p.Product_Name
FROM
    ReturnRates r
JOIN
    Test.dbo.[Sales returns] p ON r.Product_ID = p.Product_ID
WHERE
    r.Return_Rate_Percentage > 10; -- Adjust the threshold as needed
