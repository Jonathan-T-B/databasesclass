import duckdb, time, statistics
con = duckdb.connect()
con.execute("INSTALL sqlite; LOAD sqlite;")
con.execute("ATTACH 'Module05/normalize.db' AS n (TYPE sqlite, READ_ONLY)")
for t in ["machine", "part", "job", "job_part"]:
    con.execute(f"CREATE TABLE {t} AS SELECT * FROM n.{t}")

q = """SELECT m.machine_id, m.site, j.technician, SUM(p.part_price) AS cost
FROM job j JOIN machine m ON m.machine_id=j.machine_id
JOIN job_part jp ON jp.job_id=j.job_id JOIN part p ON p.part_no=jp.part_no
WHERE j.done_on >= '2026-03-01' GROUP BY m.machine_id, m.site, j.technician"""
con.execute(q).fetchall()  # warm-up
times = []
for _ in range(5):
    t = time.perf_counter(); con.execute(q).fetchall()
    times.append((time.perf_counter() - t) * 1000)
print(f"DuckDB 4-way join, median: {statistics.median(times):.1f} ms")