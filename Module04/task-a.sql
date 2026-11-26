.headers on
.print '=== PART 1: UNCONSTRAINED TABLE ==='
CREATE TABLE t(sensor_id INTEGER, metric TEXT, value REAL);
INSERT INTO t VALUES (1,'temp_c',9000), (1,'temp_c','hot'), (2,'bogus',-500);
-- my own attempts to break it:
INSERT INTO t VALUES (NULL, NULL, NULL);
INSERT INTO t VALUES ('abc', 42, 'x');
INSERT INTO t VALUES (1,'temp_c',1e999);
INSERT INTO t VALUES (1,'temp_c',x'DEADBEEF');
INSERT INTO t VALUES (1,'temp_c','41.5');
INSERT INTO t VALUES (1,'temp_c','');
INSERT INTO t VALUES (1,'temp_c',41.5), (1,'temp_c',41.5);
INSERT INTO t(sensor_id) VALUES (99999999999999);
SELECT rowid, sensor_id, typeof(sensor_id) AS t_id, metric, typeof(metric) AS t_m,
       value, typeof(value) AS t_v FROM t;

.print ''
.print '=== PART 2: CONSTRAINED TABLE (one statement at a time) ==='
CREATE TABLE t2(
  sensor_id INTEGER NOT NULL,
  metric    TEXT    NOT NULL CHECK (metric IN ('temp_c','vib_rms','spindle_load')),
  ts        TEXT    NOT NULL,
  value     REAL    CHECK (value BETWEEN -273.15 AND 5000),
  PRIMARY KEY (sensor_id, metric, ts)
) STRICT;

.print '--- ok: valid row'
INSERT INTO t2 VALUES (1,'temp_c','2026-03-01 08:00:00', 41.5);
.print '--- 9000 degC'
INSERT INTO t2 VALUES (1,'temp_c','2026-03-01 08:00:01', 9000);
.print '--- text "hot" into REAL'
INSERT INTO t2 VALUES (1,'temp_c','2026-03-01 08:00:02', 'hot');
.print '--- metric "bogus", -500'
INSERT INTO t2 VALUES (2,'bogus','2026-03-01 08:00:03', -500);
.print '--- NULL sensor_id'
INSERT INTO t2 VALUES (NULL,'temp_c','2026-03-01 08:00:04', 1);
.print '--- duplicate key'
INSERT INTO t2 VALUES (1,'temp_c','2026-03-01 08:00:00', 42);
.print '--- text "41.5" (numeric-looking) into REAL'
INSERT INTO t2 VALUES (1,'temp_c','2026-03-01 08:00:05', '41.5');
.print '--- 1e999 (infinity)'
INSERT INTO t2 VALUES (1,'temp_c','2026-03-01 08:00:06', 1e999);
.print '--- empty string into REAL'
INSERT INTO t2 VALUES (1,'temp_c','2026-03-01 08:00:07', '');
.print '--- follow-up 1: NULL value (CHECK with NULL)'
INSERT INTO t2 VALUES (1,'temp_c','2026-03-01 08:00:08', NULL);
.print '--- follow-up 2: plausible but WRONG values that still get in'
INSERT INTO t2 VALUES (1,'temp_c','2026-03-01 08:00:09', 4999);
INSERT INTO t2 VALUES (1,'temp_c','not a timestamp', 20);
INSERT INTO t2 VALUES (1,'vib_rms','2026-03-01 08:00:10', 300);
INSERT INTO t2 VALUES (99999,'temp_c','2026-03-01 08:00:11', 20);
SELECT rowid, sensor_id, metric, ts, value, typeof(value) AS type FROM t2;