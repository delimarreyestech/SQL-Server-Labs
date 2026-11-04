# Anti-Join: Are we losing customers or failing to track them?

A small, reproducible SQL Server lab exploring missing customer IDs across sales and CRM.

## Business question
Ten customers appear in the sales system. Which customer IDs are missing from the CRM? Missing from CRM **does not mean** lost as a customer; the discrepancy needs investigation.

## Data
- `LabSalesCustomers`: 10 IDs (101–110)
- `LabCRMCustomers`: 7 rows (six matching IDs plus one `NULL`)
- Total: **17 rows**
- Expected missing IDs: **104, 106, 108, 110**

## Run order
1. `01-Setup.sql` — create and populate two lab tables.
2. `02-find-missing-customers.sql` — reproduce the `NOT IN`/`NULL` trap, then fix with `NOT EXISTS`.
3. `03-compare-anti-joins.sql` — compare `LEFT JOIN`, filtered `NOT IN`, and `EXCEPT`.
4. `04-test-cases.sql` — verify the expected count and the intentional `NULL`.

Use a sandbox database: setup drops and recreates the two `Lab*` tables.

## Why does `NOT IN` return no rows?
`NOT IN` evaluates comparisons against every returned value. When the subquery includes `NULL`, the comparisons for otherwise missing IDs become `UNKNOWN`, which the `WHERE` clause does not retain. `NOT EXISTS` checks for a matching row and does not suffer this particular trap.

## What about performance?
With 17 rows, elapsed-time benchmarks are not meaningful. Use **actual execution plans** to inspect whether SQL Server chooses a Left Anti Semi Join and note how nullable columns, indexes, and query shapes influence plans. No universal speed ranking is claimed.

## Important nuances
- The left-side `CustomerID` is non-null in this lab. Nullable left-side keys require extra consideration.
- `EXCEPT` removes duplicates and treats two NULL values as equal for set comparison; it is not always interchangeable with the other forms.
- The sample data is synthetic. No real customers or lost revenue are implied.
