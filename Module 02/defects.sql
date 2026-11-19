.timer on
.headers on
.mode column

.print '--- Defect 1: orphan maintenance jobs (machine_name not in machine)'
SELECT m.job_id, m.machine_name
FROM maint_job m
LEFT JOIN machine x ON m.machine_name = x.machine_name
WHERE x.machine_name IS NULL;

.print '--- Defect 2: duplicate natural keys in part'
SELECT part_no, COUNT(*) AS copies
FROM part GROUP BY part_no HAVING COUNT(*) > 1;

.print '--- Defect 3: unit_price stored as text (text ordering, not money)'
SELECT part_no, unit_price FROM part WHERE unit_price < '15';

.print '--- Defect 3 contrast: the same filter with a numeric cast'
SELECT part_no, unit_price FROM part WHERE CAST(unit_price AS REAL) < 15;

.print '--- Defect 4: installed dates that are not dates'
SELECT machine_name, installed FROM machine
WHERE installed NOT GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]';

.print '--- Defect 5: the m:n list only joins when it holds exactly one part'
SELECT j.job_id, p.description
FROM maint_job j
JOIN part p ON p.part_no = j.parts_used;

.print '--- Defect 5 contrast: jobs that have parts vs jobs the join found'
SELECT (SELECT COUNT(*) FROM maint_job WHERE parts_used IS NOT NULL) AS jobs_with_parts,
       (SELECT COUNT(DISTINCT j.job_id) FROM maint_job j
        JOIN part p ON p.part_no = j.parts_used) AS jobs_found_by_join;.timer on
.headers on
.mode column

.print '--- Defect 1: orphan maintenance jobs (machine_name not in machine)'
SELECT m.job_id, m.machine_name
FROM maint_job m
LEFT JOIN machine x ON m.machine_name = x.machine_name
WHERE x.machine_name IS NULL;

.print '--- Defect 2: duplicate natural keys in part'
SELECT part_no, COUNT(*) AS copies
FROM part GROUP BY part_no HAVING COUNT(*) > 1;

.print '--- Defect 3: unit_price stored as text (text ordering, not money)'
SELECT part_no, unit_price FROM part WHERE unit_price < '15';

.print '--- Defect 3 contrast: the same filter with a numeric cast'
SELECT part_no, unit_price FROM part WHERE CAST(unit_price AS REAL) < 15;

.print '--- Defect 4: installed dates that are not dates'
SELECT machine_name, installed FROM machine
WHERE installed NOT GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]';

.print '--- Defect 5: the m:n list only joins when it holds exactly one part'
SELECT j.job_id, p.description
FROM maint_job j
JOIN part p ON p.part_no = j.parts_used;

.print '--- Defect 5 contrast: jobs that have parts vs jobs the join found'
SELECT (SELECT COUNT(*) FROM maint_job WHERE parts_used IS NOT NULL) AS jobs_with_parts,
       (SELECT COUNT(DISTINCT j.job_id) FROM maint_job j
        JOIN part p ON p.part_no = j.parts_used) AS jobs_found_by_join;.timer on
.headers on
.mode column

.print '--- Defect 1: orphan maintenance jobs (machine_name not in machine)'
SELECT m.job_id, m.machine_name
FROM maint_job m
LEFT JOIN machine x ON m.machine_name = x.machine_name
WHERE x.machine_name IS NULL;

.print '--- Defect 2: duplicate natural keys in part'
SELECT part_no, COUNT(*) AS copies
FROM part GROUP BY part_no HAVING COUNT(*) > 1;

.print '--- Defect 3: unit_price stored as text (text ordering, not money)'
SELECT part_no, unit_price FROM part WHERE unit_price < '15';

.print '--- Defect 3 contrast: the same filter with a numeric cast'
SELECT part_no, unit_price FROM part WHERE CAST(unit_price AS REAL) < 15;

.print '--- Defect 4: installed dates that are not dates'
SELECT machine_name, installed FROM machine
WHERE installed NOT GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]';

.print '--- Defect 5: the m:n list only joins when it holds exactly one part'
SELECT j.job_id, p.description
FROM maint_job j
JOIN part p ON p.part_no = j.parts_used;

.print '--- Defect 5 contrast: jobs that have parts vs jobs the join found'
SELECT (SELECT COUNT(*) FROM maint_job WHERE parts_used IS NOT NULL) AS jobs_with_parts,
       (SELECT COUNT(DISTINCT j.job_id) FROM maint_job j
        JOIN part p ON p.part_no = j.parts_used) AS jobs_found_by_join;