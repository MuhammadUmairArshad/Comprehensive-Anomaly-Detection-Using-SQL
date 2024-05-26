WITH EmployeeSalesStats AS (
    SELECT
        Employee_ID,
        SUM(Sales) AS TotalSalesAmount,
        DATEPART(YEAR, Order_Date) AS SaleYear,
        DATEPART(MONTH, Order_Date) AS SaleMonth
    FROM
        Test.dbo.[Employee Sales]
    GROUP BY
        Employee_ID,
        DATEPART(YEAR, Order_Date),
        DATEPART(MONTH, Order_Date)
),
AverageSalesPerformance AS (
    SELECT
        Employee_ID,
        AVG(TotalSalesAmount) OVER (PARTITION BY Employee_ID) AS AvgSalesAmount
    FROM
        EmployeeSalesStats
    WHERE
        SaleYear = YEAR(GETDATE()) AND SaleMonth < MONTH(GETDATE()) -- Calculate average for previous months
)
SELECT DISTINCT
    e.Employee_ID,
    e.TotalSalesAmount,
	e.SaleYear,
    e.SaleMonth,
    a.AvgSalesAmount AS AvgSalesAmountPerEmployee
FROM
    EmployeeSalesStats e
JOIN
    AverageSalesPerformance a ON e.Employee_ID = a.Employee_ID
WHERE
    e.SaleYear = YEAR(GETDATE()) AND e.SaleMonth = MONTH(GETDATE()) -- Compare with current month
    AND (e.TotalSalesAmount > 1.15 * a.AvgSalesAmount OR e.TotalSalesAmount < 0.85 * a.AvgSalesAmount) -- Adjust threshold as needed
ORDER BY
    e.Employee_ID,
    e.SaleYear,
    e.SaleMonth;
