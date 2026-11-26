.headers on
DROP INDEX IF EXISTS ix_job_tech;
CREATE INDEX ix_job_tech ON maint_job(technician);

.print '--- Q1: technician = Beier'
EXPLAIN QUERY PLAN SELECT * FROM maint_job WHERE technician = 'Beier';
.print '--- Q2: machine_name = cnc-02'
EXPLAIN QUERY PLAN SELECT * FROM machine WHERE machine_name = 'cnc-02';
.print '--- Q3: technician LIKE %ei%'
EXPLAIN QUERY PLAN SELECT * FROM maint_job WHERE technician LIKE '%ei%';

.print ''
.print '=== BREAK IT ON PURPOSE ==='
.print '--- B1: function wraps the column'
EXPLAIN QUERY PLAN SELECT * FROM maint_job WHERE lower(technician) = 'beier';
.print '--- B2: leading wildcard'
EXPLAIN QUERY PLAN SELECT * FROM maint_job WHERE technician LIKE '%eier';
.print '--- B3 (bonus): prefix LIKE, does the index help?'
EXPLAIN QUERY PLAN SELECT * FROM maint_job WHERE technician LIKE 'Bei%';
.print '--- B4 (bonus): the same prefix search written as a range'
EXPLAIN QUERY PLAN SELECT * FROM maint_job WHERE technician >= 'Bei' AND technician < 'Bej';