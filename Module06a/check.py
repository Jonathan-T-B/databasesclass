# Module06a/check.py: uv run python Module06a/check.py
"""Task 2: do SQLite and Parquet hold the same data?"""
import sqlite3
from pathlib import Path

import duckdb

here = Path(__file__).parent
pq = (here / "report_history.parquet").as_posix()

s = sqlite3.connect(here / "history.db").execute(
    "SELECT COUNT(*), ROUND(SUM(part_price), 2) FROM report_history"
).fetchone()

p = duckdb.connect().execute(
    f"SELECT COUNT(*), ROUND(SUM(part_price), 2) FROM read_parquet('{pq}')"
).fetchone()

print("sqlite :", s)
print("parquet:", p)
print("MATCH" if s[0] == p[0] and abs(s[1] - p[1]) < 0.01 else "MISMATCH")