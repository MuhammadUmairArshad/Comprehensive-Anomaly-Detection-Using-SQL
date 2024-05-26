WITH RefundSummary AS (
    SELECT
        Order_ID,
        COUNT(*) AS Refund_Count,
        SUM(Refund_Amount) AS Total_Refund_Amount
    FROM
        Test.dbo.Refunds
    GROUP BY
        Order_ID
)
SELECT
    Order_ID,
    Refund_Count,
    Total_Refund_Amount,
    Refund_Status
FROM
    (SELECT
        Order_ID,
        Refund_Count,
        Total_Refund_Amount,
        CASE
            WHEN Refund_Count > (SELECT AVG(Refund_Count) * 2 FROM RefundSummary) THEN 'High Refund Frequency'
            WHEN Total_Refund_Amount > (SELECT AVG(Total_Refund_Amount) * 2 FROM RefundSummary) THEN 'Abnormally High Refund Amount'
        END AS Refund_Status
    FROM
        RefundSummary) AS Subquery
WHERE
    Refund_Status IS NOT NULL;
