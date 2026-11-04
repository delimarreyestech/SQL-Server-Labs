-- All three safe patterns should return four missing customers.
DECLARE @Expected int = 4;
DECLARE @Actual int;
SELECT @Actual = COUNT(*)
FROM dbo.LabSalesCustomers AS s
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.LabCRMCustomers AS c WHERE c.CustomerID = s.CustomerID
);
IF @Actual <> @Expected THROW 50001, 'Unexpected missing customer count', 1;

-- Demonstrate that NOT IN works once NULLs are excluded.
SELECT @Actual = COUNT(*)
FROM dbo.LabSalesCustomers AS s
WHERE s.CustomerID NOT IN (
    SELECT c.CustomerID FROM dbo.LabCRMCustomers AS c WHERE c.CustomerID IS NOT NULL
);
IF @Actual <> @Expected THROW 50002, 'Unexpected filtered NOT IN count', 1;

-- The test dataset deliberately contains exactly one NULL in CRM.
IF (SELECT COUNT(*) FROM dbo.LabCRMCustomers WHERE CustomerID IS NULL) <> 1
    THROW 50003, 'Expected one NULL in CRM', 1;

PRINT 'All lab checks passed.';
