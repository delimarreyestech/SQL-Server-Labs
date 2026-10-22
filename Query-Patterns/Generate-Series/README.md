# Lab 01 — Finding Missing Values with GENERATE_SERIES()

## Overview

This lab explores how to identify missing integers in SQL Server using `GENERATE_SERIES()` and the `EXCEPT` operator.

The exercise starts with a simple sequence of numbers and evolves into a dynamic solution that determines its boundaries directly from the source data.

The objective is to demonstrate a concise, set-based approach without recursive CTEs or auxiliary numbers tables.

## The Problem

Consider a table containing the following values:

| Num |
|---|
| 1 |
| 2 |
| 3 |
| 4 |
| 5 |
| 10 |

The goal is to identify all missing integers between the minimum and maximum values.

**Expected result:** `6, 7, 8, 9`

## Approach 1 — Fixed Boundaries

The first solution uses `GENERATE_SERIES()` to produce a complete numeric sequence and `EXCEPT` to identify values that are not present in the source table.

```sql
SELECT value AS MissingValues
FROM GENERATE_SERIES(1, 10, 1)
EXCEPT
SELECT Num FROM dbo.Numbers
ORDER BY MissingValues;
```

This approach requires no CTEs, joins, or subqueries.

However, the boundaries are hardcoded, making it less flexible when the source data changes.

## Approach 2 — Dynamic Boundaries

The second solution calculates the minimum and maximum values directly from the table.

```sql
SELECT value AS MissingValues
FROM GENERATE_SERIES(
    (SELECT MIN(Num) FROM dbo.Numbers),
    (SELECT MAX(Num) FROM dbo.Numbers),
    1
)
EXCEPT
SELECT Num FROM dbo.Numbers
ORDER BY MissingValues;
```

This removes the need to manually define the sequence boundaries.

Unlike the first solution, this version uses two scalar subqueries.

## Technical Considerations

- `GENERATE_SERIES()` is supported in SQL Server 2022 and later and requires database compatibility level 160.
- `EXCEPT` returns distinct values from the first result set that do not appear in the second.
- The dynamic approach assumes a nonempty source table.
- Generating large sequences can introduce performance and resource considerations.
- The queries identify missing integer values, not duplicate occurrences.

## Lab Files

| File | Description |
|---|---|
| `01-setup.sql` | Creates and populates the sample dataset |
| `02-find-missing-values.sql` | Finds missing values using fixed boundaries |
| `03-dynamic-boundaries.sql` | Uses dynamic minimum and maximum values |
| `04-test-cases.sql` | Validates the solution against different scenarios |

## How to Run

1. Use SQL Server 2022 or later with database compatibility level 160.
2. Run `01-setup.sql` in a test database.
3. Execute `02-find-missing-values.sql`.
4. Execute `03-dynamic-boundaries.sql`.
5. Run `04-test-cases.sql` to inspect the additional scenarios.

Both main queries should return:

```text
MissingValues
-------------
6
7
8
9
```

## Beyond Missing Values

The same sequence-generation technique can be applied to other scenarios, including date generation.

For example, combining `GENERATE_SERIES()` with `DATEADD()` allows us to generate a continuous range of dates that can serve as the foundation for a Date Dimension.

This application is explored separately under the Data Warehousing section of the repository.
