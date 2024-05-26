WITH CalculatedSalesTax AS (
    SELECT 
        t1.Order_ID,
        ROUND(SUM(t1.Order_Amount * t2.Tax_Rate), 2) AS CalculatedTax
    FROM Test.dbo.Tax_1 t1
    JOIN Test.dbo.Tax_S t2 ON t1.Product_ID = t2.Product_ID
    GROUP BY t1.Order_ID
),
ActualSalesTax AS (
    SELECT 
        Order_ID,
        ROUND(SUM(Sales_Tax), 2) AS ActualTax
    FROM Test.dbo.Tax_1
    GROUP BY Order_ID
)
SELECT 
    t.Order_ID,
    t.Customer_ID,
    ROUND(t.Order_Amount, 2) AS Order_Amount,
    c.CalculatedTax AS Standard_Tax, -- Changed alias here
    a.ActualTax,
    CASE
        WHEN c.CalculatedTax != a.ActualTax THEN 'Discrepancy'
        ELSE 'No Discrepancy'
    END AS DiscrepancyStatus
FROM Test.dbo.Tax_1 t
JOIN CalculatedSalesTax c ON t.Order_ID = c.Order_ID
JOIN ActualSalesTax a ON t.Order_ID = a.Order_ID
WHERE ABS(c.CalculatedTax - a.ActualTax) > 0.01 OR c.CalculatedTax != a.ActualTax;
