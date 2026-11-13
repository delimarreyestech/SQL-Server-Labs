/* Compare each recorded price to the immediately preceding price
   for the same product. The first record is the baseline. */
WITH PriceComparisons AS
(
    SELECT
        PriceHistoryID,
        ProductID,
        ChangeDate,
        Price AS NewPrice,
        LAG(Price) OVER
        (
            PARTITION BY ProductID
            ORDER BY ChangeDate, PriceHistoryID
        ) AS PreviousPrice
    FROM dbo.ProductPriceHistory
)
SELECT
    ProductID,
    ChangeDate,
    PreviousPrice,
    NewPrice,
    CAST(NewPrice - PreviousPrice AS decimal(11,2)) AS Difference
FROM PriceComparisons
WHERE PreviousPrice IS NOT NULL
  AND NewPrice <> PreviousPrice
ORDER BY ProductID, ChangeDate, PriceHistoryID;
