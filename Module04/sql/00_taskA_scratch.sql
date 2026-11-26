-- 1) Unconstrained: everything lands
CREATE TABLE t(sensor_id INTEGER, metric TEXT, value REAL);
INSERT INTO t VALUES (1,'temp_c',9000);
INSERT INTO t VALUES (1,'temp_c','hot');
INSERT INTO t VALUES (2,'bogus',-500);
-- your own creative attempts:
INSERT INTO t VALUES (NULL,NULL,NULL);
INSERT INTO t VALUES ('abc','',1e999);
INSERT INTO t VALUES (3.7,'temp_c','12');
INSERT INTO t VALUES (1,'temp_c',x'ff');
INSERT INTO t VALUES (1,'temp_c',9000);   -- exact duplicate
SELECT rowid, sensor_id, metric, value, typeof(sensor_id) AS t_id, typeof(value) AS t_val FROM t;

-- 2) Constrained version (composite PK is a teaching choice here)
CREATE TABLE t2(
  sensor_id INTEGER NOT NULL,
  metric    TEXT    NOT NULL CHECK (metric IN ('temp_c','vib_rms','spindle_load')),
  value     REAL    CHECK (value BETWEEN -273.15 AND 5000),
  PRIMARY KEY (sensor_id, metric)
) STRICT;

-- run ONE AT A TIME and record error + which layer rejected it
INSERT INTO t2 VALUES (1,'temp_c',9000);
INSERT INTO t2 VALUES (1,'temp_c','hot');
INSERT INTO t2 VALUES (2,'bogus',-500);
INSERT INTO t2 VALUES (NULL,'temp_c',20);
INSERT INTO t2 VALUES (3.7,'temp_c',20);
INSERT INTO t2 VALUES (1,'temp_c','12');      -- surprise?
INSERT INTO t2 VALUES (1,'temp_c',20);        -- ok
INSERT INTO t2 VALUES (1,'temp_c',21);        -- duplicate PK
INSERT INTO t2 VALUES (4,'temp_c',NULL);      -- CHECK + NULL?
INSERT INTO t2 VALUES (5,'vib_rms',4999);     -- plausible but wrong
SELECT * FROM t2;