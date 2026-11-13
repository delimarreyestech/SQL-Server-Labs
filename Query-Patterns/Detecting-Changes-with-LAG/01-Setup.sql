/* SQL Pattern #03 — Detecting Changes with LAG()
   Run only in a disposable/test database: replaces dbo.ProductPriceHistory. */
SET NOCOUNT ON;

DROP TABLE IF EXISTS dbo.ProductPriceHistory;
GO
CREATE TABLE dbo.ProductPriceHistory
(
    PriceHistoryID int NOT NULL PRIMARY KEY,
    ProductID int NOT NULL,
    ChangeDate date NOT NULL,
    Price decimal(10,2) NOT NULL
);
GO
INSERT INTO dbo.ProductPriceHistory (PriceHistoryID, ProductID, ChangeDate, Price)
VALUES
(1, 101, '20260105', 100.00),
(2, 101, '20260112', 100.00),
(3, 101, '20260120', 120.00),
(4, 101, '20260203', 110.00),
(5, 101, '20260210', 110.00),
(6, 102, '20260108',  50.00),
(7, 102, '20260115',  65.00),
(8, 102, '20260122',  65.00);

SELECT PriceHistoryID, ProductID, ChangeDate, Price
FROM dbo.ProductPriceHistory
ORDER BY ProductID, ChangeDate, PriceHistoryID;
