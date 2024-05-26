SELECT 
    Order_ID,
    SUM(CASE WHEN (Discount / Price) > 0.5 THEN 1 ELSE 0 END) AS HighDiscountCount,
    SUM(Discount) AS TotalDiscount
FROM
    Test.dbo.[Orders Discount]
GROUP BY
    Order_ID
HAVING
    SUM(Discount) > 100 OR SUM(CASE WHEN (Discount / Price) > 0.5 THEN 1 ELSE 0 END) > 1
ORDER BY
    TotalDiscount DESC;
