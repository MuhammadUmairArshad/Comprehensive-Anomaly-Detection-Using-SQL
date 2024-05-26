WITH CustomerOrderStats AS (
    SELECT
        Customer_ID,
        COUNT(DISTINCT Order_ID) AS OrderCount,
        AVG(Order_Amount) AS AvgOrderAmount,
        YEAR(Order_Date) AS OrderYear
    FROM
        Test.dbo.[Orders Discount]
    WHERE
        YEAR(Order_Date) = YEAR(GETDATE()) - 1
    GROUP BY
        Customer_ID,
        YEAR(Order_Date)
),
Averages AS (
    SELECT
        AVG(OrderCount) AS AvgOrderCountLastYear,
        AVG(AvgOrderAmount) AS AvgOrderAmountLastYear
    FROM
        CustomerOrderStats
    WHERE
        OrderYear = YEAR(GETDATE()) - 1
),
CurrentStats AS (
    SELECT
        Customer_ID,
        COUNT(DISTINCT Order_ID) AS OrderCount,
        AVG(Order_Amount) AS AvgOrderAmount
    FROM
        Test.dbo.[Orders Discount]
    WHERE
        YEAR(Order_Date) = YEAR(GETDATE())
    GROUP BY
        Customer_ID
)
SELECT
    c.Customer_ID,
    c.OrderCount,
    c.AvgOrderAmount,
    ROUND(((c.AvgOrderAmount - a.AvgOrderAmountLastYear) / a.AvgOrderAmountLastYear) * 100, 2) AS AvgOrderAmountPercentDiff
FROM
    CurrentStats c
    CROSS JOIN Averages a
WHERE
    c.OrderCount > 1.15 * a.AvgOrderCountLastYear
    OR c.AvgOrderAmount > 1.15 * a.AvgOrderAmountLastYear
ORDER BY
    c.OrderCount DESC,
    c.AvgOrderAmount DESC;
