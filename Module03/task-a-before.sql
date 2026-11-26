.headers on
.print '--- Q1: technician = Beier'
EXPLAIN QUERY PLAN SELECT * FROM maint_job WHERE technician = 'Beier';
.print '--- Q2: machine_name = cnc-02'
EXPLAIN QUERY PLAN SELECT * FROM machine WHERE machine_name = 'cnc-02';
.print '--- Q3: technician LIKE %ei%'
EXPLAIN QUERY PLAN SELECT * FROM maint_job WHERE technician LIKE '%ei%';