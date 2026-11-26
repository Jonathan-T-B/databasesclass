.headers on
.mode column
.changes on
DROP TABLE IF EXISTS flat5;
CREATE TABLE flat5(job_id INTEGER, machine_id TEXT, site TEXT,
                   technician TEXT, part_no TEXT, part_price REAL);
INSERT INTO flat5 VALUES
  (1,'cnc-01','Gütersloh','tech-0','P-0001',6.00),
  (1,'cnc-01','Gütersloh','tech-0','P-0002',7.00),
  (2,'cnc-02','Gütersloh','tech-1','P-0001',6.00),
  (2,'cnc-02','Gütersloh','tech-1','P-0003',8.50),
  (3,'cnc-01','Gütersloh','tech-0','P-0003',8.50);

-- UPDATE anomaly: moving cnc-01 touches 3 rows
UPDATE flat5 SET site='Bielefeld' WHERE machine_id='cnc-01';
-- a second session that only fixes "its" row leaves the facts disagreeing:
UPDATE flat5 SET site='Rheda' WHERE job_id=3;
SELECT job_id, machine_id, site FROM flat5 WHERE machine_id='cnc-01';

-- INSERT anomaly: a part nobody used yet forces NULL job/machine columns
INSERT INTO flat5(part_no, part_price) VALUES ('P-0004', 9.00);
SELECT * FROM flat5 WHERE part_no='P-0004';

-- DELETE anomaly: job 1 is the only user of P-0002
DELETE FROM flat5 WHERE job_id=1;
SELECT * FROM flat5 WHERE part_no='P-0002';   -- empty: price 7.00 is gone