SELECT 
    Order_ID,
    Shipped_Date,
    Delivered_Date,
    DATEDIFF(day, Shipped_Date, Delivered_Date) AS DaysDelay
FROM 
    Test.dbo.[Orders Delivery]
WHERE 
    DATEDIFF(day, Shipped_Date, Delivered_Date) > 5; -- Change 5 to your desired threshold
