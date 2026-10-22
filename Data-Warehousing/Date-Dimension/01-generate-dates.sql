
/*
===============================================================================
Lab 02: Date Generation with GENERATE_SERIES()
File: 01-generate-dates.sql

Purpose:
    Generate a continuous date sequence using SQL Server's
    GENERATE_SERIES() function.

Requirements:
    SQL Server 2022+
    Database compatibility level 160

Expected result:
    365 dates, from 2026-01-01 through 2026-12-31.
===============================================================================
*/

DECLARE @StartDate DATE = '2026-01-01',
        @EndDate   DATE = '2026-12-31';

SELECT
    CAST(DATEADD(DAY, value, @StartDate) AS DATE) AS CalendarDate
FROM GENERATE_SERIES(
    0,
    DATEDIFF(DAY, @StartDate, @EndDate),
    1
)
ORDER BY CalendarDate;
