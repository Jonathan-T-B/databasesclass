PRAGMA foreign_keys = ON;

DROP TRIGGER IF EXISTS trg_vib_alarm;
CREATE TRIGGER trg_vib_alarm
BEFORE INSERT ON reading
FOR EACH ROW
WHEN NEW.value > 2.0 AND (SELECT metric FROM sensor WHERE sensor_id = NEW.sensor_id) = 'vib_rms'
BEGIN
    INSERT INTO alarm(sensor_id, ts, value, reason)
    VALUES (NEW.sensor_id, NEW.ts, NEW.value, 'vibration over 2.0 mm/s (BEFORE)');
END;

SELECT COUNT(*) AS alarms_before FROM alarm;
SELECT COUNT(*) AS readings_before FROM reading;

-- replayed reading: the key already exists, so no new reading row is stored
INSERT INTO reading(sensor_id, ts, value, interval_s)
VALUES (2,'2026-03-01 09:00:00', 3.1, 1)
ON CONFLICT(sensor_id, ts) DO NOTHING;

SELECT COUNT(*) AS alarms_after FROM alarm;
SELECT COUNT(*) AS readings_after FROM reading;