WITH ProductInvoiceStats AS (
    SELECT
        Product_ID,
        AVG(Invoice_Amount) AS AvgInvoiceAmount_Product,
        ROUND(STDEV(Invoice_Amount), 2) AS StdDevInvoiceAmount_Product
    FROM
        Test.dbo.Invoices
    GROUP BY
        Product_ID
),
Outliers_Product AS (
    SELECT
        i.Product_ID,
        i.Invoice_ID,
        i.Invoice_Amount,
        pi.AvgInvoiceAmount_Product,
        pi.StdDevInvoiceAmount_Product
    FROM
        Test.dbo.Invoices i
        JOIN ProductInvoiceStats pi ON i.Product_ID = pi.Product_ID
    WHERE
        i.Invoice_Amount > pi.AvgInvoiceAmount_Product + 1.5 * pi.StdDevInvoiceAmount_Product -- Adjust threshold as needed for product
        OR i.Invoice_Amount < pi.AvgInvoiceAmount_Product - 0.5 * pi.StdDevInvoiceAmount_Product -- Adjust threshold as needed for product
)
SELECT
    Product_ID,
    Invoice_ID,
    Invoice_Amount,
    AvgInvoiceAmount_Product,
    StdDevInvoiceAmount_Product,
    CASE
        WHEN Invoice_Amount > AvgInvoiceAmount_Product THEN 'Above Average (Product)'
        WHEN Invoice_Amount < AvgInvoiceAmount_Product THEN 'Below Average (Product)'
    END AS Product_Deviation_Status
FROM
    Outliers_Product;
