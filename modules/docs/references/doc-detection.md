<detection>

## Documentation Detection

Scan the project for documentation files using pattern matching. Detection runs at pre-plan time to build a doc catalog for the current project.

### Standard Doc Patterns

Search the project root and common subdirectories for these patterns:

**Root-level docs:**
- `README.md`, `README.rst`, `README.txt`
- `CHANGELOG.md`, `HISTORY.md`, `CHANGES.md`
- `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`
- `ARCHITECTURE.md`, `DESIGN.md`
- `API.md`, `SECURITY.md`, `LICENSE.md`

**Directory-level docs:**
- `docs/` or `doc/` directory (any `.md` or `.rst` files within)
- `*.md` files in package/module roots (e.g., `packages/auth/README.md`)

**Framework-specific docs:**
- Storybook: `.storybook/` directory
- OpenAPI/Swagger: `openapi.yaml`, `openapi.json`, `swagger.yaml`, `swagger.json`
- Sphinx: `docs/conf.py`
- MkDocs: `mkdocs.yml`
- JSDoc: `jsdoc.json`, `.jsdoc.conf`
- TypeDoc: `typedoc.json`

### Detection Outcomes

Follow the three-outcome pattern from MODULE-SPEC section 3.8:

| Outcome | Description | Module Response |
|---------|-------------|-----------------|
| **found-standard** | Docs in expected locations | Catalog normally, no warnings |
| **found-non-standard** | Docs in unexpected locations (e.g., `documentation/` instead of `docs/`) | Catalog with note, inject advisory |
| **not-found** | No documentation files detected | Skip gracefully, no warning |

### Catalog Format

Build a catalog as a list of discovered docs:

```yaml
doc_catalog:
  - path: README.md
    type: readme
    location: standard
  - path: docs/architecture.md
    type: architecture
    location: standard
  - path: documentation/api-guide.md
    type: api
    location: non-standard
```

### Proximity Mapping

Map docs to code areas they likely describe:

| Doc Location | Likely Covers |
|-------------|---------------|
| `README.md` (root) | Entire project — setup, overview |
| `packages/X/README.md` | Package X specifically |
| `docs/auth.md` | `src/auth/`, `lib/auth/` |
| `docs/api/` | `src/api/`, `src/routes/` |
| `API.md` (root) | All API endpoints |
| `ARCHITECTURE.md` | Overall system structure |

Proximity is heuristic — match doc names/paths against source directory names. Exact matching is not required; partial name overlap signals relevance.

### Pre-Plan Integration

At pre-plan hook dispatch:

1. Run detection scan on project root
2. Build doc catalog
3. Count docs by type and status
4. Inject into plan context:

```yaml
context_inject:
  doc_warnings:
    value:
      total_docs: 5
      stale_count: 2
      missing_types: ["changelog", "contributing"]
      catalog: [...]
    format: structured
```

If no docs found and project has substantial code, inject advisory:
```yaml
context_inject:
  doc_warnings:
    value:
      total_docs: 0
      advisory: "No documentation detected in project"
    format: structured
```

</detection>
