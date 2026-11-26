# Reflection 03 — LLM-assisted SQL & query profiling

## What I did
(Plan safari, algebra check, warehouse setup, LLM query, index benchmark, injection drill.)

## What surprised me
(A prediction I got wrong. A plan that changed without a timing change, or the other way around.)

## How I verified AI output
- LLM query: checked DISTINCT, year-filter placement, join type, and cross-checked revenue with an independent query.
- LLM index advice: tested one index at a time with plan + median of ≥3 runs.
- LLM algebra: wrote mine first, then diffed (differences: ...).
- What the LLM got wrong or oversimplified:

## What I would do differently

## Open questions