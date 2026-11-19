.print '=== BEFORE INDEX ==='
.print '--- Q1'
EXPLAIN QUERY PLAN SELECT * FROM maint_job WHERE technician = 'Beier';
.print '--- Q2'
EXPLAIN QUERY PLAN SELECT * FROM machine WHERE machine_name = 'cnc-02';
.print '--- Q3'
EXPLAIN QUERY PLAN SELECT * FROM maint_job WHERE technician LIKE '%ei%';

CREATE INDEX ix_job_tech ON maint_job(technician);

.print '=== AFTER INDEX ix_job_tech ==='
.print '--- Q1'
EXPLAIN QUERY PLAN SELECT * FROM maint_job WHERE technician = 'Beier';
.print '--- Q2'
EXPLAIN QUERY PLAN SELECT * FROM machine WHERE machine_name = 'cnc-02';
.print '--- Q3'
EXPLAIN QUERY PLAN SELECT * FROM maint_job WHERE technician LIKE '%ei%';

.print '=== BREAK IT ON PURPOSE ==='
.print '--- Q4: function wraps the column'
EXPLAIN QUERY PLAN SELECT * FROM maint_job WHERE lower(technician) = 'beier';
.print '--- Q5: leading wildcard'
EXPLAIN QUERY PLAN SELECT * FROM maint_job WHERE technician LIKE '%eier';
.print '--- Q6: trailing wildcard only (for contrast)'
EXPLAIN QUERY PLAN SELECT * FROM maint_job WHERE technician LIKE 'Bei%';
.print '--- Q7: GLOB, case-sensitive prefix (for contrast)'
EXPLAIN QUERY PLAN SELECT * FROM maint_job WHERE technician GLOB 'Bei*';

DROP INDEX ix_job_tech;