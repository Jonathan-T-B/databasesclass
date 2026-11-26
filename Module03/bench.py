"""Benchmark: one index at a time -> plan + median time (ms)."""
import sqlite3
import statistics
import time
from pathlib import Path

DB = Path(__file__).with_name("warehouse.db")
if not DB.exists():
    raise SystemExit(f"{DB} not found - run setup.sql first")

conn = sqlite3.connect(DB)
print("Python's SQLite library version:", sqlite3.sqlite_version)

DASHBOARD = """
SELECT c.city, COUNT(DISTINCT c.customer_id) AS customers,
       SUM(ol.qty * p.price) AS revenue
FROM customer c
JOIN orders o      ON o.customer_id = c.customer_id
JOIN order_line ol ON ol.order_id = o.order_id
JOIN product p     ON p.product_id = ol.product_id
WHERE o.ordered_on >= '2025-01-01' AND o.ordered_on < '2026-01-01'
GROUP BY c.city
ORDER BY revenue DESC"""

SINGLE_DAY = """
SELECT o.order_id, o.ordered_on, c.name
FROM orders o JOIN customer c ON c.customer_id = o.customer_id
WHERE o.ordered_on = '2026-02-14'"""

BY_PRODUCT = "SELECT COUNT(*), SUM(qty) FROM order_line WHERE product_id = 42"

WRAPPED = """
SELECT o.order_id, o.ordered_on, c.name
FROM orders o JOIN customer c ON c.customer_id = o.customer_id
WHERE date(o.ordered_on) = '2026-02-14'"""

# name -> (sql, executions per timing sample); fast queries are batched (amortized)
QUERIES = {
    "dashboard":  (DASHBOARD, 1),
    "single_day": (SINGLE_DAY, 200),
    "by_product": (BY_PRODUCT, 200),
    "wrapped_fn": (WRAPPED, 20),
}

STAGES = [
    ("baseline (no index)", None),
    ("+ ix_orders_ordered_on", "CREATE INDEX ix_orders_ordered_on ON orders(ordered_on)"),
    ("+ ix_orderline_order", "CREATE INDEX ix_orderline_order ON order_line(order_id)"),
    ("+ ix_orderline_product", "CREATE INDEX ix_orderline_product ON order_line(product_id)"),
]

def plan(sql):
    return [r[3] for r in conn.execute("EXPLAIN QUERY PLAN " + sql)]

def median_ms(sql, batch, samples=5):
    conn.execute(sql).fetchall()                       # warm-up (file cache), discarded
    times = []
    for _ in range(samples):
        t0 = time.perf_counter()
        for _ in range(batch):
            conn.execute(sql).fetchall()
        times.append((time.perf_counter() - t0) / batch * 1000)
    return statistics.median(times)

for ix in ("ix_orders_ordered_on", "ix_orderline_order", "ix_orderline_product"):
    conn.execute(f"DROP INDEX IF EXISTS {ix}")

table = []
for stage, ddl in STAGES:
    if ddl:
        conn.execute(ddl)
    print(f"\n===== {stage} =====")
    row = [stage]
    for name, (sql, batch) in QUERIES.items():
        ms = median_ms(sql, batch)
        row.append(f"{ms:.3f}")
        print(f"\n[{name}]  median {ms:.3f} ms")
        for line in plan(sql):
            print("   ", line)
    table.append(row)

print("\n\n| stage | " + " | ".join(f"{n} (ms)" for n in QUERIES) + " |")
print("|---|" + "---|" * len(QUERIES))
for r in table:
    print("| " + " | ".join(r) + " |")