# Contract note: what is enforced where

## Enforced by the database (SQLAlchemy DDL)
- PRIMARY KEY on machine_id, part_no, job_id and (job_id, part_no): fixes the duplicate P-1003 (defect 2).
- UNIQUE(serial_no): the natural key stays unique even though machine_id is the surrogate.
- FOREIGN KEYs (maint_job.machine_id, job_part.*): prevent orphan jobs like cnc-05 (defect 1).
- NOT NULL and NUMERIC(9,2) on unit_price: fixes text prices (defect 3).
- DATE type on installed: fixes free-text dates (defect 4).
- The junction table job_part: replaces the comma list in parts_used (defect 5).

Why here: these rules must hold for every client, including ad-hoc SQL, imports and other applications.
Note: SQLite only enforces foreign keys after `PRAGMA foreign_keys = ON;` on each connection.

## Enforced by the model (Pydantic)
- The "SN-" prefix on serial_no and min_length=3.
- Real date parsing (installed must be a date, not "unknown").
- Field(ge=1) on machine_id.

Why here: these are format and business rules that give friendly error messages before the data reaches the database, and are easier to change than DDL.

## Not covered yet
- MaintenanceJob.part_nos is a list in the model, but the database stores it as rows in job_part. The application must translate between them.
- The contract has no technician table. technician is still text here, as in the task sheet. A fuller design would add a technician table with a foreign key, as in the ER diagram.
- Pydantic's SN- rule is not mirrored by a database CHECK, so a direct SQL insert could bypass it. A CHECK (serial_no LIKE 'SN-%') would close that gap.