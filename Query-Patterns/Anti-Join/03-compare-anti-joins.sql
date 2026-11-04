-- LEFT JOIN anti-join. Check the joined key (not an unrelated nullable column).
SELECT s.CustomerID
FROM dbo.LabSalesCustomers AS s
LEFT JOIN dbo.LabCRMCustomers AS c ON c.CustomerID = s.CustomerID
WHERE c.CustomerID IS NULL
ORDER BY s.CustomerID;

-- NOT IN is safe for this example after removing NULL from the subquery.
SELECT s.CustomerID
FROM dbo.LabSalesCustomers AS s
WHERE s.CustomerID NOT IN (
    SELECT c.CustomerID FROM dbo.LabCRMCustomers AS c
    WHERE c.CustomerID IS NOT NULL
)
ORDER BY s.CustomerID;

-- EXCEPT also returns four IDs here; it applies DISTINCT semantics.
SELECT s.CustomerID FROM dbo.LabSalesCustomers AS s
EXCEPT
SELECT c.CustomerID FROM dbo.LabCRMCustomers AS c;
