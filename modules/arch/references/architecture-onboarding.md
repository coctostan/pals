<overview>
Advisory onboarding heuristics for compact architecture briefs from in-scope paths, `arch_context`, and provided project docs.
</overview>

<onboarding_scan>

## Project Structure Scan

Build onboarding context only from in-scope sources:

| Source | Use |
|--------|-----|
| `arch_context.detected_pattern` | observed pattern |
| `arch_context.layer_map` | layer names and expected paths |
| `arch_context.structural_warnings` | bounded drift/size/fan-out warnings |
| In-scope parent paths | where current work sits structurally |
| Provided project docs | cited conventions from supplied text only |

If no source is available, emit `ARCH onboarding: skipped — no in-scope structure evidence`.

</onboarding_scan>

<pattern_recognition>

## Pattern Recognition Checklist

Omit rows without in-scope evidence; do not search broadly to fill them.

| Check | Evidence | Use |
|-------|----------|-----|
| Layer structure | `arch_context.detected_pattern` + in-scope parent paths | observed pattern |
| Test co-location | in-scope test/source sibling paths | local test convention |
| API style | changed route/controller paths or provided docs | visible interface style |
| Data access | changed repository/ORM call path | visible data boundary |
| Auth boundary | changed auth/session path or provided docs | visible security boundary handoff |
| Side-effect placement | changed paths or provided docs show where env/clock/filesystem/network/process dependencies live | local effect boundary (Pure Core, Explicit Effects); advisory only |
| Local idioms | provided project docs or in-scope conventions name a local style (e.g., function-first, class-based, framework idiom) | preserved as authoritative; ARCH does not force a functional architecture |

</pattern_recognition>

<onboarding_report>

## Onboarding Report Format

Build the brief only from `<onboarding_scan>` sources; omit unknown fields and never invent facts.

```markdown
## Architecture Brief

**Scope:** {N} in-scope path(s)
**Pattern:** {arch_context.detected_pattern}

### Layer Map
| Layer | Directory | Evidence |
|-------|-----------|----------|
| {layer} | {dir} | {file_or_doc_reference} |

### Advisory Boundaries
- {boundary rule or boundary-check row with citation}

### Structural Warnings
- {warning label}: {file}:{metric}={value}

### Local Conventions
- {provided doc convention or visible in-scope pattern}
```

If no evidence is available, emit `ARCH onboarding: skipped — no in-scope structure evidence`.

</onboarding_report>

<brownfield_heuristics>

## Brownfield Project Heuristics

Use weak advisory brownfield labels only when visible in scope:

1. **Structure:** In-scope parent paths may suggest the active pattern; cite the path.
2. **Imports:** Resolved in-scope imports may show local coupling; do not rank global fan-in.
3. **Size/growth:** Current diff growth or file size may indicate responsibility creep; cite `{file}:{metric}={value}`.
4. **Tests:** In-scope test/source sibling paths may show local test convention; do not infer intended architecture.
5. **Docs:** Provided docs override heuristic labels when they conflict.

Omit brownfield notes when these signals are absent.

</brownfield_heuristics>
