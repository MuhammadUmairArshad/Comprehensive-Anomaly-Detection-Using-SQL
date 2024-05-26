SELECT
    Order_ID,
    Order_Amount
FROM
    Test.dbo.[Orders Discount]
WHERE
    Order_Amount > 1.5 * (SELECT AVG(Order_Amount) FROM Test.dbo.[Orders Discount])
    OR Order_Amount < 0.5 * (SELECT AVG(Order_Amount) FROM Test.dbo.[Orders Discount])
ORDER BY
    Order_Amount DESC;
