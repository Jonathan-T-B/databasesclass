**To:** Lea Winter, Yasmin Kaya  **Re:** Moving the month-end report off SQLite

The month-end/historical report moves to a Parquet copy queried with DuckDB; the operational
database stays in SQLite for writes and single-job lookups. On 2M rows the dashboard query
went from ___ ms to ___ ms (___x) and the monthly report from ___ ms to ___ ms (median of 5
interleaved runs); the Parquet file is ___ MB versus ___ MB for the database. The copy is
refreshed by `refresh.py` after the night shift, which also checks row count and SUM(part_price)
against SQLite. If it goes stale, the report shows yesterday's numbers; ___ . I would not move
the job-entry workload: DuckDB needed ___ ms for 1,000 inserts vs ___ ms in SQLite.