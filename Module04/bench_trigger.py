import sqlite3
import time
from datetime import datetime, timedelta
from pathlib import Path

SQL = Path(__file__).parent / "sql"
N = 10_000
BASE = datetime(2026, 3, 2, 0, 0, 0)
ROWS = [
    (2, (BASE + timedelta(seconds=i)).strftime("%Y-%m-%d %H:%M:%S"), 2.5, 1)  # 2.5 > 2.0: trigger fires every row
    for i in range(N)
]

def run(with_trigger: bool) -> float:
    conn = sqlite3.connect(":memory:")
    conn.executescript((SQL / "01_setup.sql").read_text(encoding="utf-8"))
    conn.executescript((SQL / "04_task3_triggers.sql").read_text(encoding="utf-8"))
    conn.execute("INSERT INTO sensor VALUES (2,'cnc-01','vib_rms','mm/s')")
    if not with_trigger:
        conn.execute("DROP TRIGGER trg_vib_alarm")
    conn.commit()
    t0 = time.perf_counter()
    with conn:
        conn.executemany(
            "INSERT INTO reading(sensor_id, ts, value, interval_s) VALUES (?,?,?,?)", ROWS
        )
    dt = time.perf_counter() - t0
    conn.close()
    return dt

for label, flag in (("without trigger", False), ("with alarm trigger", True)):
    best = min(run(flag) for _ in range(5))
    print(f"{label:20s}: {best*1000:8.1f} ms for {N} rows (best of 5)")