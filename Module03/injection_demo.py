"""Demonstrate SQL injection and its one correct fix: bound parameters."""
import sqlite3
from pathlib import Path

DB = Path(__file__).with_name("warehouse.db")
if not DB.exists():
    raise SystemExit(f"{DB} not found - run the Module 3 setup first")

conn = sqlite3.connect(DB)

def vulnerable(name: str):
    """DON'T DO THIS. String-building the query is the bug."""
    sql = f"SELECT customer_id, name FROM customer WHERE name = '{name}'"
    return conn.execute(sql).fetchall()

def safe(name: str):
    """DO THIS. The value can never be parsed as SQL."""
    sql = "SELECT customer_id, name FROM customer WHERE name = ?"
    return conn.execute(sql, (name,)).fetchall()

if __name__ == "__main__":
    print("normal    :", vulnerable("Customer 1"))
    for label, payload in [("apostrophe", "O'Brien"), ("injected", "' OR '1'='1")]:
        try:
            rows = vulnerable(payload)
            print(f"{label:<10}: returned {len(rows)} rows, first 3 -> {rows[:3]}")
        except sqlite3.Error as e:
            print(f"{label:<10}: crashed with {e!r}")
    try:
        vulnerable("x'; DROP TABLE customer; --")
    except sqlite3.Error as e:
        print("stacked   : driver refused ->", e)
    print("safe      :", safe("' OR '1'='1"), safe("O'Brien"))