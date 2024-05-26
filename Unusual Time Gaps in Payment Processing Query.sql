SELECT 
    [Sr],
    [Customer_ID],
    [Order_ID],
    [Customer_Name],
    [Due_Date],
    CAST(GETDATE() AS DATE) AS Today_Date, --Cast is used to convert date+time to only date
    DATEDIFF(day, [Due_Date], CAST(GETDATE() AS DATE)) AS DaysOverdue
FROM Test.dbo.[Transaction Data]
WHERE DATEDIFF(day, [Due_Date], CAST(GETDATE() AS DATE)) > 0;