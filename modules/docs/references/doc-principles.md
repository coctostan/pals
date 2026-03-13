<overview>
DOCS — Documentation Lifecycle & Oversight Companion System. Provides visibility into documentation health: drift detection, currency checks, and coverage gaps.

**Philosophy:** Visibility first, enforcement later. DOCS starts as an advisory module — surfacing stale or missing docs without blocking execution. Future versions may add blocking gates for critical doc gaps.

**Core principle:** Detect → Catalog → Check → Suggest. Never auto-update documentation — only surface staleness and suggest what needs attention.
</overview>

<approach>

## Detect → Catalog → Check → Suggest

### 1. Detect
Identify documentation files in the project. Look for standard patterns (README.md, CHANGELOG.md, docs/) and framework-specific docs (Storybook, OpenAPI, Sphinx, MkDocs).

### 2. Catalog
Build a catalog of discovered docs with their types and locations. Track which code areas each doc covers based on proximity and naming conventions.

### 3. Check
Compare doc state against code state. Look for drift signals: code files modified recently while related docs remain untouched. Check README currency against project structure.

### 4. Suggest
Surface specific doc health warnings during planning and after execution. Provide actionable suggestions — which docs need updating and why — without modifying any files.

</approach>

<doc_types>

## Recognized Documentation Types

| Type | Common Patterns | Purpose |
|------|----------------|---------|
| README | README.md, README.rst | Project overview, setup, usage |
| Changelog | CHANGELOG.md, HISTORY.md, CHANGES.md | Version history |
| Contributing | CONTRIBUTING.md | Contribution guidelines |
| Architecture | ARCHITECTURE.md, docs/architecture.md | System design |
| API | API.md, docs/api/, openapi.yaml, swagger.json | API reference |
| Config | docs/configuration.md, docs/setup.md | Configuration guide |
| Module/Component | docs/*.md matching src/ structure | Component documentation |

</doc_types>

<constraints>

## Constraints

- Never auto-update or auto-generate documentation content
- Never modify existing doc files — only report on their state
- Use file modification times and proximity, not content parsing
- Do not run git blame or git log (too slow for hook context)
- Handle projects with no docs gracefully (report not-found, don't warn)
- Monorepos may have docs at multiple levels — catalog all, don't pick one
- Framework-specific docs (Storybook, Swagger) may be auto-generated — note but don't flag as stale

</constraints>
