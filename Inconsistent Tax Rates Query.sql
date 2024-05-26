SELECT DISTINCT t1.Product_ID, t1.Order_ID, 
                ROUND(t1.Tax_Rate, 2) AS Tax_Rate, 
                ROUND(ts.Tax_Rate, 2) AS Standard_Tax,
                CASE
                    WHEN ROUND(t1.Tax_Rate, 2) = ROUND(ts.Tax_Rate, 2) THEN 'Okay'
                    ELSE 'Discrepancy'
                END AS Discrepancy_Status
FROM Test.dbo.Tax_1 t1
JOIN Test.dbo.Tax_1 t2 ON t1.Product_ID = t2.Product_ID
JOIN Test.dbo.Tax_S ts ON t1.Product_ID = ts.Product_ID
WHERE t1.Tax_Rate <> t2.Tax_Rate
AND t1.Order_ID <> t2.Order_ID;
