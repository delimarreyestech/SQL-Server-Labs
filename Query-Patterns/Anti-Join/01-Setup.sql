-- Run in a sandbox database. SQL Server 2016+.
DROP TABLE IF EXISTS dbo.LabCRMCustomers;
DROP TABLE IF EXISTS dbo.LabSalesCustomers;

CREATE TABLE dbo.LabSalesCustomers (CustomerID int NOT NULL PRIMARY KEY);
CREATE TABLE dbo.LabCRMCustomers (CustomerID int NULL);

INSERT INTO dbo.LabSalesCustomers (CustomerID)
VALUES (101),(102),(103),(104),(105),(106),(107),(108),(109),(110);

INSERT INTO dbo.LabCRMCustomers (CustomerID)
VALUES (101),(102),(103),(105),(107),(109),(NULL);

SELECT * FROM dbo.LabSalesCustomers ORDER BY CustomerID;
SELECT * FROM dbo.LabCRMCustomers ORDER BY CustomerID;
