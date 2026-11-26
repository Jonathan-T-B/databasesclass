import csv
import sqlite3
import sys
from pathlib import Path

DB = Path(__file__).parent / "edge.db"

UPSERT = """
INSERT INTO reading(sensor_id, ts, value, interval_s)
VALUES (?, ?, ?, ?)
ON CONFLICT(sensor_id, ts) DO UPDATE SET value = excluded.value
"""

def main(csv_path: str) -> None:
    conn = sqlite3.connect(DB)
    conn.execute("PRAGMA foreign_keys = ON")  # per connection!
    conn.execute("CREATE UNIQUE INDEX IF NOT EXISTS ux_reading_sensor_ts ON reading(sensor_id, ts)")

    with open(csv_path, newline="", encoding="utf-8") as f:
        rows = [
            (int(r["sensor_id"]), r["ts"], float(r["value"]), int(r["interval_s"]))
            for r in csv.DictReader(f)
        ]

    before = conn.execute("SELECT COUNT(*) FROM reading").fetchone()[0]
    with conn:  # one transaction, commits on success
        conn.executemany(UPSERT, rows)
    after = conn.execute("SELECT COUNT(*) FROM reading").fetchone()[0]
    conn.close()

    print(f"CSV rows: {len(rows)} | rows before: {before} | rows after: {after}")

if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "Module04/data/readings.csv")