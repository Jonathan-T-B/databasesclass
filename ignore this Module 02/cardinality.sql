.timer on
.headers on
.mode column
.print '--- n_parts per job (m:n hiding in a text column)'
SELECT job_id, parts_used,
       LENGTH(parts_used) - LENGTH(REPLACE(parts_used, ',', '')) + 1 AS n_parts
FROM maint_job;
.print '--- machine -> jobs (1:n)'
SELECT machine_name, COUNT(*) AS jobs FROM maint_job GROUP BY machine_name;
.print '--- technician -> jobs (1:n)'
SELECT technician, COUNT(*) AS jobs FROM maint_job GROUP BY technician;
.print '--- machine key candidates'
SELECT COUNT(*) AS rows_, COUNT(DISTINCT serial_no) AS serials, COUNT(DISTINCT machine_name) AS names FROM machine;
