PRAGMA foreign_keys = ON;
INSERT INTO reading(sensor_id, ts, value, interval_s) VALUES (2,'2026-03-01 09:00:00', 2.7, 1);  -- alarm!
-- I narrowed the WHERE to one row, because sensor 2 now also has the CSV rows
UPDATE reading SET value = 1.4 WHERE sensor_id = 2 AND ts = '2026-03-01 09:00:00';               -- audit!
SELECT * FROM alarm;
SELECT * FROM audit;