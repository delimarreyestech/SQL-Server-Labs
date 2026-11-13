# SQL Pattern #03 — Detecting Changes with LAG()

**SQL Server 2012+ · Intermediate · Window Functions**

## Business question
A product price-history table contains new observations, but not every observation represents a price change. Which prices actually changed, what was the previous price, and by how much did the value increase or decrease?

This small, reproducible example uses **2 products and 8 records**, with **3 actual changes**.

## Files
| File | Purpose |
| --- | --- |
| `01-Setup.sql` | Recreates `dbo.ProductPriceHistory` and inserts eight sample rows. |
| `02-detect-price-changes.sql` | Uses `LAG()` to compare consecutive prices per product. |
| `03-test-cases.sql` | Checks the sample counts and expected change values. |

## Run
1. Connect to a **test database** in SQL Server 2012 or later.
2. Execute `01-Setup.sql`.
3. Execute `02-detect-price-changes.sql` to inspect the result.
4. Execute `03-test-cases.sql` to check the expected output.

> **Warning:** `01-Setup.sql` drops and recreates `dbo.ProductPriceHistory`. Do not run it in a database containing a table you need to preserve.

## Key pattern
```sql
LAG(Price) OVER (
    PARTITION BY ProductID
    ORDER BY ChangeDate, PriceHistoryID
)
```

- `PARTITION BY ProductID` prevents comparisons between products.
- `ORDER BY ChangeDate, PriceHistoryID` defines a deterministic order, even when dates tie. `PriceHistoryID` is unique in this example.
- The first record for each product returns `NULL` from `LAG()` and is treated as its initial state.
- Rows with unchanged prices are excluded. This example assumes non-null prices.

## Expected output
| ProductID | ChangeDate | PreviousPrice | NewPrice | Difference |
| --- | --- | ---: | ---: | ---: |
| 101 | 2026-01-20 | 100.00 | 120.00 | +20.00 |
| 101 | 2026-02-03 | 120.00 | 110.00 | -10.00 |
| 102 | 2026-01-15 | 50.00 | 65.00 | +15.00 |

The output is derived from the sample data; the scripts have **not** been executed against a SQL Server instance in this environment.

## Where else this applies
The same pattern can identify changes in order status, inventory levels, or other sequential observations. Define the entity partition, chronological ordering, and initial-state rule for each use case.

**Note:** This example demonstrates query logic, not a performance comparison with self-joins.
