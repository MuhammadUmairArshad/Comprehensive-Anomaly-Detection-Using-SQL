WITH changes AS (
    SELECT
        Item,
        Date,
        Quantity,
        LAG(Quantity) OVER (PARTITION BY Item ORDER BY Date) AS prev_quantity
    FROM
        Test.dbo.[Inventory Changes.xlsx]
),
deviation_changes AS (
    SELECT
        Item,
        Date,
        Quantity,
        prev_quantity,
        FORMAT(((CAST(Quantity AS DECIMAL) - CAST(prev_quantity AS DECIMAL)) / NULLIF(CAST(prev_quantity AS DECIMAL), 0)) * 100, '+0.##;-0.##') AS deviation_percentage
    FROM
        changes
    WHERE
        prev_quantity IS NOT NULL
)
SELECT
    Item,
    Date,
    Quantity,
    prev_quantity AS Prev_Quantity,
    CAST(deviation_percentage AS DECIMAL(18, 2)) AS Deviation_Percentage
FROM
    deviation_changes
WHERE
    ABS(CAST(deviation_percentage AS DECIMAL(18, 2))) > 50;
