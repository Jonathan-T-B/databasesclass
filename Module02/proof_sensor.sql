PRAGMA foreign_keys = ON;
.headers on
.mode column

CREATE TABLE machine (
  machine_id INTEGER PRIMARY KEY,
  serial_no  TEXT NOT NULL UNIQUE
);

CREATE TABLE sensor (
  sensor_id  INTEGER PRIMARY KEY,
  machine_id INTEGER NOT NULL REFERENCES machine(machine_id),
  kind       TEXT NOT NULL
);

INSERT INTO machine VALUES (1, 'SN-1');
INSERT INTO sensor  VALUES (1, 1, 'temperature'), (2, 1, 'vibration');

.print '--- COUNT: sensors per machine (1 machine, 2 sensors = 1:n)'
SELECT machine_id, COUNT(*) AS sensors FROM sensor GROUP BY machine_id;

.print '--- COUNT: machines per sensor (never more than 1)'
SELECT sensor_id, COUNT(DISTINCT machine_id) AS machines FROM sensor GROUP BY sensor_id;

.print '--- Negative test: a sensor for a machine that does not exist must be rejected'
INSERT INTO sensor VALUES (3, 99, 'pressure');