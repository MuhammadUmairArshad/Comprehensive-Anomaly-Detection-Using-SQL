SELECT 
    [Order_ID], 
    [Customer_ID], 
    [Quantity_Sold], 
    [Per_Unit_Price],
    COUNT(*) AS DuplicateCount
FROM Test.dbo.[Transaction Data]
GROUP BY [Order_ID], [Customer_ID], [Quantity_Sold], [Per_Unit_Price]
HAVING COUNT(*) > 1;
