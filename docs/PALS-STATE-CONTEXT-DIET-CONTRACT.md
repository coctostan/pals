# PALS STATE Context Diet Contract

**Status:** Phase 265 baseline (v2.62 PALS Context Diet — STATE & Hot-Path Compression)
**Authority tier:** derived planning aid (not authoritative lifecycle truth)
**Scope:** `.paul/STATE.md`, `.paul/PROJECT.md`, `.paul/MILESTONES.md`, `.paul/ROADMAP.md`
**Recipe family:** v2.43 archive-and-compact (4th application: v2.43 ROADMAP/workflow archive → v2.44 process/artifact compaction → v2.62 STATE/PROJECT compaction)

---

## Purpose

Define the hot/warm/cold split, archive structure, per-section live-byte budgets, and Phase 266/267 handoff for compacting `.paul/STATE.md` and `.paul/PROJECT.md` (and trimming the active windows of `.paul/MILESTONES.md` and `.paul/ROADMAP.md` where bounded) without weakening lifecycle authority, helper compatibility, validation truth, Pi runtime expectations, CARL session-boundary expectations, or full authoritative read fallback.

The pain that triggered this milestone: `/paul:resume` consumes ~50 KB of context per session against current `.paul/*` artifacts (STATE.md alone is ~98 KB; PROJECT.md is ~67 KB). v2.43 and v2.44 applied the archive-and-compact recipe to ROADMAP/workflows/process surfaces; STATE.md and PROJECT.md were never given the same treatment. v2.62 closes that gap.

---

## Evidence Base

- `.paul/PROJECT.md` — current v2.62 focus, active guarantees, scope-out boundaries.
- `.paul/ROADMAP.md` — v2.62 milestone block; Phase 265–267 detail.
- `.paul/STATE.md` — current lifecycle truth (and one of the two compaction targets in Phase 266).
- `.paul/handoffs/archive/HANDOFF-2026-05-07-v2.62-ready-to-plan-phase-265.md` — discussion handoff that shaped the milestone scope (cold archive split + active-window compaction; cross-file narrative deduplication explicitly deferred).
- `docs/PI-NATIVE-EXTENSION-MODULARIZATION-CONTRACT.md` — proven contract shape (Subsystem Inventory, Phase outcome ledger, Allowed file scope, Forbidden, Validation count handoff). This contract mirrors that shape adapted to context-diet semantics.
- `docs/PI-NATIVE-ARTIFACT-SLICE-CONTRACT.md` and `docs/PI-NATIVE-WORKFLOW-RESOURCE-CAPSULE-CONTRACT.md` — additional v2.47 / v2.49 baseline contracts demonstrating non-authority / freshness / bounds language reused here.
- `.paul/archive/state/STATE-HISTORY-v0-v2.43.md` (~41 KB) — proves the v2.43 archive precedent for STATE.md exists. Phase 266 extends it (or creates a `v2.44–v2.60` successor file) rather than inventing a new pattern.
- `.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md` (~28 KB) — same precedent for ROADMAP.
- `.paul/archive/project/PROJECT-HISTORY.md` — same precedent for PROJECT.
- `.paul/archive/milestones/MILESTONES-v0-v2.42.md` — same precedent for MILESTONES.

---

## Authority and Non-Goals

**Authority.** This contract is a **derived planning aid**. It does **not** carry lifecycle authority over `.paul/*` artifacts. STATE.md, PROJECT.md, MILESTONES.md, and ROADMAP.md remain the authoritative lifecycle truth at all times. The contract guides Phase 266 mutation and Phase 267 validation, but if Phase 266 must deviate (e.g., a preservation invariant changes), the deviation is recorded in the Phase 266 SUMMARY.md, not silently negotiated against this contract.

**Full authoritative read fallback is preserved.** Every compaction rule defined here MUST keep STATE.md / PROJECT.md / MILESTONES.md / ROADMAP.md self-contained and human-readable post-Phase-266. Archive split MUST include a discoverable archive-pointer line. No telemetry. No Pi-owned authoritative execution state. No hidden helper state.

**Non-goals.**
- No weakening of lifecycle authority, explicit approvals, module evidence, validation truth, GitHub Flow gates, parent-owned APPLY, delegated APPLY boundaries, or `.paul/*` artifact authority.
- No cross-file narrative deduplication in v2.62 (architectural; would re-litigate v2.43/v2.44 design — explicitly deferred).
- No workflow file context-diet (`kernel/`, `~/.pi/agent/skills/pals/*`) in v2.62 (explicitly deferred).
- No runtime/source/test/helper/CI changes in v2.62 except (a) bounded structural anti-regrowth assertions in Phase 267 inside `tests/pi-end-to-end-validation.sh` and `tests/cross-harness-validation.sh` and (b) one cross-harness shared-invariant closure block in Phase 267.
- No README / Pi docs / skill-map surfacing of this contract in v2.62 (deferred to a future milestone).
- No telemetry-based resume-cost evidence; baseline measurement uses repo artifact byte counts and the documented workflow read order only.

---

## Hot-Path Read Measurement (Baseline)

**Workflow read order** (source: `~/.pi/agent/skills/pals/workflows/resume-project.md`, mirrored at `kernel/workflows/resume-project.md`):

1. `verify_paul_exists` — checks `.paul/STATE.md` presence (no read content).
2. `detect_handoffs` — reads at most one active handoff under `.paul/HANDOFF*.md` (or one archived handoff under `.paul/handoffs/archive/`).
3. `load_state` — reads `.paul/STATE.md` in full.
4. `check_config_version` — reads `pals.json` (small, not counted in hot artifact total).
5. `load_resume_context` — reads handoff content (if detected) or the `Resume file` referenced by STATE.md (typically a PLAN or SUMMARY).
6. `check_git_state` — runs git/gh commands; no `.paul/*` reads.
7. `determine_single_action` — pure routing logic; no reads.
8. `report_and_route` — output only.

The PAUL workflow itself does **not** read `.paul/PROJECT.md`, `.paul/MILESTONES.md`, or `.paul/ROADMAP.md` during `/paul:resume`. Their hot-path contribution arrives via `/paul:plan`, `/paul:apply`, `/paul:unify`, and `/paul:milestone`, which are the dominant cost amplifiers across a working session.

**Baseline byte counts** (measured 2026-05-07 via `wc -c` against `feature/265-pals-hot-path-context-audit-diet-contract` working tree, with PAUL lifecycle status updates from `/paul:plan` already in place):

| Artifact            | Bytes  | Lines |
|---------------------|-------:|------:|
| `.paul/STATE.md`    | 97,954 |   339 |
| `.paul/PROJECT.md`  | 67,327 |   193 |
| `.paul/MILESTONES.md` | 29,560 | 109 |
| `.paul/ROADMAP.md`  | 32,178 |   144 |
| **Aggregate hot-path artifact total** | **227,019** | **785** |

**Resume-cost pain (recorded).** `/paul:resume` consumes ~50 KB of context per session against current artifacts even though the workflow only reads STATE.md + one handoff/PLAN/SUMMARY. STATE.md alone dominates because the active `Current Summary` / `Current Decisions` / `Fixes / Deviations / Skill Audits` rows have grown to v2.41–v2.60 cold history without any archival pass since v2.43's `STATE-HISTORY-v0-v2.43.md`. PROJECT.md compounds the cost across `/paul:plan` and `/paul:apply` entry points.

**Note on Pi runtime artifact slices.** When PALS activation is enabled, the Pi runtime renders bounded, source-cited artifact slices over STATE.md / ROADMAP.md / current PLAN behind explicit activation (source: `drivers/pi/extensions/artifact-slice-rendering.ts`). These are bounded, deduplicated, and freshness-marked; they do not change the hot-path read total at the workflow level, but they DO depend on the section structure of STATE.md (see Preservation Invariants).

---

## Per-File Active-vs-Cold Split Audit

For each artifact, sections are classified as **active** (must stay hot in the artifact), **warm** (compact-in-place candidate; stay hot but bounded), or **cold** (archive candidate).

### `.paul/STATE.md`

Section ledger (source: `grep -nE "^### |^## " .paul/STATE.md`):

| Section | Lines (approx) | Class | Rationale |
|---|---|---|---|
| `## Project Reference` | 3–8 | active | Tiny pointer; lifecycle anchor; touched on every read. |
| `## Current Position` | 9–65 | active | Live milestone/phase/plan/status/Next-action. Helper-critical (artifact_consistency_check parses `Phase: N of M (Name) — ...`). |
| `## Loop Position` | 66–73 | active | Live loop state (PLAN/APPLY/UNIFY markers). |
| `## Accumulated Context` → `### Current Summary` | 76–162 | warm + cold | Current-milestone summary entries stay hot (warm-compact); v2.41–v2.60 prior-milestone summary bullets are cold. |
| `## Accumulated Context` → `### Current Decisions` | 163–234 | warm + cold | Current-milestone decisions stay hot (warm-compact); pre-v2.61 decision rows are cold. |
| `## Accumulated Context` → `### Fixes / Deviations / Skill Audits` | 235–306 | warm + cold | Current-milestone fixes/deviations stay hot (warm-compact); pre-v2.61 rows are cold. |
| `## Accumulated Context` → `### Deferred Issues` | 307–314 | active | Small, lifecycle-relevant; do not archive. |
| `## Accumulated Context` → `### Blockers/Concerns` | 315–319 | active | Small; lifecycle-critical. |
| `## Accumulated Context` → `### Git State` | 320–327 | active | Small; lifecycle-routing surface. |
| `## Session Continuity` | 328–end | active | Helper-critical (`artifact_consistency_check` parses `Resume file:`); CARL-critical. |

**Cold-archive candidates:** v2.41–v2.60 entries inside `### Current Summary`, `### Current Decisions`, and `### Fixes / Deviations / Skill Audits`. Phase 266 archives these into `.paul/archive/state/STATE-HISTORY-v2.44-v2.60.md` (extending the `STATE-HISTORY-v0-v2.43.md` precedent). v2.61 (just-closed) and v2.62 (active) entries stay hot.

**Warm-compact candidates:** the current-milestone (v2.62) summary/decisions/fixes rows. Where verbose narrative duplicates `.paul/PROJECT.md` or `.paul/MILESTONES.md`, prefer the shortest factual form in STATE.md and let PROJECT/MILESTONES carry the longer narrative. (Cross-file narrative deduplication remediation is deferred — see below — but warm compaction MAY shorten in-file narrative without touching cross-file duplication.)

### `.paul/PROJECT.md`

Section ledger (source: `grep -nE "^## " .paul/PROJECT.md`):

| Section | Lines (approx) | Class | Rationale |
|---|---|---|---|
| `## Description` | 3–6 | active | Cross-harness-required structural section. |
| `## Core Value` | 7–10 | active | Cross-harness-required structural section. |
| `## Current focus` | 11–16 | active | Hot-path entry-point summary. |
| `## Hot-path reading model` | 17–27 | active | Tells readers which slices to consume hot vs cold; structural. |
| `## Active requirements summary` | 28–42 | active | Bounded; live requirements snapshot. |
| `## Current milestone posture` | 43–70 | warm + cold | Current-milestone posture (v2.61/v2.62) stays hot (warm-compact); pre-v2.55 milestone posture is cold. |
| `## Constraints` | 71–80 | active | Small; structural. |
| `## Key current decisions` | 81–164 | warm + cold | Current/recent decisions stay hot (warm-compact); pre-v2.55 rows are cold. |
| `## Success Criteria` | 165–171 | active | Small; lifecycle-critical. |
| `## Specialized Flows` | 172–182 | active | Small; cross-harness-relevant. |
| `## Archive` | 183–end | active | Pointer-only block; preserves archive discoverability. |

**Cold-archive candidates:** pre-v2.55 entries inside `## Current milestone posture` and `## Key current decisions`. Phase 266 archives these by extending `.paul/archive/project/PROJECT-HISTORY.md` (the existing precedent).

**Warm-compact candidates:** v2.55–v2.62 entries in `## Current milestone posture` and `## Key current decisions`. Compact narrative-heavy rows to factual one-liners with archive cross-references when relevant.

### `.paul/MILESTONES.md`

Section ledger (source: `grep -nE "^## " .paul/MILESTONES.md`):

| Section | Lines (approx) | Class | Rationale |
|---|---|---|---|
| `## Live Status` | 5–12 | active | Helper-critical (`artifact_consistency_check` matches Phase number against this surface). |
| `## Completed Milestones` | 13–83 | warm | Active milestone summary table; recent milestones stay hot, but each row has grown verbose since v2.55. Compact to one-liners with cross-references. |
| `## Current / Future Milestone Pointer` | 84–103 | warm | Current/future paragraphs grew verbose with v2.61's per-PR detail. Compact to bounded one-liners; route detail to PROJECT.md or summary archive. |
| `## Archive` | 104–end | active | Pointer block. |

**Cold-archive candidates:** none in v2.62. The v2.43 archive (`.paul/archive/milestones/MILESTONES-v0-v2.42.md`) already covers pre-v2.43 history; v2.44–v2.62 milestones are within the live working window and stay hot.

**Warm-compact candidates:** verbose `## Current / Future Milestone Pointer` paragraphs (v2.55–v2.61); verbose v2.61 entry inside `## Completed Milestones` table (currently a 1-row, multi-paragraph cell). Phase 266 reduces these to one-liners with `(see PROJECT.md / archive)` cross-references.

### `.paul/ROADMAP.md`

Section ledger (source: `grep -nE "^## " .paul/ROADMAP.md`):

| Section | Lines (approx) | Class | Rationale |
|---|---|---|---|
| `## Overview` | 3–5 | active | Tiny anchor. |
| `## Milestones` | 6–28 | active | High-level milestone index; cross-harness-required. |
| `## Current Milestone` | 29–120 | warm | Active v2.62 phase block stays hot, but Phase 264 paragraph (lines ~98–120, ~22 lines of v2.61-closure narrative) pushes the active window over 120 lines. This is the **Path A inherited regression** (Pi `not ok 102` / cross-harness `not ok 31`). Phase 266 reconciles inline by trimming to short pointers. |
| `## Completed Milestones` | 121–end | warm | Last-updated paragraph; trim to factual one-liners; route history to `.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md` (already established). |

**Cold-archive candidates:** none in v2.62 (v2.43's `.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md` already covers pre-v2.43 history). v2.62 may extend the archive with a `v2.44–v2.60` successor only if active-window compaction alone cannot return the file under `ACTIVE_ROADMAP_LINE_CEILING=120`; otherwise compaction-only is sufficient.

**Warm-compact candidates:** v2.61 closure narrative inside `## Current Milestone` and the trailing `## Completed Milestones` paragraph.

---

## Cross-File Duplication Record (Deferred)

The following cross-file narrative duplication is observed and recorded; **remediation is explicitly deferred to a future milestone** (architectural; would re-litigate v2.43/v2.44 design). v2.62 only allows in-file warm compaction, not cross-file deduplication.

1. **v2.61 closure narrative** is repeated across `.paul/STATE.md` (`### Current Summary`), `.paul/PROJECT.md` (`## Current milestone posture`), `.paul/MILESTONES.md` (`## Completed Milestones` v2.61 row + `## Current / Future Milestone Pointer`), and `.paul/ROADMAP.md` (`## Current Milestone` Phase 264 paragraph + `## Completed Milestones` paragraph). Each surface carries 100–200 lines of closely-related narrative.
2. **Sibling-extraction recipe ratification language** (Phase 244 / 247 / 251 / 255 / 259 / 263 surfacing recipe; Phase 245 / 248 / 252 / 256 / 260 / 264 closure-guardrail recipe) is re-asserted in nearly identical wording across STATE.md, PROJECT.md, MILESTONES.md, and ROADMAP.md.
3. **v2.62 milestone scope description** (cold archive split + active-window compaction; cross-file narrative deduplication deferred; KB targets) is repeated across STATE.md `Last activity`, PROJECT.md `Current milestone posture`, MILESTONES.md `Current / Future Milestone Pointer`, and ROADMAP.md `Current Milestone`.

**Why deferred.** Cross-file deduplication requires a single-source-of-truth contract (likely PROJECT.md as authoritative summary, with STATE.md / MILESTONES.md / ROADMAP.md carrying short pointers). That decision touches every PAUL skill that writes lifecycle artifacts and would re-litigate the v2.43/v2.44 separation-of-concerns rationale. v2.62 stays bounded to archive-and-compact; a future milestone (potentially v2.63+) can take the architectural decision.

---

## Preservation Invariants

Each invariant below cites the concrete dependency surface and the obligation Phase 266 must preserve. Phase 266 verification reruns `tests/helpers/artifact_consistency.sh`, `tests/pi-end-to-end-validation.sh`, and `tests/cross-harness-validation.sh` to prove these invariants hold.

**Invariant — STATE.md `Phase: N of M (Name) — ...` format.** Required for `_ac_extract_state_phase_number` and `_ac_extract_state_phase_slug_part`. Source: `tests/helpers/artifact_consistency.sh:27-52`. Phase 266 obligation: keep the exact one-line format `Phase: N of M (Name) — ...` inside `## Current Position`; do not split, indent, or move it.

**Invariant — STATE.md `Resume file:` line.** Required for `_ac_extract_state_resume_file` and `_ac_check_resume_file`. Source: `tests/helpers/artifact_consistency.sh:53-66, 223-252`. Phase 266 obligation: keep the `Resume file: <path>` line inside `## Session Continuity`; the resolved path must point to a file that exists on disk.

**Invariant — STATE.md `## Session Continuity` section name.** Cross-harness validation requires the section header. Source: `tests/cross-harness-validation.sh:745` (`for section_name in "Project Reference" "Current Position" "Loop Position" "Accumulated Context" "Session Continuity"`). Phase 266 obligation: keep all five `## ` section headers verbatim. Sub-section reorganization inside `## Accumulated Context` is allowed so long as the parent header survives.

**Invariant — STATE.md required `## ` sections.** Required by `tests/cross-harness-validation.sh:741-753`: `Project Reference`, `Current Position`, `Loop Position`, `Accumulated Context`, `Session Continuity`. Phase 266 obligation: preserve all five.

**Invariant — STATE.md `Current Position` field set.** Pi runtime artifact-slice rendering parses `Milestone:`, `Phase:`, `Plan:`, `Status:`, `Last activity:`, `Next action:`, `Resume file:`. Source: `drivers/pi/extensions/artifact-slice-rendering.ts:118` (`patterns: [/^Milestone:/, /^Phase:/, /^Plan:/, /^Status:/, /^Last activity:/, /^Next action:/, /^Resume file:/]`). Phase 266 obligation: keep all seven field labels (line-anchored regex), even if values are compacted.

**Invariant — STATE.md `## Loop Position` graphic.** Pi runtime extracts loop state from this section. Source: `drivers/pi/extensions/artifact-slice-rendering.ts:118` plus the loop graphic in `## Loop Position`. Phase 266 obligation: keep the `PLAN ──▶ APPLY ──▶ UNIFY` graphic + status-line shape inside `## Loop Position`.

**Invariant — PROJECT.md required `## ` sections.** Required by `tests/cross-harness-validation.sh:985-999`: `Description`, `Core Value`. Phase 266 obligation: preserve both. The cross-harness suite also ratifies either `## Scope Snapshot` (preferred) or absence (allowed); current PROJECT.md does not use `## Scope Snapshot`, so the legacy path is in effect — no change required.

**Invariant — MILESTONES.md current-phase mention.** Required by `_ac_check_milestones_pointer`. Source: `tests/helpers/artifact_consistency.sh:121-149`. Phase 266 obligation: keep STATE's current Phase number mentioned inside `.paul/MILESTONES.md` (most naturally inside `## Current / Future Milestone Pointer` or the active-row inside `## Completed Milestones`). Do not remove the mention while compacting verbose paragraphs.

**Invariant — ROADMAP.md current-milestone phase-table membership.** Required by `_ac_check_state_vs_roadmap`. Source: `tests/helpers/artifact_consistency.sh:77-119, 156-...`. Phase 266 obligation: keep the active-milestone phase table inside `.paul/ROADMAP.md` `## Current Milestone` with rows that include the current phase number AND the current phase name slug.

**Invariant — ROADMAP.md active-window line ceiling.** `tap_file_line_ceiling "Repo ROADMAP stays within active-window line budget" "$REPO_ROADMAP" "$ACTIVE_ROADMAP_LINE_CEILING"` with `ACTIVE_ROADMAP_LINE_CEILING=120`. Source: `tests/cross-harness-validation.sh:393-398` and `tests/pi-end-to-end-validation.sh:544-557`. Phase 266 obligation: bring `.paul/ROADMAP.md` total line count back under 120 (currently 144). This is the same root cause as the Path A inherited regression (Pi `not ok 102` / cross-harness `not ok 31`); compaction reconciles it inline.

**Invariant — ROADMAP.md authoritative completed-history archive pointer.** Required by `tests/pi-end-to-end-validation.sh:560-568` and `tests/cross-harness-validation.sh:402-409`: ROADMAP must contain the literal strings `.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md`, `.paul/MILESTONES.md`, and `Detailed completed milestone history through v2.43 is archived`. Phase 266 obligation: do not remove these markers when compacting `## Completed Milestones`.

**Invariant — PALS state authority tag in Pi runtime.** Pi context-injection extension expects a `STATE_AUTHORITY_TAG = "[PALS_STATE_AUTHORITY=.paul/STATE.md]"` constant. Source: `drivers/pi/extensions/pals-context-injection.ts` (referenced in `tests/pi-end-to-end-validation.sh:1130`). Phase 266 obligation: do not change the source of authority for STATE.md (i.e., keep `.paul/STATE.md` as the file Pi treats as authoritative).

**Invariant — CARL session-boundary expectations.** CARL relies on STATE.md `## Session Continuity` field semantics (`Stopped at`, `Next action`, `Resume file`) and on the handoff archive convention under `.paul/handoffs/archive/`. Source: `~/.pi/agent/skills/pals/workflows/resume-project.md` (handoff lifecycle), `.paul/HANDOFF*.md` pattern, `tests/helpers/artifact_consistency.sh:67-76` (`_ac_find_active_handoffs`). Phase 266 obligation: keep all three field labels in `## Session Continuity`, keep the handoff archive directory and naming pattern, and ensure any handoff written during Phase 266 follows the same convention.

**Invariant — full authoritative read fallback.** The PAUL system documents that any reader can fall back to a full read of `.paul/STATE.md`, `.paul/PROJECT.md`, `.paul/MILESTONES.md`, or `.paul/ROADMAP.md` and obtain authoritative lifecycle truth without any tool, runtime, or hidden state. Source: `docs/PI-NATIVE-ARTIFACT-SLICE-CONTRACT.md` (artifact-slice authority/fallback language), `drivers/pi/extensions/artifact-slice-rendering.ts:100-103` (`fallback: ARTIFACT_SLICE_FALLBACK; authority: ARTIFACT_SLICE_AUTHORITY`). Phase 266 obligation: every active artifact MUST stay self-contained and human-readable post-compaction; any archive split MUST include a discoverable archive-pointer line in the live artifact (one-line marker mirroring v2.43 ROADMAP precedent: e.g., `> Pre-v2.44 history archived at .paul/archive/state/STATE-HISTORY-v2.44-v2.60.md`).

**Invariant — Phase 191 anti-regrowth pattern (validation suite shape).** `tap_file_contains_all`, `tap_file_line_ceiling`, archive-pointer presence assertions, occurrence ceilings, semantic anchors. Source: `tests/pi-end-to-end-validation.sh:130-417` (broad usage), `tests/cross-harness-validation.sh:393-409` (ROADMAP active-window block). Phase 267 obligation: mirror this pattern for STATE.md / PROJECT.md per-section budgets and archive-pointer presence; do NOT introduce brittle exact-prose assertions.

---

## Hot/Warm/Cold Split Rules

**Hot (active).** Stays in the live `.paul/*` artifact at full fidelity. Lifecycle-critical, helper-critical, runtime-critical, or small-and-stable. Hot sections are the named structural sections required by the preservation invariants above. Hot rows are current-milestone rows (v2.62) plus the just-closed milestone (v2.61) where the closed-milestone row is needed for context continuity.

**Warm (compact-in-place).** Stays in the live artifact but is rewritten more concisely. Allowed transformations: collapse multi-paragraph narrative cells into bounded one-liners; replace verbose closure-recipe ratification language with `<recipe-name> ratified ×N (Phase A/B/C/...)`; replace per-PR detail with PR-number lists; route long detail to a single canonical surface (typically PROJECT.md or a SUMMARY in `.paul/phases/...`) with a cross-reference. Cross-file deduplication is **not** allowed (deferred).

**Cold (archive).** Removed from the live artifact and moved to `.paul/archive/...`. The live artifact retains a one-line archive pointer at the end of the section it belonged to (or the file's `## Archive` block). Cold rows are pre-v2.61 entries in STATE.md `### Current Summary` / `### Current Decisions` / `### Fixes / Deviations / Skill Audits` and pre-v2.55 entries in PROJECT.md `## Current milestone posture` / `## Key current decisions`. MILESTONES.md and ROADMAP.md have no v2.62 cold-archive obligation (precedents at v2.43 and v2.42 already cover their cold history); they get warm compaction only.

**Decision rule.** A row is cold iff (a) it describes a milestone ≤ v2.60 (i.e., not v2.61 just-closed and not v2.62 active) AND (b) the same factual claim is preserved in the corresponding archive file (with archive cross-reference) OR is no longer load-bearing for any current PALS workflow. Otherwise the row is warm or hot.

---

## Archive Structure

Archive root: `.paul/archive/`. Existing structure (already populated):

- `.paul/archive/INDEX.md` — top-level index of archived history.
- `.paul/archive/state/STATE-HISTORY-v0-v2.43.md` (~41 KB) — pre-v2.44 STATE.md history.
- `.paul/archive/project/PROJECT-HISTORY.md` — pre-v2.55 PROJECT.md history.
- `.paul/archive/milestones/MILESTONES-v0-v2.42.md` — pre-v2.43 milestones.
- `.paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md` (~28 KB) — pre-v2.44 ROADMAP history.
- `.paul/archive/roadmap/v2.44-pals-context-optimization-process-artifacts.md` — milestone-level archive note from v2.44.

**Phase 266 archive additions.**

- `.paul/archive/state/STATE-HISTORY-v2.44-v2.60.md` (new) — pre-v2.61 cold rows lifted from STATE.md `### Current Summary` / `### Current Decisions` / `### Fixes / Deviations / Skill Audits`. File MUST start with a header naming the version range and a back-pointer to the live `.paul/STATE.md`.
- (Optional) `.paul/archive/project/PROJECT-HISTORY-v2.55-v2.60.md` — pre-v2.61 cold rows lifted from PROJECT.md `## Current milestone posture` / `## Key current decisions`. Optional: if PROJECT.md compaction lands under budget without lifting any rows out, this file is not created.
- (Optional) `.paul/archive/milestones/...` — none expected; v2.43 archive already covers pre-v2.43.
- (Optional) `.paul/archive/roadmap/...` — none expected; v2.43 archive already covers pre-v2.43.
- `.paul/archive/INDEX.md` — append entries for any new archive file.

**Archive-pointer line format.** Mirroring the v2.43 ROADMAP precedent (`Detailed completed milestone history through v2.43 is archived in .paul/archive/roadmap/ROADMAP-HISTORY-v0-v2.43.md`), each live artifact that loses cold rows MUST gain a one-line pointer of the form:

```
> Pre-v2.61 history archived at .paul/archive/state/STATE-HISTORY-v2.44-v2.60.md.
```

placed at the end of the section the rows were lifted from (preferred) or in the artifact's `## Archive` block (acceptable fallback). Phase 267 anti-regrowth assertions check for the literal archive path string in the live artifact.

---

## Per-Section Live-Byte Budgets

Budgets are stated in **bytes** (matching `wc -c`). Per-section budgets sum to the file-level target with ~5–10% headroom for natural lifecycle growth across a milestone. Phase 267 anti-regrowth assertions enforce these as line ceilings (`tap_file_line_ceiling`) calibrated against the byte target with a representative average line length of ~80 bytes; the byte target is the contract truth and the line ceiling is the validation form.

### `.paul/STATE.md` — file target ≤ 20 KB (currently ~98 KB)

| Section | Live-byte budget | Notes |
|---|---:|---|
| `## Project Reference` | 0.3 KB | Tiny; no change. |
| `## Current Position` | 3.0 KB | Hot-path. Hold milestone/phase/plan/status/Last-activity/progress block. |
| `## Loop Position` | 0.5 KB | Hot-path. Loop graphic + one status line. |
| `## Accumulated Context` → `### Current Summary` (`live_summary`) | 4.0 KB | v2.62 + v2.61 rows hot; older rows archived. |
| `## Accumulated Context` → `### Current Decisions` (`decisions`) | 4.0 KB | v2.62 + v2.61 rows hot; older rows archived. |
| `## Accumulated Context` → `### Fixes / Deviations / Skill Audits` (`fixes`) | 3.0 KB | v2.62 + v2.61 rows hot; older rows archived. |
| `## Accumulated Context` → `### Deferred Issues` | 0.7 KB | Small. |
| `## Accumulated Context` → `### Blockers/Concerns` (`blockers`) | 0.5 KB | Small. |
| `## Accumulated Context` → `### Git State` (`git_state`) | 0.7 KB | Small. |
| `## Session Continuity` | 1.5 KB | `Stopped at` / `Next action` / `Resume file` plus continuity block. |
| Archive pointer line(s) | 0.1 KB | Mandatory. |
| **Sum of per-section budgets** | **~18.3 KB** | Headroom under 20 KB. |
| **File-level target** | **≤ 20 KB** | |

### `.paul/PROJECT.md` — file target ≤ 25 KB (currently ~67 KB)

| Section | Live-byte budget | Notes |
|---|---:|---|
| `## Description` | 0.3 KB | Tiny. |
| `## Core Value` | 0.3 KB | Tiny. |
| `## Current focus` (`active_summary`) | 1.5 KB | Hot-path entry-point summary; bounded. |
| `## Hot-path reading model` | 1.5 KB | Bounded; structural. |
| `## Active requirements summary` | 2.0 KB | Bounded snapshot. |
| `## Current milestone posture` (`milestone_posture`) | 8.0 KB | v2.62 + v2.61 hot; v2.55–v2.60 compacted to one-liners or lifted to archive. |
| `## Constraints` | 1.0 KB | Bounded. |
| `## Key current decisions` (`key_decisions`) | 8.0 KB | v2.55–v2.62 retained as one-liners; pre-v2.55 archived. |
| `## Success Criteria` | 0.7 KB | Small. |
| `## Specialized Flows` | 1.0 KB | Bounded. |
| `## Archive` | 0.5 KB | Pointer block. |
| Archive pointer line(s) | 0.1 KB | Mandatory if any rows are lifted. |
| **Sum of per-section budgets** | **~24.4 KB** | Headroom under 25 KB. |
| **File-level target** | **≤ 25 KB** | |

### `.paul/MILESTONES.md` — file target ≤ 18 KB (currently ~30 KB)

Warm-only file (no v2.62 cold archive). `## Live Status` ≤ 1 KB; `## Completed Milestones` ≤ 12 KB (compact verbose v2.61 row to a one-liner with summary cross-reference); `## Current / Future Milestone Pointer` ≤ 3 KB (compact verbose paragraphs); `## Archive` ≤ 0.5 KB.

### `.paul/ROADMAP.md` — file target ≤ 12 KB AND ≤ 120 lines (currently ~32 KB / 144 lines)

Warm-only file (no v2.62 cold archive; v2.43 archive already covers pre-v2.44 history). `## Overview` + `## Milestones` ≤ 2 KB; `## Current Milestone` ≤ 6 KB (compact Phase 264 closure paragraph to one-liner with cross-reference to MILESTONES.md / SUMMARY); `## Completed Milestones` ≤ 3 KB (already a single trailing paragraph; compact). The active-window line ceiling `ACTIVE_ROADMAP_LINE_CEILING=120` is the Phase 191 invariant and is the authoritative validation form for this file.

### Aggregate Hot-Path Resume Read Target

**STATE + PROJECT + MILESTONES + ROADMAP combined ≤ 80 KB.**
- Baseline: 227 KB.
- Per-file targets sum: 20 + 25 + 18 + 12 = 75 KB (5 KB headroom under 80 KB).
- Reduction: ~65% from baseline.

---

## Phase 266 Handoff

**Allowed file scope.**
- `.paul/STATE.md`
- `.paul/PROJECT.md`
- `.paul/MILESTONES.md`
- `.paul/ROADMAP.md`
- New archive files under `.paul/archive/state/` and (optionally) `.paul/archive/project/`.
- `.paul/archive/INDEX.md` (append-only entries for new archive files).
- PAUL lifecycle artifacts generated by APPLY/UNIFY (`.paul/phases/266-archive-compact-hot-artifacts/266-01-PLAN.md`, `266-01-SUMMARY.md`, STATE/ROADMAP/PROJECT status updates routine to PAUL lifecycle).

**Forbidden scope.**
- Workflow files in `kernel/workflows/` and installed skills under `~/.pi/agent/skills/pals/*`.
- Runtime/source files in `drivers/pi/extensions/`, `kernel/references/`, `modules/`, or any driver implementation.
- `tests/pi-end-to-end-validation.sh`, `tests/cross-harness-validation.sh`, `tests/helpers/*` — Phase 266 is `.paul/*` mutation only; structural anti-regrowth assertions land in Phase 267.
- Install/uninstall scripts, dependency manifests/lockfiles, CI configuration.
- Any cross-file narrative deduplication (deferred).
- README/Pi docs/skill-map surfacing (deferred).

**Recipe-application guidance (Write-over-Edit).** Phase 266 mutates large files (STATE.md ~98 KB; PROJECT.md ~67 KB). Many sequential `Edit` calls would risk hash-drift between reads. Prefer the v2.43 archive-and-compact recipe pattern:

1. Read the live artifact in full and identify cold rows by section.
2. Append cold rows to the new archive file via a single `Write` (creating the archive file) or extend an existing archive file via a single `Edit` at end-of-file.
3. Compute the new compacted hot artifact content offline (in working memory).
4. Overwrite the live artifact via a single `Write` call (one Write per file).
5. Insert the archive-pointer line at the end of the section the rows came from.
6. Run `tests/helpers/artifact_consistency.sh` after each file mutation; halt and revert on failure.

**Path A inherited regression reconciliation.** Pi `not ok 102` and cross-harness `not ok 31` (ROADMAP active-window line-budget violation) share the same root cause as the active-window compaction obligation in this contract. They reconcile inline as `.paul/ROADMAP.md` is brought under `ACTIVE_ROADMAP_LINE_CEILING=120` during Phase 266 ROADMAP warm compaction. **No separate `/paul:fix` is required.** Phase 266 SUMMARY.md MUST record the Pi/cross-harness count delta showing both `not ok` lines flipping to `ok`.

**Validation gates.**
- `tests/helpers/artifact_consistency.sh` MUST PASS after each file mutation and at end-of-phase.
- `tests/pi-end-to-end-validation.sh` rerun at end-of-phase; `not ok 102` flips to `ok` once ROADMAP is compacted.
- `tests/cross-harness-validation.sh` rerun at end-of-phase; `not ok 31` flips to `ok` once ROADMAP is compacted.
- `git diff --check` clean.
- All preservation invariants from this contract pass focused marker checks.

---

## Phase 267 Handoff

**Allowed file scope.**
- `tests/pi-end-to-end-validation.sh` — bounded structural anti-regrowth assertions only (mirroring Phase 191 pattern: `tap_file_contains_all`, `tap_file_line_ceiling`, occurrence ceilings, archive-pointer presence). No exact-prose assertions.
- `tests/cross-harness-validation.sh` — one bounded shared-invariant closure block (the **7th application** of the closure-guardrail recipe: Phase 245 / 248 / 252 / 256 / 260 / 264 / **267**).
- `.paul/MILESTONES.md`, `.paul/PROJECT.md`, `.paul/ROADMAP.md` — v2.62 closure aggregation per the established recipe.
- PAUL lifecycle artifacts generated by APPLY/UNIFY (`.paul/phases/267-validation-guardrails-evidence-closure/267-01-PLAN.md`, `267-01-SUMMARY.md`).

**Forbidden scope.**
- `tests/helpers/*` (no helper-shape changes; Phase 267 only adds bounded TAPs to the suites).
- `drivers/`, `modules/`, `kernel/`, installed skills (no source / runtime / workflow changes).
- Install/uninstall, dependency, CI changes.

**Expected validation count change.**
- Pi: `+N` localized anti-regrowth TAPs covering (a) per-section budgets defined here (STATE.md `live_summary` / `decisions` / `fixes` / `blockers` / `git_state`; PROJECT.md `active_summary` / `milestone_posture` / `key_decisions`), (b) archive-pointer presence in the live artifact for each archive file created in Phase 266, (c) STATE.md and PROJECT.md file-level line ceilings calibrated against the byte targets here. Recommended `N = 8 ± 2`. Phase 266's ROADMAP active-window flip already reconciles `not ok 102 → ok` in Phase 266; Phase 267 ratifies the budget rather than creating a new TAP for ROADMAP.
- Cross-harness: `+1` shared-invariant closure block (the **7th application** of the closure-guardrail recipe). The closure block aggregates v2.62 closure evidence (PR refs, validation count deltas, install-surface unchanged, artifact_consistency PASS, Path A inherited regression resolved) per the precedent set by Phase 245 / 248 / 252 / 256 / 260 / 264.
- `not ok` lines: Path A inherited regression (Pi `not ok 102` / cross-harness `not ok 31`) MUST already be `ok` after Phase 266 — Phase 267 confirms and ratifies, not introduces.

**Anti-regrowth pattern reuse (Phase 191 lineage).**
- `tap_file_contains_all` for archive-pointer marker presence.
- `tap_file_line_ceiling` for per-section / per-file line budgets.
- Bounded occurrence ceilings (e.g., max N occurrences of `### Current Summary` block markers).
- Short semantic anchors (e.g., `> Pre-v2.61 history archived at`).
- **No** brittle exact-prose assertions; **no** byte-exact regex over verbose narrative.

**v2.62 closure aggregation.** Phase 267 SUMMARY.md aggregates v2.62 closure evidence in MILESTONES.md / PROJECT.md / ROADMAP.md per the established closure recipe. Recommended-not-approved v2.63 candidate (e.g., cross-file narrative deduplication, or a workflow-file context-diet) is recorded in the closure paragraph.

---

## Out of Scope (Future Approved Plans Only)

The following are **not** addressed by v2.62 and require separate approved milestones:

- **Cross-file narrative deduplication.** Architectural; would re-litigate v2.43/v2.44 separation-of-concerns. Most natural target: PROJECT.md as authoritative cross-file summary, with STATE.md / MILESTONES.md / ROADMAP.md carrying short pointers.
- **Workflow-file context diet.** `kernel/workflows/`, `kernel/references/`, and installed skills (`~/.pi/agent/skills/pals/*`) are out of scope. Hot-workflow line ceilings already exist (`HOT_CONTEXT_SOURCE_SET_LINE_CEILING=2100`); a context-diet milestone would lower the ceiling and remove or compact prose.
- **Runtime / source / driver changes.** No `drivers/pi/extensions/` modifications.
- **Broader cross-harness validation-suite decomposition (Track A).** Deferred from Phase 264 recommendation; recipe-drift risk too high for a 1431-line test refactor as a v2.62 task.
- **S4 canonical reply delivery extraction.** Per-sibling S1–S8 wave closed except S4; S4 is the integration point and was explicitly deferred through every prior milestone.
- **Full Claude Code / Agent SDK driver removal.** Still blocked per `docs/PI-NATIVE-LEGACY-RETENTION-INSTALL-SURFACE-CLEANUP-CONTRACT.md`.
- **Local context-cost evidence.** Potential v2.63 if Phase 267 measurement reveals more pain.
- **Demo project preset.**
- **README / Pi docs / skill-map surfacing of this contract.** Deferred to a future milestone; v2.62 keeps the contract internal to the docs catalog.

---

## Status After Phase 265

Phase 265 (this artifact) is **the contract baseline**. It is docs-only and produces no `.paul/*` mutation. Phase 266 applies the contract; Phase 267 ratifies it with anti-regrowth validation guardrails and v2.62 closure aggregation.

*Created: 2026-05-07 — Phase 265, v2.62 PALS Context Diet — STATE & Hot-Path Compression.*
