WITH CustomerInvoiceStats AS (
    SELECT
        Customer_ID,
        AVG(Invoice_Amount) AS AvgInvoiceAmount_Customer,
        ROUND(STDEV(Invoice_Amount), 2) AS StdDevInvoiceAmount_Customer
    FROM
        Test.dbo.Invoices
    GROUP BY
        Customer_ID
),
Outliers_Customer AS (
    SELECT
        i.Customer_ID,
        i.Invoice_ID,
        i.Invoice_Amount,
        ci.AvgInvoiceAmount_Customer,
        ci.StdDevInvoiceAmount_Customer
    FROM
        Test.dbo.Invoices i
        JOIN CustomerInvoiceStats ci ON i.Customer_ID = ci.Customer_ID
    WHERE
        i.Invoice_Amount > ci.AvgInvoiceAmount_Customer + 1.5 * ci.StdDevInvoiceAmount_Customer -- Adjust threshold as needed for customer
        OR i.Invoice_Amount < ci.AvgInvoiceAmount_Customer - 0.5 * ci.StdDevInvoiceAmount_Customer -- Adjust threshold as needed for customer
)
SELECT
    Customer_ID,
    Invoice_ID,
    Invoice_Amount,
    AvgInvoiceAmount_Customer,
    StdDevInvoiceAmount_Customer,
    CASE
        WHEN Invoice_Amount > AvgInvoiceAmount_Customer THEN 'Above Average (Customer)'
        WHEN Invoice_Amount < AvgInvoiceAmount_Customer THEN 'Below Average (Customer)'
    END AS Customer_Deviation_Status
FROM
    Outliers_Customer;
