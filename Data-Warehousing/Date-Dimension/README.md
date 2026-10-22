# Lab 02 — Date Dimension with GENERATE_SERIES()

## Overview

This lab demonstrates how SQL Server's `GENERATE_SERIES()` function can be used to generate continuous date sequences and build a calendar-based Date Dimension for analytical workloads.

It extends the same sequence-generation technique explored in [Lab 01 — Finding Missing Values](../../Query-Patterns/Generate-Series/).

## Objective

Generate a complete calendar for 2026 and transform it into a Date Dimension containing attributes commonly used in dimensional data models.

## Implementation

**Step 1 — Generate dates**

`01-generate-dates.sql` generates a continuous sequence of dates using `GENERATE_SERIES()`, `DATEDIFF()`, and `DATEADD()`.

**Step 2 — Build the Date Dimension**

`02-build-date-dimension.sql` creates and populates `dbo.DimDate`, including a numeric date key and calendar attributes.

## Dimension Attributes

| Attribute | Description |
|---|---|
| DateKey | Integer key in YYYYMMDD format |
| FullDate | Calendar date |
| CalendarYear | Calendar year |
| CalendarQuarter | Calendar quarter (1–4) |
| MonthNumber | Month number (1–12) |
| DayOfMonth | Day within the month |
| DayOfYear | Day within the year |
| ISOWeekNumber | ISO 8601 week number |
| IsWeekend | Weekend indicator (Saturday/Sunday) |

## Requirements

- SQL Server 2022 or later
- Database compatibility level 160
- Permission to create tables in a test database

## Expected Results

For the range January 1 through December 31, 2026:

- Total rows: 365
- First date: 2026-01-01
- Last date: 2026-12-31
- One row per calendar date

## Technical Considerations

- `GENERATE_SERIES()` generates numeric offsets, which are converted into dates using `DATEADD()`.
- The date range is inclusive of both boundaries.
- The `DateKey` follows the YYYYMMDD convention.
- Weekend logic assumes Saturday and Sunday.
- The script rebuilds `dbo.DimDate` when executed.
- Fiscal calendars, holidays, ISO week-year attributes, and business-specific flags are outside the scope of this introductory implementation.
- Production Date Dimensions may require additional attributes, unknown-member handling, and incremental maintenance strategies.

## Lab Files

| File | Description |
|---|---|
| `01-generate-dates.sql` | Generate a continuous date sequence |
| `02-build-date-dimension.sql` | Create and populate the Date Dimension |

## Key Takeaway

A numeric sequence generator can support more than missing-value detection. Combined with date functions, it provides a concise, set-based foundation for building calendar structures used in data warehousing.
