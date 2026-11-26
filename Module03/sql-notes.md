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
R   = σ_{ordered_on ≥ '2025-01-01' ∧ ordered_on < '2026-01-01'}(orders)

J   = customer ⋈_{customer.customer_id = R.customer_id} R
               ⋈_{R.order_id = order_line.order_id} order_line
               ⋈_{order_line.product_id = product.product_id} product

G   = γ_{city; COUNT(DISTINCT customer_id) → customers, SUM(qty·price) → revenue}(J)

Result = τ_{revenue DESC}(G)