SELECT 
    Order_ID,
    Order_Amount,
    Gift_Card_Amount
FROM 
    Test.dbo.[Gift Card Orders]
WHERE 
    Gift_Card_Amount > Order_Amount * 0.1;
