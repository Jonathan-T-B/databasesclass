# Module 03: SQL notes

sqlite3 version: <paste output of sqlite3 --version>

## Task A: Plan safari

| Query | My prediction | Real plan before | Real plan after ix_job_tech | Surprise? |
|---|---|---|---|---|
| technician = 'Beier' | SCAN | | | |
| machine_name = 'cnc-02' | SCAN | | | |
| technician LIKE '%ei%' | SCAN | | | |

## Break it on purpose
| Query | Plan | Why the index is not used |
|---|---|---|
| lower(technician) = 'beier' | | |
| LIKE '%eier' | | |
| LIKE 'Bei%' | | |
| GLOB 'Bei*' | | |

## Predictions I got wrong
- ...
