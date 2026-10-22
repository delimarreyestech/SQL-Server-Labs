
/*
===============================================================================
Lab 02: Building a Date Dimension with GENERATE_SERIES()
File: 02-build-date-dimension.sql

Purpose:
    Create and populate a calendar-based Date Dimension
    using SQL Server's GENERATE_SERIES() function.

Requirements:
    SQL Server 2022+
    Database compatibility level 160

Notes:
    - Uses calendar-year conventions.
    - Weekend calculation is independent of DATEFIRST.
    - Rerunning the script rebuilds the sample dimension.
===============================================================================
*/

DECLARE @StartDate DATE = '2026-01-01',
        @EndDate   DATE = '2026-12-31';

IF @StartDate > @EndDate
    THROW 50001, 'StartDate must not exceed EndDate.', 1;

DROP TABLE IF EXISTS dbo.DimDate;

CREATE TABLE dbo.DimDate
(
    DateKey         INT NOT NULL PRIMARY KEY,
    FullDate        DATE NOT NULL UNIQUE,
    CalendarYear    SMALLINT NOT NULL,
    CalendarQuarter TINYINT NOT NULL,
    MonthNumber     TINYINT NOT NULL,
    DayOfMonth      TINYINT NOT NULL,
    DayOfYear       SMALLINT NOT NULL,
    ISOWeekNumber   TINYINT NOT NULL,
    IsWeekend       BIT NOT NULL
);

INSERT INTO dbo.DimDate
(
    DateKey,
    FullDate,
    CalendarYear,
    CalendarQuarter,
    MonthNumber,
    DayOfMonth,
    DayOfYear,
    ISOWeekNumber,
    IsWeekend
)
SELECT
    YEAR(d.FullDate) * 10000
        + MONTH(d.FullDate) * 100
        + DAY(d.FullDate),

    d.FullDate,
    YEAR(d.FullDate),
    DATEPART(QUARTER, d.FullDate),
    MONTH(d.FullDate),
    DAY(d.FullDate),
    DATEPART(DAYOFYEAR, d.FullDate),
    DATEPART(ISO_WEEK, d.FullDate),

    CASE
        WHEN DATEDIFF(
            DAY,
            CONVERT(DATE, '19000101', 112),
            d.FullDate
        ) % 7 IN (5, 6)
        THEN 1
        ELSE 0
    END
FROM GENERATE_SERIES(
    0,
    DATEDIFF(DAY, @StartDate, @EndDate),
    1
) AS s
CROSS APPLY
(
    VALUES
    (
        CAST(DATEADD(DAY, s.value, @StartDate) AS DATE)
    )
) AS d(FullDate);

-- Validate the generated dimension.
SELECT
    COUNT(*) AS TotalDates,
    MIN(FullDate) AS FirstDate,
    MAX(FullDate) AS LastDate
FROM dbo.DimDate;

-- Preview the first 10 rows.
SELECT TOP (10) *
FROM dbo.DimDate
ORDER BY FullDate;
