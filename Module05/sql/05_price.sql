.headers on
.mode column
.changes on
.timer on
-- run once; "changes:" shows rows touched (expect 1 vs 4000)
UPDATE machine        SET site = 'Bielefeld' WHERE machine_id = 'cnc-02';
UPDATE report_jobpart SET site = 'Bielefeld' WHERE machine_id = 'cnc-02';
.timer off
.changes off

SELECT 'normalized' AS design,
       SUM(pgsize)/1024.0 AS kb FROM dbstat WHERE name IN ('job','job_part','part','machine');
SELECT 'denormalized' AS design,
       SUM(pgsize)/1024.0 AS kb FROM dbstat WHERE name = 'report_jobpart';