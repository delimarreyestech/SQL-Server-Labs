
/*
===============================================================================
Lab 01: Finding Missing Values with GENERATE_SERIES()
File: 03-dynamic-boundaries.sql

Purpose:
    Find missing integers using the actual minimum and maximum
    values stored in the table.

Approach:
    Use scalar subqueries to determine the sequence boundaries.

    No recursive CTEs or joins required.

Prerequisite:
    Execute 01-setup.sql first.

Note:
    This version uses two scalar subqueries.
    An empty table requires additional handling.
===============================================================================
*/

SELECT value AS MissingValues
FROM GENERATE_SERIES(
    (SELECT MIN(Num) FROM dbo.Numbers),
    (SELECT MAX(Num) FROM dbo.Numbers),
    1
)
EXCEPT
SELECT Num
FROM dbo.Numbers
ORDER BY MissingValues;
