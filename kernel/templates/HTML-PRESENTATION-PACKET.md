# HTML Presentation Packet Template

Template for `.paul/presentation-packets/{phase-or-milestone}/{packet-id}.html` — static HTML review packets derived from authoritative PALS lifecycle artifacts (see `docs/PALS-HTML-PRESENTATION-PACKETS-CONTRACT.md`).

**Purpose:** Provides the reusable model for milestone, PLAN, APPLY, and UNIFY human-review briefs. Packet instances are derived review artifacts, not lifecycle truth.

---

## File Template

```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{{PACKET_TITLE}}</title>
  <style>
    :root {
      color-scheme: light;
      --bg: #ffffff;
      --fg: #17202a;
      --muted: #5f6b7a;
      --border: #d8dee9;
      --panel: #f7f9fc;
      --accent: #235a97;
      --warn: #8a5a00;
      --block: #a32020;
    }

    body {
      margin: 0;
      background: var(--bg);
      color: var(--fg);
      font: 16px/1.5 -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    }

    header, main, footer {
      max-width: 980px;
      margin: 0 auto;
      padding: 1.25rem;
    }

    header {
      border-bottom: 2px solid var(--border);
    }

    h1, h2, h3 {
      line-height: 1.2;
    }

    .meta, .source-map, .evidence, .callout {
      border: 1px solid var(--border);
      border-radius: 0.5rem;
      background: var(--panel);
      padding: 1rem;
      margin: 1rem 0;
    }

    .muted {
      color: var(--muted);
    }

    .warning {
      border-color: var(--warn);
    }

    .blocker {
      border-color: var(--block);
    }

    table {
      border-collapse: collapse;
      width: 100%;
      margin: 1rem 0;
    }

    th, td {
      border: 1px solid var(--border);
      padding: 0.5rem;
      text-align: left;
      vertical-align: top;
    }

    pre {
      white-space: pre-wrap;
      overflow-wrap: anywhere;
      background: #f2f4f8;
      border: 1px solid var(--border);
      border-radius: 0.5rem;
      padding: 0.75rem;
    }

    @media print {
      body { font-size: 12px; }
      header, main, footer { max-width: none; }
      .no-print { display: none; }
    }
  </style>
</head>
<body>
  <header>
    <p class="muted">PALS HTML Presentation Packet</p>
    <h1>{{PACKET_TITLE}}</h1>
    <div class="meta" aria-label="Packet metadata">
      <dl>
        <dt>Packet ID</dt>
        <dd>{{PACKET_ID}}</dd>
        <dt>Packet Type</dt>
        <dd>{{PACKET_TYPE}}</dd>
        <dt>Audience Mode</dt>
        <dd>{{AUDIENCE_MODE}}</dd>
        <dt>Generated</dt>
        <dd>{{GENERATED_AT}}</dd>
        <dt>Lifecycle Moment</dt>
        <dd>{{LIFECYCLE_MOMENT}}</dd>
        <dt>Status</dt>
        <dd>{{STATUS}}</dd>
        <dt>Authority Note</dt>
        <dd>Derived review artifact only. Cited source artifacts and command outputs remain authoritative.</dd>
      </dl>
    </div>
  </header>

  <main>
    <section aria-labelledby="summary">
      <h2 id="summary">Summary</h2>
      <p>{{SUMMARY}}</p>
    </section>

    <section aria-labelledby="review-focus">
      <h2 id="review-focus">Review Focus</h2>
      <p>{{REVIEW_FOCUS}}</p>
    </section>

    <section aria-labelledby="source-map" class="source-map">
      <h2 id="source-map">Source Map</h2>
      <p class="muted">Every material claim in this packet should cite one of these sources.</p>
      {{SOURCE_MAP}}
      <p>{{ABSENT_SOURCE_NOTES}}</p>
    </section>

    <section aria-labelledby="key-decisions">
      <h2 id="key-decisions">Key Decisions</h2>
      {{KEY_DECISIONS}}
    </section>

    <section aria-labelledby="risks-constraints">
      <h2 id="risks-constraints">Risks &amp; Constraints</h2>
      {{RISKS_CONSTRAINTS}}
    </section>

    <section aria-labelledby="criteria-or-tasks">
      <h2 id="criteria-or-tasks">Acceptance Criteria / Task Evidence</h2>
      {{ACCEPTANCE_OR_TASK_EVIDENCE}}
    </section>

    <section aria-labelledby="evidence" class="evidence">
      <h2 id="evidence">Evidence</h2>
      {{EVIDENCE}}
    </section>

    <section aria-labelledby="validation">
      <h2 id="validation">Validation</h2>
      {{VALIDATION}}
    </section>

    <section aria-labelledby="open-questions">
      <h2 id="open-questions">Open Questions</h2>
      {{OPEN_QUESTIONS}}
    </section>
  </main>

  <footer>
    <p><strong>Authority:</strong> This packet is derived from cited sources. If packet content conflicts with `.paul/*`, PLAN/SUMMARY, module reports, git/PR/CI state, or parent-run command output, the cited authoritative source wins.</p>
    <p class="muted">Stored under `.paul/presentation-packets/{phase-or-milestone}/{packet-id}.html`; not hot-path lifecycle truth and not subject to STATE/PROJECT/ROADMAP/MILESTONES byte budgets.</p>
  </footer>
</body>
</html>
```

---

## Placeholder Fields

| Field | Purpose |
|-------|---------|
| `{{PACKET_TITLE}}` | Human-readable title, usually `{phase/plan} {packet type}` |
| `{{PACKET_ID}}` | Stable packet filename stem, such as `299-01-plan` |
| `{{PACKET_TYPE}}` | One of `milestone`, `PLAN`, `APPLY`, or `UNIFY` |
| `{{AUDIENCE_MODE}}` | One of `quick brief`, `reviewer brief`, or `full evidence brief` |
| `{{GENERATED_AT}}` | Generation timestamp or date captured by the workflow |
| `{{LIFECYCLE_MOMENT}}` | The lifecycle point represented by the packet |
| `{{STATUS}}` | Current lifecycle/review status from authoritative sources |
| `{{SOURCE_MAP}}` | Cited source paths, sections, line ranges, commands, or evidence labels |
| `{{ABSENT_SOURCE_NOTES}}` | `not available — <reason>` entries for optional missing sources |
| `{{SUMMARY}}` | Concise source-cited summary |
| `{{REVIEW_FOCUS}}` | What the human reviewer should inspect or decide |
| `{{KEY_DECISIONS}}` | Source-cited decisions, constraints, and rationale |
| `{{RISKS_CONSTRAINTS}}` | Warnings, blockers, scope boundaries, and authority constraints |
| `{{ACCEPTANCE_OR_TASK_EVIDENCE}}` | PLAN ACs, APPLY task status, or UNIFY reconciliation evidence depending on packet type |
| `{{EVIDENCE}}` | Expanded command/module/git/source evidence as allowed by audience mode |
| `{{VALIDATION}}` | Parent-run validation command results, skipped checks, or unavailable evidence notes |
| `{{OPEN_QUESTIONS}}` | Human-review questions, unresolved blockers, or `none` |

---

## Packet Type Variants

| Packet Type | Primary Review Focus | Typical Evidence |
|-------------|----------------------|------------------|
| `milestone` | Milestone goal, phase lineup, constraints, and next lifecycle action | STATE/ROADMAP/PROJECT/MILESTONES slices |
| `PLAN` | Executability, scope, ACs, tasks, boundaries, module dispatch, and approval readiness | PLAN sections, STATE loop position, ROADMAP phase detail |
| `APPLY` | Changed files, task results, verification, deviations, module reports, and UNIFY readiness | PLAN tasks, git diff summary, parent-run command outputs, module evidence |
| `UNIFY` | Plan-vs-actual reconciliation, validation, lifecycle updates, and next routing | PLAN, SUMMARY, APPLY evidence, STATE/ROADMAP updates, git/CI state |

---

## Audience Mode Variants

| Audience Mode | Density | Include |
|---------------|---------|---------|
| `quick brief` | Low | lifecycle status, short summary, top risks, validation headline, next action |
| `reviewer brief` | Medium | summary, source map, review focus, task/AC status, decisions, risks, validation, open questions |
| `full evidence brief` | High | reviewer brief plus expanded evidence tables, module reports, command summaries, changed-file inventory, git/PR/CI state |

Audience mode never changes authority. Every mode must cite sources and mark absent evidence explicitly.

---

## Static Rendering Rules

- Escape all user, artifact, command, diff, and source content before inserting it into HTML.
- Do not include scripts, event handlers, external stylesheets, external fonts, network images, embeds, or analytics.
- Inline CSS only.
- Use semantic headings and landmarks.
- Keep output printable and readable in a local browser without a server.
- Preserve source paths and evidence labels as plain text.
- Use `not available — <reason>` for absent optional inputs.
- Use `skipped — <reason>` for skipped checks.
- Never fabricate validation counts, CI status, source content, or lifecycle state.

---

## Usage Pattern

1. A later v2.71 workflow reaches a packet-supported lifecycle moment.
2. The workflow reads bounded authoritative source slices.
3. The workflow selects `{{PACKET_TYPE}}` and `{{AUDIENCE_MODE}}`.
4. The workflow fills this template with escaped, source-cited content.
5. The workflow writes the instance under `.paul/presentation-packets/{phase-or-milestone}/{packet-id}.html`.
6. The packet is shown or linked as review aid only; lifecycle state remains in authoritative artifacts.

---

## Relationship to Other Files

| File | Relationship |
|------|--------------|
| `docs/PALS-HTML-PRESENTATION-PACKETS-CONTRACT.md` | Authoritative contract for packet behavior, authority, storage, and non-goals |
| `.paul/presentation-packets/` | Durable derived packet instance storage; not hot-path lifecycle truth |
| `.paul/STATE.md` | Current lifecycle truth cited by packets, never replaced by packets |
| `.paul/ROADMAP.md` | Milestone/phase routing truth cited by packets |
| PLAN/SUMMARY files | Execution and reconciliation evidence cited by PLAN/APPLY/UNIFY packets |
| Future Phase 300 | Milestone + PLAN packet generation/surfacing |
| Future Phase 301 | APPLY + UNIFY packet generation/surfacing |
| Future Phase 302 | Surfacing validation and closure checks |
