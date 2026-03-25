<overview>
Architecture drift detection for ARCH. Compares current changes against the project's established patterns to surface structural violations before they compound.
</overview>

<drift_categories>

## Drift Categories

| Category | What It Means | Detection Method |
|----------|--------------|-----------------|
| Boundary violation | Import crosses architectural layers illegally | Parse imports in changed files, resolve layers, check against boundary rules |
| Pattern inconsistency | New code doesn't follow the established pattern | Compare new file location/structure against detected project pattern |
| Responsibility creep | File/module is growing beyond its original scope | Track file line counts, export counts, import fan-in/fan-out |
| Coupling increase | New direct dependencies between modules that should be decoupled | Count cross-module imports in changed files vs baseline |
| Convention drift | Naming, structure, or organization diverges from established conventions | Compare new file/dir names against existing patterns |

</drift_categories>

<detection_process>

## Drift Detection Process

**At pre-plan (advisory):**

1. Detect project architecture pattern from directory structure
2. For each file in `files_modified`, check:
   - Is the file in the expected layer/directory for its purpose?
   - Do its imports respect boundary rules?
3. Inject `arch_warnings` with any drift signals

**At post-apply (can block):**

1. For EACH changed file, run boundary check:
   ```
   grep -n "import\|require\|from " {file}
   ```
2. Resolve import targets to architectural layers
3. Check each import against boundary rules from architecture-patterns.md
4. Flag violations with file:line references

### Severity Levels

| Severity | Trigger | Action |
|----------|---------|--------|
| Critical | Domain → Infrastructure dependency | BLOCK — architectural foundation compromised |
| High | Controller → Repository (bypassing service) | BLOCK — business logic bypass |
| Medium | Utility importing domain types | WARN — coupling risk |
| Low | File in unexpected directory | WARN — convention drift |
| Info | New directory created | NOTE — may indicate pattern evolution |

</detection_process>

<common_drift_patterns>

## Common Drift Patterns

- **The Shortcut:** Direct DB call from a route handler because "it's just one query" — leads to business logic scatter
- **The Creeping God:** A utility file that keeps getting new functions until it's 800 lines of unrelated code
- **The Circular Dependency:** Module A imports B, B imports A — often hidden through re-exports
- **The Wrong Layer:** A React component that makes fetch calls directly instead of going through a service/hook layer
- **The Leaky Abstraction:** A repository that returns raw SQL rows instead of domain objects
- **The Abandoned Pattern:** Project started with clean architecture but new features ignore it entirely

</common_drift_patterns>
