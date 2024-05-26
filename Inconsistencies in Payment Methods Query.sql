WITH PaymentCounts AS (
    SELECT
        Customer_ID,
        COUNT(DISTINCT Payment_Method) AS NumPaymentMethods,
        COUNT(DISTINCT Order_ID) AS NumOrders
    FROM
        Test.dbo.Payments
    GROUP BY
        Customer_ID
)
SELECT
    Customer_ID,
    NumPaymentMethods,
    NumOrders
FROM
    PaymentCounts
WHERE
    NumPaymentMethods > 1
    AND NumOrders > 1; -- Filter for customers with different payment methods in different orders
