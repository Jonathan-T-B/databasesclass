.timer off
-- warm-up, throw these numbers away
SELECT COUNT(*) FROM (SELECT m.machine_id, m.site, j.technician, SUM(p.part_price) AS cost
  FROM job j JOIN machine m ON m.machine_id=j.machine_id JOIN job_part jp ON jp.job_id=j.job_id
  JOIN part p ON p.part_no=jp.part_no WHERE j.done_on >= date('2026-03-01')
  GROUP BY m.machine_id, j.technician);
SELECT COUNT(*) FROM (SELECT machine_id, site, technician, SUM(part_price) AS cost
  FROM report_jobpart WHERE done_on >= date('2026-03-01') GROUP BY machine_id, technician);

.timer on
-- repeat A,B three times and take the medians
SELECT 'A' AS q, COUNT(*) FROM (SELECT m.machine_id, m.site, j.technician, SUM(p.part_price) AS cost
  FROM job j JOIN machine m ON m.machine_id=j.machine_id JOIN job_part jp ON jp.job_id=j.job_id
  JOIN part p ON p.part_no=jp.part_no WHERE j.done_on >= date('2026-03-01')
  GROUP BY m.machine_id, j.technician);
SELECT 'B' AS q, COUNT(*) FROM (SELECT machine_id, site, technician, SUM(part_price) AS cost
  FROM report_jobpart WHERE done_on >= date('2026-03-01') GROUP BY machine_id, technician);
SELECT 'A' AS q, COUNT(*) FROM (SELECT m.machine_id, m.site, j.technician, SUM(p.part_price) AS cost
  FROM job j JOIN machine m ON m.machine_id=j.machine_id JOIN job_part jp ON jp.job_id=j.job_id
  JOIN part p ON p.part_no=jp.part_no WHERE j.done_on >= date('2026-03-01')
  GROUP BY m.machine_id, j.technician);
SELECT 'B' AS q, COUNT(*) FROM (SELECT machine_id, site, technician, SUM(part_price) AS cost
  FROM report_jobpart WHERE done_on >= date('2026-03-01') GROUP BY machine_id, technician);
SELECT 'A' AS q, COUNT(*) FROM (SELECT m.machine_id, m.site, j.technician, SUM(p.part_price) AS cost
  FROM job j JOIN machine m ON m.machine_id=j.machine_id JOIN job_part jp ON jp.job_id=j.job_id
  JOIN part p ON p.part_no=jp.part_no WHERE j.done_on >= date('2026-03-01')
  GROUP BY m.machine_id, j.technician);
SELECT 'B' AS q, COUNT(*) FROM (SELECT machine_id, site, technician, SUM(part_price) AS cost
  FROM report_jobpart WHERE done_on >= date('2026-03-01') GROUP BY machine_id, technician);

.timer off
.print '--- PLAN A ---'
EXPLAIN QUERY PLAN SELECT m.machine_id, m.site, j.technician, SUM(p.part_price)
  FROM job j JOIN machine m ON m.machine_id=j.machine_id JOIN job_part jp ON jp.job_id=j.job_id
  JOIN part p ON p.part_no=jp.part_no WHERE j.done_on >= date('2026-03-01')
  GROUP BY m.machine_id, j.technician;
.print '--- PLAN B ---'
EXPLAIN QUERY PLAN SELECT machine_id, site, technician, SUM(part_price)
  FROM report_jobpart WHERE done_on >= date('2026-03-01') GROUP BY machine_id, technician;