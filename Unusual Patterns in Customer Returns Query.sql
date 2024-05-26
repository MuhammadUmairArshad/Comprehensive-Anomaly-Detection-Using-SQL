WITH CustomerReturnStats AS (
    SELECT
        Customer_ID,
        COUNT(CASE WHEN Returned = 'Yes' THEN Order_ID END) AS ReturnCount,
        COUNT(Order_ID) AS TotalOrderCount
    FROM
        Test.dbo.[Orders Return]
    GROUP BY
        Customer_ID
),
CustomerReturnRate AS (
    SELECT
        Customer_ID,
        ReturnCount,
        TotalOrderCount,
        CAST(ROUND((ReturnCount * 100.0 / TotalOrderCount), 2) AS DECIMAL(10, 2)) AS ReturnRate
    FROM
        CustomerReturnStats
)
SELECT
    Customer_ID,
    ReturnCount,
    TotalOrderCount,
    FORMAT(ReturnRate, '0.##') AS ReturnRate
FROM
    CustomerReturnRate
WHERE
    ReturnRate > 20 -- Adjust the threshold as needed
ORDER BY
    ReturnRate DESC;
