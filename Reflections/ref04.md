# Reflection 04: Data Integrity, Constraints & Edge Triggers

**Date:** [date]  |  **Module:** 4  |  **Time spent:** [1.5-2h]

## 1. What I did
Short summary: I built a STRICT SQLite schema for machine telemetry, tested
each constraint by trying to break it, made ingestion idempotent with UPSERT,
added alarm and audit triggers, and demonstrated server-less access control.

## 2. What I learned
- Integrity has three layers (entity, referential, domain), and I can now
  point to the SQL feature and the exact error for each: (paste 1-2 examples,
  e.g. "FOREIGN KEY constraint failed").
- Something concrete you learned about STRICT, e.g. what happened with '12'
  vs 'hot' in a REAL column.
- After inserting a row with the value = NULL into t2, the Check( value BETWEEN -273.15 and 5000) did not reject it. It returned 4 | temp_c | -Empty- | null | (for sensor_id | metric | value | value_type |)

## 3. What surprised me
Foreign Keys being turned off be default


## 4. What was difficult
PowerShell vs bash syntax, getting a command to fail the way you
expected, understanding trigger timing, etc

## 5. Trigger cost
I inserted 10000 vibration readings (all of these were above 2.0 mm/s causing the alarm to fire on every row into an in-memory database.

## 6. Access control: edge vs server
[2-3 sentences in your own words: PostgreSQL uses roles and GRANT enforced
per user; SQLite relies on file permissions, mode=ro and views. Fine at the
edge because ..., not for multi-tenant web apps because ...]

## 7. Limits I found in my own design
- A CHECK cannot tell that 4999 is implausible for a vibration sensor.
- An AFTER INSERT alarm does not fire when an UPSERT updates an existing
  row. A corrected replayed value above 2.0 would be missed.
- attrib +R is a weak lock because any process running as me can remove it.

## 8. What I'd do differently / next steps
an AFTER UPDATE alarm trigger as well, 
a foreign_keys check in every script (are they turned on or off)

## 9. Use of AI
- For Error Diagnostics and explaining questions about the content

## 10. Links to evidence in the module
-
