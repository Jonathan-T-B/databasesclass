def run_duckdb_many():
    con = duckdb.connect()
    con.execute("CREATE TABLE s(id INTEGER PRIMARY KEY, k TEXT, v DOUBLE)")
    rows = [(i, f"k{i}", i * 1.5) for i in range(N)]
    t0 = time.perf_counter()
    con.executemany("INSERT INTO s VALUES (?, ?, ?)", rows)
    return (time.perf_counter() - t0) * 1000

print(f"inserts duckdb executemany {run_duckdb_many():8.1f} ms")