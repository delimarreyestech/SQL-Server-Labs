
/*
===============================================================================
Lab 01: Finding Missing Values with GENERATE_SERIES()
File: 04-test-cases.sql

Purpose:
    Validate missing-value detection under different scenarios.

Test cases:
    1. Sequence with missing values
    2. Complete sequence
    3. Single-value sequence

Requirements:
    SQL Server 2022+
    Database compatibility level 160

Note:
    Tests use a table variable and do not modify dbo.Numbers.
===============================================================================
*/

DECLARE @TestNumbers TABLE
(
    Num INT PRIMARY KEY
);

-------------------------------------------------------
-- Test 1: Sequence with missing values
-- Expected: 6, 7, 8, 9
-------------------------------------------------------

INSERT INTO @TestNumbers (Num)
VALUES (1), (2), (3), (4), (5), (10);

SELECT 'Test 1 - Missing Values' AS TestCase,
       value AS MissingValue
FROM GENERATE_SERIES(1, 10, 1)

EXCEPT

SELECT 'Test 1 - Missing Values',
       Num
FROM @TestNumbers;

-------------------------------------------------------
-- Test 2: Complete sequence
-- Expected: No rows
-------------------------------------------------------

DELETE FROM @TestNumbers;

INSERT INTO @TestNumbers (Num)
VALUES (1), (2), (3), (4), (5);

SELECT 'Test 2 - Complete Sequence' AS TestCase,
       value AS MissingValue
FROM GENERATE_SERIES(1, 5, 1)

EXCEPT

SELECT 'Test 2 - Complete Sequence',
       Num
FROM @TestNumbers;

-------------------------------------------------------
-- Test 3: Single-value sequence
-- Expected: No rows
-------------------------------------------------------

DELETE FROM @TestNumbers;

INSERT INTO @TestNumbers (Num)
VALUES (5);

SELECT 'Test 3 - Single Value' AS TestCase,
       value AS MissingValue
FROM GENERATE_SERIES(5, 5, 1)
EXCEPT
SELECT 'Test 3 - Single Value',
       Num
FROM @TestNumbers;
