<drift_detection>

## Documentation Drift Detection

Drift occurs when code changes but related documentation does not. DOCS detects drift at post-apply time by comparing files changed during the plan against the doc catalog built at pre-plan.

### Drift Analysis

**Input:** `files_changed` from apply phase + `doc_catalog` from pre-plan context_inject.

**Process:**
1. Group changed files by directory/component
2. For each component with changes, check if related docs exist in catalog
3. If related docs exist but were NOT in `files_changed`, flag as potential drift
4. If no related docs exist for a component with significant changes, flag as coverage gap

### Proximity Rules

Match changed code files to related docs using directory and naming proximity:

| Code Changed | Check These Docs |
|-------------|-----------------|
| `src/auth/*` | `docs/auth.md`, `docs/authentication.md`, README auth section |
| `src/api/routes/*` | `API.md`, `docs/api/`, `openapi.yaml` |
| `package.json` | `README.md` (setup/install sections) |
| `src/config/*` | `docs/configuration.md`, `docs/setup.md` |
| `src/components/*` | `.storybook/` stories, component-level READMEs |
| Any `src/` directory | Matching `docs/` file by name |

### Staleness Heuristic

A doc is considered potentially stale when:
- Related code files were modified in this plan
- The doc file was NOT modified in this plan
- The doc file exists in the catalog (not-found is a coverage gap, not staleness)

**Important:** This is advisory, not definitive. Code changes don't always require doc updates. The heuristic surfaces candidates for review, not confirmed problems.

### Warning Levels

| Level | Condition | Example |
|-------|-----------|---------|
| **info** | Docs exist and were updated alongside code | "docs/api.md updated with route changes" |
| **warn** | Code changed, related docs untouched | "src/auth/ changed but docs/auth.md not updated" |
| **gap** | Significant code area has no related docs | "src/payments/ has no documentation" |

### Currency Check

README currency assessment (runs as part of post-apply):
- If README.md exists and project structure changed (new dirs, moved files): flag for review
- If README.md references paths/commands that no longer exist: flag as stale
- If README.md was last in files_changed more than 5 plans ago: flag as potentially outdated

### Post-Apply Integration

At post-apply hook dispatch:

1. Load doc_catalog from pre-plan context_inject (doc_warnings key)
2. Compare against files_changed from apply phase
3. Run proximity matching
4. Build drift report

```yaml
action: continue
annotations:
  doc_drift:
    drift_files:
      - doc: docs/auth.md
        related_changes: ["src/auth/service.ts", "src/auth/middleware.ts"]
        level: warn
    coverage_gaps:
      - component: src/payments/
        level: gap
    summary: "1 doc potentially stale, 1 coverage gap"
```

### Avoiding False Positives

- Do NOT flag docs for unrelated code changes (e.g., test file changes don't imply doc drift)
- Do NOT flag auto-generated docs (Storybook, Swagger output) as stale
- Do NOT flag lock file changes (package-lock.json, yarn.lock) as requiring doc updates
- Do NOT flag configuration file changes (.eslintrc, tsconfig) unless docs explicitly cover config
- Treat `test/`, `__tests__/`, `*.test.*`, `*.spec.*` changes as non-doc-relevant

</drift_detection>
