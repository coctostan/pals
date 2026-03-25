<overview>
Data architecture pattern detection and schema health validation for DANA. Covers schema design, migration safety, query patterns, data integrity, and ORM usage.
</overview>

<schema_design>

## Schema Design Patterns

| Pattern | Good | Smell |
|---------|------|-------|
| Normalization | Related data in separate tables with foreign keys | Everything in one table with duplicated columns |
| Naming convention | Consistent `snake_case` or `camelCase`, plural table names | Mixed casing, abbreviations, singular/plural mix |
| Primary keys | UUID or auto-increment `id` on every table | Composite primary keys on mutable columns |
| Timestamps | `created_at`, `updated_at` on every table | No audit trail, no soft delete support |
| Soft delete | `deleted_at` nullable timestamp | Hard delete without recovery option |
| Indexes | Indexes on foreign keys and frequently queried columns | Missing indexes on JOIN/WHERE columns |
| Constraints | NOT NULL, UNIQUE, CHECK constraints | No constraints, validation only in app code |
| Enums | Enum types or status tables | Magic strings/numbers in columns |

### Detection

```bash
# Find migration files
find . -path "*/migrations/*" -name "*.ts" -o -path "*/migrations/*" -name "*.sql" -o -name "*.prisma" -o -name "schema.rb"

# Find schema definitions
find . -name "schema.prisma" -o -name "*.entity.ts" -o -name "models.py" -o -name "schema.rb"

# Check for missing timestamps in schema
grep -L "created_at\|createdAt\|timestamps" $(find . -name "*.entity.ts" -o -name "*.model.ts" 2>/dev/null)
```

</schema_design>

<migration_safety>

## Migration Safety

| Risk | Detection | Impact |
|------|-----------|--------|
| Drop column | `DROP COLUMN`, `removeColumn` in migration | Data loss — irreversible |
| Drop table | `DROP TABLE`, `dropTable` in migration | Data loss — irreversible |
| Rename column | `RENAME COLUMN`, `renameColumn` | Breaks running code during deploy |
| NOT NULL without default | `ALTER COLUMN SET NOT NULL` without `DEFAULT` | Fails on existing rows |
| Large table ALTER | `ALTER TABLE` on tables >1M rows | Table lock, downtime |
| Index on large table | `CREATE INDEX` without `CONCURRENTLY` (PostgreSQL) | Table lock |
| Data migration in schema migration | INSERT/UPDATE in schema change | Mixing concerns, hard to rollback |

### Safety Checklist

For each migration file in changed files:
1. Check for destructive operations (DROP, RENAME, data deletion)
2. Check for NOT NULL additions without DEFAULT
3. Check for large-table operations without concurrency flags
4. Verify rollback/down migration exists

```bash
# Find destructive migration operations
grep -rn "DROP\|RENAME\|removeColumn\|dropTable\|removeIndex" --include="*.ts" --include="*.sql" $(find . -path "*/migrations/*" 2>/dev/null)
```

</migration_safety>

<query_patterns>

## Query & ORM Patterns

| Pattern | Good | Smell |
|---------|------|-------|
| Parameterized queries | `WHERE id = $1`, `.where({ id })` | String concat: `WHERE id = ${id}` |
| Select specific columns | `.select(['id', 'name'])` | `.find()` without select (SELECT *) |
| Eager loading | `.include()`, `.populate()`, `JOIN` | Lazy loading in loops (N+1) |
| Pagination | `.limit().offset()`, cursor-based | Unbounded `.find()` on large tables |
| Transactions | `prisma.$transaction()`, `BEGIN/COMMIT` | Multiple writes without transaction |
| Connection pooling | Pool config, connection limits | New connection per request |
| Query logging | ORM query logging in dev | No visibility into generated queries |

</query_patterns>

<data_integrity>

## Data Integrity

| Concern | Check | Detection |
|---------|-------|-----------|
| Foreign key constraints | References between tables enforced | Check schema for foreign key definitions |
| Unique constraints | Business-unique fields protected | Check for UNIQUE indexes on email, slug, etc. |
| Cascade rules | ON DELETE behavior defined | Check foreign keys for CASCADE/SET NULL/RESTRICT |
| Validation layers | Both DB constraints AND app validation | Check for app-only validation without DB backup |
| Orphan prevention | Referential integrity maintained | Check for DELETE without cascade consideration |
| Type safety | ORM types match DB schema | Check for type mismatches, `any` in DB code |

</data_integrity>

<data_health_metrics>

## Data Architecture Health

| Metric | Healthy | Warning | Critical |
|--------|---------|---------|----------|
| Tables without timestamps | 0 | 1-2 | >2 |
| Missing foreign key indexes | 0 | 1-3 | >3 |
| Destructive migrations without rollback | 0 | 1 | >1 |
| Tables without primary key | 0 | 0 | >0 |
| Magic strings in columns | 0 | 1-3 | >3 |
| N+1 query patterns | 0 | 1-2 | >2 |
| Unbounded queries | 0 | 1 | >1 |

</data_health_metrics>
