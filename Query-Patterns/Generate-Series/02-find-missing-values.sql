
/*
===============================================================================
Lab 01: Finding Missing Values with GENERATE_SERIES()
File: 02-find-missing-values.sql

Purpose:
    Identify missing integers within a predefined range.

Approach:
    Generate the expected sequence and compare it against
    the existing values using EXCEPT.

    No CTEs, joins, or subqueries required.

Requirements:
    SQL Server 2022+
    Database compatibility level 160

Prerequisite:
    Execute 01-setup.sql first.
===============================================================================
*/

SELECT value AS MissingValues
FROM GENERATE_SERIES(1, 10, 1)
EXCEPT
SELECT Num
FROM dbo.Numbers
ORDER BY MissingValues;
