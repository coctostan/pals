<overview>
Advisory drift reference for comparing in-scope changes against the detected architecture pattern, boundary rules, and structural WARN triggers. ARCH surfaces evidence; PLAN/APPLY/UNIFY owns any blocking response.
</overview>

<drift_categories>

## Drift Categories

Report drift only from `files_changed`, resolved imports, `arch_context`, or the current diff; do not infer project-wide baselines.

| Category | Meaning | Evidence |
|----------|---------|----------|
| Boundary violation | Import crosses a disallowed layer pair | Boundary-check row with Status `VIOLATION` |
| Pattern inconsistency | Changed path misses the detected layer map | `files_changed` path + `arch_context.layer_map` |
| Responsibility creep | File exceeds a size/growth WARN trigger | line count or diff growth for that file |
| Coupling increase | Current diff adds an in-scope module dependency | added resolved import |
| Convention drift | Changed name/path misses a documented naming or location rule | `files_changed` path + rule |

</drift_categories>

<detection_process>

## Drift Detection Process

**At pre-plan:**

1. Set `arch_context.detected_pattern` from parent directories of `files_modified`.
2. Set `arch_context.layer_map` for in-scope paths.
3. Add `arch_context.structural_warnings` only for in-scope WARN triggers, each with `{file, metric, value}` evidence.

**At post-apply:**

1. Resolve imports from `files_changed`.
2. Emit the boundary-check table from architecture-patterns.md.
3. Add structural drift findings to `arch_context.structural_warnings`.
4. PLAN/APPLY/UNIFY owns any blocking response to table or WARN findings.

### Status Handling

| Status | Meaning | Handling |
|--------|---------|----------|
| PASS | Boundary rule allows the import pair | Record compact evidence |
| VIOLATION | Boundary rule disallows the import pair | Advisory finding; cite row and PLAN/APPLY/UNIFY-owned recovery |
| WARN | Import pair is unlisted or structural drift trigger fired | Advisory finding; cite row or `{file}:{metric}={value}` |

</detection_process>

<common_drift_patterns>

## Common Drift Patterns

Report these labels only when `files_changed`, resolved imports, `arch_context`, or the current diff supports them.

- **The Shortcut:** Diff adds a direct data-access call from a transport or UI layer.
- **The Creeping God:** Changed file crosses a size/growth WARN trigger.
- **The Circular Dependency:** Resolved in-scope imports form a cycle.
- **The Wrong Layer:** Changed path misses `arch_context.layer_map`.
- **The Leaky Abstraction:** Changed code exposes infrastructure details across a documented boundary.
- **The Abandoned Pattern:** Multiple changed paths miss the same detected pattern.

</common_drift_patterns>
