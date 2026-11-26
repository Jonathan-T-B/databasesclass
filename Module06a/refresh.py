# Module06a/refresh.py — uv run python Module06a/refresh.py [--check]
"""Rebuild report_history.parquet from history.db; --check compares both sides."""
import argparse
import sqlite3
import sys
import time
from pathlib import Path

import duckdb

here = Path(__file__).parent
db = here / "history.db"
parquet = here / "report_history.parquet"


def sqlite_stats():
    con = sqlite3.connect(db)
    r = con.execute("SELECT COUNT(*), ROUND(SUM(part_price), 2) FROM report_history").fetchone()
    con.close()
    return r


def parquet_stats():
    con = duckdb.connect()
    return con.execute(
        f"SELECT COUNT(*), ROUND(SUM(part_price), 2) FROM read_parquet('{parquet.as_posix()}')"
    ).fetchone()


def rebuild():
    con = duckdb.connect()
    con.execute("INSTALL sqlite; LOAD sqlite;")   # needs internet once
    con.execute(f"ATTACH '{db.as_posix()}' AS src (TYPE sqlite, READ_ONLY)")
    con.execute(f"COPY (SELECT * FROM src.report_history) TO '{parquet.as_posix()}' (FORMAT parquet)")


ap = argparse.ArgumentParser()
ap.add_argument("--check", action="store_true", help="compare SQLite and Parquet, exit 1 on mismatch")
args = ap.parse_args()

if args.check:
    s, p = sqlite_stats(), parquet_stats()
    print(f"sqlite : rows={s[0]} sum={s[1]}")
    print(f"parquet: rows={p[0]} sum={p[1]}")
    sys.exit(0 if s[0] == p[0] and abs(s[1] - p[1]) < 0.01 else 1)

t0 = time.perf_counter()
rebuild()
ms = (time.perf_counter() - t0) * 1000
rows, total = parquet_stats()
print(f"rows={rows} checksum={total} parquet={parquet.stat().st_size/1e6:.2f} MB elapsed={ms:.0f} ms")