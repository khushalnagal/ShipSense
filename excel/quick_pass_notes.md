# Step 1 - Excel Quick Pass Findings

Diagnosis only, no fixing - the raw CSV was opened in Excel to spot issues
before any SQL cleaning was written.

## Row count
25,000 rows total (confirmed via `Ctrl+↓` on column A, since `Ctrl+End`
initially reported an inflated used-range).

## delivery_id
Two corrupted placeholder values found via `COUNTIF(A:A, A2)` helper column
and Highlight Duplicate Values:
- `250.99` - repeated exactly 250 times
- `24750.01` - repeated exactly 250 times
- 500 junk rows total. Every other id (251-24750) was already a clean,
  unique whole number - no complex dedupe logic needed, just filter out
  these two values.

## delivery_time_hours / expected_time_hours
Every single one of the 25,000 rows shows the literal text `00:00.0` in
both columns. Not corrupted-but-recoverable - genuinely no data present.
Both columns dropped entirely rather than cast/fixed.

## delayed (yes/no flag)
6,669 "yes" vs delivery_status showing only 5,341 "delayed" - the two
don't agree. Column dropped in favor of the more reliable delivery_status.

## Nulls
None found in any column.

## delivery_status
Clean, exactly 3 categories:
- delivered - 18,331
- delayed - 5,341
- failed - 1,328

## Outcome
These findings directly shaped the cleaning logic in
`sql/04_clean_and_load.sql` - filter out the two junk delivery_id values,
exclude the two dead time columns and the unreliable delayed flag from
the final table.
