/* Execute after 01-Setup.sql. Assertions throw an error if results differ. */
SET NOCOUNT ON;

IF (SELECT COUNT(*) FROM dbo.ProductPriceHistory) <> 8
    THROW 50001, 'Expected exactly eight source records.', 1;

IF (SELECT COUNT(DISTINCT ProductID) FROM dbo.ProductPriceHistory) <> 2
    THROW 50002, 'Expected exactly two products.', 1;

;WITH PriceComparisons AS
(
    SELECT PriceHistoryID, ProductID, ChangeDate, Price AS NewPrice,
           LAG(Price) OVER
           (PARTITION BY ProductID ORDER BY ChangeDate, PriceHistoryID) AS PreviousPrice
    FROM dbo.ProductPriceHistory
),
Actual AS
(
    SELECT ProductID, ChangeDate, PreviousPrice, NewPrice,
           CAST(NewPrice - PreviousPrice AS decimal(11,2)) AS Difference
    FROM PriceComparisons
    WHERE PreviousPrice IS NOT NULL AND NewPrice <> PreviousPrice
),
Expected AS
(
    SELECT * FROM (VALUES
        (101, CONVERT(date,'20260120'), CONVERT(decimal(10,2),100), CONVERT(decimal(10,2),120), CONVERT(decimal(11,2),20)),
        (101, CONVERT(date,'20260203'), CONVERT(decimal(10,2),120), CONVERT(decimal(10,2),110), CONVERT(decimal(11,2),-10)),
        (102, CONVERT(date,'20260115'), CONVERT(decimal(10,2),50), CONVERT(decimal(10,2),65), CONVERT(decimal(11,2),15))
    ) AS v(ProductID, ChangeDate, PreviousPrice, NewPrice, Difference)
)
SELECT * INTO #Actual FROM Actual;

IF (SELECT COUNT(*) FROM #Actual) <> 3
    THROW 50003, 'Expected exactly three price changes.', 1;

IF EXISTS
(
    SELECT * FROM #Actual
    EXCEPT
    SELECT * FROM (VALUES
        (101, CONVERT(date,'20260120'), CONVERT(decimal(10,2),100), CONVERT(decimal(10,2),120), CONVERT(decimal(11,2),20)),
        (101, CONVERT(date,'20260203'), CONVERT(decimal(10,2),120), CONVERT(decimal(10,2),110), CONVERT(decimal(11,2),-10)),
        (102, CONVERT(date,'20260115'), CONVERT(decimal(10,2),50), CONVERT(decimal(10,2),65), CONVERT(decimal(11,2),15))
    ) AS v(ProductID, ChangeDate, PreviousPrice, NewPrice, Difference)
)
    THROW 50004, 'Unexpected change values.', 1;

PRINT 'PASS: 8 records, 2 products, 3 expected changes.';
SELECT * FROM #Actual ORDER BY ProductID, ChangeDate;
DROP TABLE #Actual;
