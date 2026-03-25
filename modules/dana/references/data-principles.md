# Data Architecture Principles

Core principles guiding DANA module behavior.

## Principles

1. **Schema is contract.** Database schema is a contract between all parts of the system. Changes must be deliberate, versioned, and reversible. DANA treats destructive migrations as critical findings.

2. **Constraints belong in the database.** Application validation is necessary but not sufficient. Unique constraints, foreign keys, and NOT NULL belong in the schema — they're the last line of defense.

3. **Every table needs an audit trail.** `created_at` and `updated_at` on every table is the minimum. DANA flags tables without timestamps because debugging production issues without them is nearly impossible.

4. **Migrations must be reversible.** Every schema change should have a rollback path. DROP COLUMN without backup, DROP TABLE without confirmation — these are one-way doors that need explicit approval.

5. **Query patterns matter more than query speed.** A single slow query is a bug. An N+1 pattern is a design flaw that gets worse with every row. DANA catches patterns, not individual query timing.

## Advisory vs Blocking

- **Advisory (pre-plan):** Schema assessment, migration audit, query pattern scan — inform the plan
- **Blocking (post-apply):** Destructive migrations without rollback (critical), new N+1 patterns (high), removed constraints/indexes (high)
