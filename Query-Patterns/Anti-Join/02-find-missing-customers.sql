-- Expected: zero rows, even though four customers are missing from CRM.
SELECT s.CustomerID
FROM dbo.LabSalesCustomers AS s
WHERE s.CustomerID NOT IN (SELECT c.CustomerID FROM dbo.LabCRMCustomers AS c);

-- Expected: 104, 106, 108, 110.
SELECT s.CustomerID
FROM dbo.LabSalesCustomers AS s
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.LabCRMCustomers AS c
    WHERE c.CustomerID = s.CustomerID
)
ORDER BY s.CustomerID;
