# PALS Plannotator UI Integration Contract

## Status

This contract is the authoritative implementation boundary for PALS v2.66 Plannotator Integration — Rich UI Review Surfaces after Phase 284 UNIFY.

It defines what PALS consumes from `@plannotator/pi-extension`, what PALS explicitly does not adopt, where Plannotator review content may be recorded, and how downstream phases must preserve `.paul/*` lifecycle authority.

Authority lineage: this follows the v2.65 contract-over-research pattern established in Phase 279 (`docs/PALS-FUNCTIONAL-FIRST-AGENT-GUIDANCE-CONTRACT.md`). Upstream Plannotator README text, source code, event payloads, and runtime observations are provenance/background for this contract; they do not become authoritative PALS behavior unless this contract says PALS consumes them.

Last updated: 2026-05-14.
Kernel/config context: PALS `pals.json` schema `2.0.0`; PALS project currently runs in Pi 0.74 context, satisfying Plannotator's Pi `>= 0.53.0` requirement.

Source Evidence:

- `https://raw.githubusercontent.com/backnotprop/plannotator/main/apps/pi-extension/README.md` documents Pi `>= 0.53.0`, the shared event API, async plan-review behavior, `/plannotator-*` commands, and `--plan` mode.
- `https://raw.githubusercontent.com/backnotprop/plannotator/main/apps/pi-extension/plannotator-events.ts` defines the event constants, request/result types, status store, listener registration, and emitted result fields.
- `https://raw.githubusercontent.com/backnotprop/plannotator/main/apps/pi-extension/index.ts` registers `/plannotator`, `/plannotator-status`, `/plannotator-review`, `/plannotator-annotate`, `/plannotator-last`, `/plannotator-archive`, and the `plannotator_submit_plan` tool.
- `https://raw.githubusercontent.com/backnotprop/plannotator/main/apps/pi-extension/server/serverPlan.ts` shows plan-review `reviewId` creation, approve/deny result publication, `savedPath` assignment, and decision waiting.
- `https://raw.githubusercontent.com/backnotprop/plannotator/main/apps/pi-extension/plannotator-browser.ts` shows browser-session wait/stop behavior and exposed `PlanReviewDecision` fields.

## Scope

This contract covers:

- the event surface PALS may emit to Plannotator;
- the result fields PALS may consume from Plannotator;
- the race-recovery pattern PALS may use for async plan review;
- advisory sidecar artifact contracts under `.paul/phases/N/`;
- non-adopted Plannotator surfaces;
- opt-in rules;
- validation classification;
- failure modes;
- feedback incorporation rules for downstream Phases 285–287.

This contract does not cover:

- Plannotator internal UI behavior except where PALS explicitly depends on it;
- Plannotator's internal phase machine, config schema, storage schema, prompt text, archive browser, or note-export integrations;
- Plannotator behavior added after this contract unless a later PALS plan updates this contract;
- bridge helper signatures, TypeScript types, implementation bodies, or workflow instruction text beyond naming/scoping; Phases 285–287 own those details.

## Authority Hierarchy

For v2.66 Plannotator work, resolve conflicts in this order:

1. `docs/PALS-PLANNOTATOR-UI-INTEGRATION-CONTRACT.md` — authoritative for what PALS consumes, ignores, records, and prompts.
2. `.paul/*` lifecycle artifacts — authoritative for PALS project state, PLAN/APPLY/UNIFY truth, summaries, handoffs, and roadmap status.
3. Plannotator README/source/event payloads — provenance and compatibility evidence only.
4. Advisory sidecars such as `.paul/phases/N/PLAN-REVIEW-NOTES.md`, `.paul/phases/N/PLAN-FEEDBACK-{iteration}.md`, and `.paul/phases/N/CODE-REVIEW-NOTES.md` — review evidence only; never lifecycle truth.

If a sidecar, `savedPath`, or Plannotator event conflicts with `.paul/STATE.md`, the `.paul/*` lifecycle artifact wins unless a later approved PALS plan explicitly changes the lifecycle artifact.

## Consumed Event Surface

PALS may integrate with Plannotator through Pi's extension event bus, not by importing Plannotator internals.

Source Evidence:

- `plannotator-events.ts` defines `PLANNOTATOR_REQUEST_CHANNEL = "plannotator:request"` and `PLANNOTATOR_REVIEW_RESULT_CHANNEL = "plannotator:review-result"`.
- `registerPlannotatorEventListeners(pi)` installs `pi.events.on(PLANNOTATOR_REQUEST_CHANNEL, ...)` and emits async plan-review results with `pi.events.emit(PLANNOTATOR_REVIEW_RESULT_CHANNEL, reviewResult)`.
- The upstream README's "Shared Plannotator event API" section says other extensions can reuse browser review flows through `plannotator:request` without importing internals.

### Request channel

Channel: `plannotator:request`.

Request envelope shape, as consumed from `plannotator-events.ts`:

```ts
{
  requestId: string;
  action: PlannotatorAction;
  payload: unknown;
  respond: (response: PlannotatorResponse<unknown>) => void;
}
```

Response envelope shape:

```ts
type PlannotatorResponse<T> =
  | { status: "handled"; result: T }
  | { status: "unavailable"; error?: string }
  | { status: "error"; error: string };
```

PALS consumes only these actions:

### `plan-review`

Payload PALS may send:

```ts
{
  planFilePath?: string;
  planContent: string;
  origin?: string;
}
```

Upstream currently validates only non-empty `planContent` in `plannotator-events.ts`; `planFilePath` and `origin` are part of the exposed type but not required by the event listener. PALS should provide `planContent` from the authoritative PALS PLAN.md and may include `planFilePath`/`origin` only as advisory context.

Immediate handled response:

```ts
{
  status: "handled";
  result: {
    status: "pending";
    reviewId: string;
  };
}
```

The `reviewId` is the only authoritative handle for async recovery. `server/serverPlan.ts` creates it with `randomUUID()` for each started review server/session, so each re-emitted review request should be treated as a fresh review with a fresh `reviewId`.

### `review-status`

Payload PALS may send:

```ts
{
  reviewId: string;
}
```

Handled result shape:

```ts
type PlannotatorReviewStatusResult =
  | { status: "pending" }
  | ({ status: "completed" } & PlannotatorReviewResultEvent)
  | { status: "missing" };
```

PALS may use this after receiving a `reviewId` to recover from an event-listener race, session restart, or missed `plannotator:review-result` event. It is not an extension-presence probe for new sessions: `review-status` itself requires a working request listener to respond.

Upstream storage note: `plannotator-events.ts` writes status into `~/.pi/plannotator-review-status.json`. PALS must treat that as Plannotator-owned transient compatibility state, not PALS lifecycle state.

### `code-review`

Payload PALS may send in Phase 287:

```ts
{
  diffType?: DiffType;
  defaultBranch?: string;
  vcsType?: VcsSelection;
  useLocal?: boolean;
  cwd?: string;
  prUrl?: string;
}
```

Handled result shape from `plannotator-events.ts`:

```ts
{
  approved: boolean;
  feedback?: string;
  annotations?: unknown[];
  agentSwitch?: string;
}
```

`code-review` is request/response, not the async `plannotator:review-result` path. PALS consumes only `approved` and `feedback` for v2.66. `annotations` may be preserved as opaque source evidence in `CODE-REVIEW-NOTES.md` only if Phase 287 explicitly chooses to record it; it must not become lifecycle truth.

## Result Protocol

### Async plan-review result event

Channel: `plannotator:review-result`.

Result shape from `plannotator-events.ts`:

```ts
interface PlannotatorReviewResultEvent {
  reviewId: string;
  approved: boolean;
  feedback?: string;
  savedPath?: string;
  agentSwitch?: string;
  permissionMode?: string;
}
```

PALS consumes:

- `reviewId` — match the result to the pending review request.
- `approved` — route approve vs feedback/re-plan behavior.
- `feedback` — write advisory notes/feedback sidecars.
- `savedPath` — optional advisory input only, governed by the `savedPath` Policy section.

PALS ignores:

- `agentSwitch` — not adopted; PALS does not let Plannotator select PAUL skills, agents, or routing.
- `permissionMode` — not adopted; PALS does not let Plannotator alter Pi/PALS permission mode or execution authority.
- any future fields — ignored unless this contract is updated.

Both consumed and ignored fields must be listed in downstream implementation comments or tests where practical so new upstream fields do not silently expand PALS authority.

### Race recovery

Plan-review is async:

1. PALS emits `plannotator:request` with `action: "plan-review"` and a `respond` callback.
2. Plannotator opens the browser UI and responds immediately with `{ status: "handled", result: { status: "pending", reviewId } }`.
3. Plannotator stores `{ status: "pending" }` for `reviewId`.
4. On approve/deny, Plannotator stores `{ status: "completed", ...reviewResult }` and emits `plannotator:review-result`.
5. If PALS misses the event or starts listening late, PALS may emit `review-status` for the same `reviewId`.

PALS policy:

- Register/prepare its result listener before sending `plan-review` whenever Phase 285's bridge can do so.
- If `plan-review` returns `handled/pending`, wait for `plannotator:review-result` for the same `reviewId`.
- If the wait times out or the listener may have raced, query `review-status` once or on a bounded retry schedule before classifying the UI as abandoned.
- `review-status: completed` is equivalent to receiving `plannotator:review-result`.
- `review-status: pending` means the UI session has not produced a decision yet.
- `review-status: missing` means Plannotator has no stored result for that `reviewId`; PALS should classify this as failed/recoverable bridge evidence, not approval.

The numeric timeout value is intentionally not fixed in Phase 284. Phase 285 may parameterize it.

## Non-Adoption Surface

PALS explicitly does not adopt these Plannotator surfaces:

- `--plan` mode — Plannotator's file-based planning mode changes agent tool/write behavior; PALS already owns PLAN/APPLY/UNIFY lifecycle and `.paul/*` authority.
- `plannotator_submit_plan` tool — Plannotator's plan-submission tool is for Plannotator's own planning mode; PAUL plans are submitted/reviewed through PALS workflow prompts and the bridge.
- Internal phase machine (`idle → planning → executing`) — PALS loop state remains `PLAN → APPLY → UNIFY` in `.paul/STATE.md` and approved plan artifacts.
- `plannotator.json` per-phase config — PALS does not adopt Plannotator's config model; PALS opt-in belongs under `pals.json` integration settings.
- `agentSwitch` result field — ignored because PALS owns agent/skill routing.
- `permissionMode` result field — ignored because PALS/Pi permission mode is not delegated to review UI output.
- Plannotator `/plannotator-annotate` — users may run `/plannotator-annotate <path>` directly for ad-hoc annotation; PALS does not add `/paul:annotate` or any wrapper command in v2.66.
- Plannotator archive/history/note-export integrations — not consumed by PALS lifecycle or sidecar authority.

Source Evidence:

- `index.ts` registers Plannotator's plan mode command, status command, code-review command, annotation command, archive command, and `plannotator_submit_plan` tool.
- `tool-scope.ts` defines `PLAN_SUBMIT_TOOL = "plannotator_submit_plan"` and planning-only tool scoping.
- `README.md` documents `/plannotator`, `--plan`, `/plannotator-review`, `/plannotator-annotate`, and related commands.

## Advisory Sidecar Contracts

All sidecars are advisory evidence only. They may inform a later PAUL step, but `.paul/STATE.md`, PLAN.md, SUMMARY.md, ROADMAP.md, and approved workflow transitions remain authoritative.

### `.paul/phases/N/PLAN-REVIEW-NOTES.md`

Canonical path pattern:

```text
.paul/phases/{phase-slug}/PLAN-REVIEW-NOTES.md
```

Writer: Phase 286 `/paul:plan` workflow integration.

Written when: Plannotator returns `approved: true` with non-empty `feedback` during plan review.

Required fields/content:

- phase and plan identifier;
- Plannotator `reviewId`;
- ISO timestamp;
- approval state (`approved: true`);
- feedback text;
- optional `savedPath` reference;
- statement that the file is advisory evidence only.

Lifecycle status: APPLY may read it as advisory context if present, but it never overrides PLAN.md or `.paul/STATE.md`.

### `.paul/phases/N/PLAN-FEEDBACK-{iteration}.md`

Canonical path pattern:

```text
.paul/phases/{phase-slug}/PLAN-FEEDBACK-{iteration}.md
```

Writer: Phase 286 `/paul:plan` workflow integration.

Written when: Plannotator returns `approved: false` for a plan-review surface.

Required fields/content:

- phase and plan identifier;
- iteration number;
- Plannotator `reviewId`;
- ISO timestamp;
- approval state (`approved: false`);
- feedback text;
- optional `savedPath` reference;
- if `savedPath` is read, bounded excerpt/summary or explicit note that it was not read;
- statement that the file is advisory input to PAUL re-planning, not direct PLAN.md replacement.

Lifecycle status: the next `/paul:plan` turn treats this feedback file as required reading and re-derives PLAN.md through PAUL. The sidecar remains audit evidence after approval.

### `.paul/phases/N/CODE-REVIEW-NOTES.md`

Canonical path pattern:

```text
.paul/phases/{phase-slug}/CODE-REVIEW-NOTES.md
```

Writer: Phase 287 `/paul:apply` and/or `/paul:unify` workflow integration, depending on the review surface.

Written when: Plannotator code review returns feedback worth preserving, whether approval-with-notes or denial/change-request feedback.

Required fields/content:

- phase and plan identifier;
- review surface (`apply` or `unify`);
- ISO timestamp;
- approval state;
- feedback text;
- diff/review mode requested (`diffType`, `cwd`, PR URL, or equivalent context when available);
- optional opaque annotation count or reference if Phase 287 chooses to preserve `annotations`;
- statement that the file is advisory evidence only.

Lifecycle status: UNIFY may read it as advisory context if present, but it does not route automatically to `/paul:fix`, does not block merge by itself, and never overrides GitHub Flow, WALT/TODD/DEAN, or `.paul/*` lifecycle gates.

## `savedPath` Policy

`savedPath` is advisory input only.

Source Evidence:

- `server/serverPlan.ts` sets `savedPath = saveFinalSnapshot(...)` on approve and deny when plan saving is enabled, then returns/emits `savedPath` with the decision.
- The same source calls `saveAnnotations(...)` with feedback/annotations and `saveFinalSnapshot(...)` with the original plan content plus annotations/feedback.
- The implementation imports `saveFinalSnapshot` from `../generated/storage.js`, but that generated storage implementation was not available from the upstream raw source inspected during Phase 284.

Contract decision:

- PALS may record the `savedPath` string in advisory sidecars.
- PALS may read the file at `savedPath` only as advisory input if Phase 286/287 explicitly chooses to do so.
- PALS must never directly copy, rename, or adopt the `savedPath` file as PLAN.md, SUMMARY.md, STATE.md, ROADMAP.md, or any lifecycle truth.
- On plan denial, PAUL re-enters `/paul:plan` with `PLAN-FEEDBACK-{iteration}.md` as required reading and regenerates PLAN.md from PALS rules.
- On approve-with-feedback, PAUL writes `PLAN-REVIEW-NOTES.md` and proceeds according to the approved PALS loop.

Unresolved source detail: exact serialized file format at `savedPath` is unresolved from the raw upstream source available in Phase 284 because `generated/storage.js` was not available. Deferred to Phase 285 empirical probe or installed-package inspection. Until resolved, PALS must treat `savedPath` as opaque.

## Opt-In Mechanism

Plannotator integration has two opt-in layers:

1. Project-level enablement in `pals.json`:

```json
{
  "integrations": {
    "plannotator": {
      "enabled": false,
      "surfaces": "both"
    }
  }
}
```

`integrations.plannotator.enabled` defaults to `false`. Optional `integrations.plannotator.surfaces` may be `"plan-review"`, `"code-review"`, `"both"`, or `"none"`; if enabled and omitted, downstream phases may treat the default as `"both"`.

Phase 284 documents these keys only. It does not modify `pals.json`; Phase 285+ may add defaults through an approved plan, and per-project enablement remains user-driven.

2. Per-invocation prompt at each review surface:

```text
Run Plannotator review? [y/n]
```

The prompt is required even when project-level config enables the integration. Configuration may make a surface available or unavailable, but it must not auto-confirm a review. Declining costs zero overhead: no event emitted, no sidecar written, and the workflow proceeds exactly as it did before v2.66.

## Validation Classification

Validation classification follows the Phase 196 / v2.51 taxonomy:

- Helper delegation + Pi-supported runtime.
- Pi-only milestone.
- Cross-harness driver support is retired/out of scope for v2.66.
- Minimum Plannotator Pi requirement: Pi `>= 0.53.0` from upstream README.
- Current project context: Pi 0.74, so no pinning or compatibility downgrade work is needed in Phase 284.

Phase 285 validates the bridge against Pi extension runtime behavior. Phases 286–287 validate workflow instruction behavior and sidecar generation. Phase 284 validates only the contract text and source evidence.

## Failure Modes

### Extension absent or not loaded

Expected behavior: graceful skip + install nudge.

PALS should not fail the lifecycle because Plannotator is absent. The bridge should report that the integration is unavailable and the workflow should continue without sidecar output, mirroring CODI-style optional/advisory absence.

Open implementation detail: a robust extension-presence probe is unresolved from Phase 284 source inspection. `plannotator-events.ts` exposes a listener and response statuses, but Pi event-listener introspection was not evident in the upstream source. Deferred to Phase 285 empirical probe. Candidate strategy: emit a bounded request with a `respond` callback and short timeout, treating no callback as absent/unavailable; Phase 285 must verify this is safe in Pi 0.74 before adopting it.

### User declines per-invocation prompt

Expected behavior: zero overhead.

No event is emitted, no browser opens, no sidecar is written, and the workflow proceeds with current PALS behavior.

### UI closed without submitting

Source Evidence:

- `plannotator-browser.ts` exposes browser session `stop()` and rejects waits with `"Plannotator browser session was stopped."` when the session is stopped by code.
- `server/serverPlan.ts` resolves plan-review decisions only through approve/deny routes and publishes decisions only from those routes.
- No explicit abandoned/closed plan-review result event was found in the raw upstream source inspected during Phase 284.

Contract policy: UI-abandoned behavior is a PALS timeout classification, not an upstream result state. Phase 285 should implement a configurable timeout and bounded `review-status` check. If no decision is recovered, PALS should treat the review as abandoned/not approved, write advisory evidence if the downstream workflow has a place for it, and continue through PAUL-owned routing. The numeric timeout value is deferred to Phase 285.

### Event emitted before listener is ready

Expected behavior: recover with `review-status` when a `reviewId` exists.

PALS should prepare its listener before emitting `plan-review` where possible. If a result event is missed after `reviewId` is known, PALS queries `review-status` for that `reviewId` and consumes `completed` as equivalent to the event.

### Plannotator returns `unavailable` or `error`

Expected behavior: graceful skip unless the user explicitly asked for Plannotator review as a blocking/manual step.

Record compact advisory evidence in the current workflow output. Do not mutate `.paul/STATE.md` to reflect Plannotator internals. Do not retry indefinitely.

## Feedback Incorporation Protocol

When plan review returns:

```ts
{ approved: false, feedback, savedPath? }
```

PAUL must:

1. Write `.paul/phases/{phase-slug}/PLAN-FEEDBACK-{iteration}.md` with feedback text, `reviewId`, ISO timestamp, iteration number, and optional `savedPath` reference.
2. Treat that feedback file as required reading for the next `/paul:plan` turn.
3. Regenerate PLAN.md through PAUL planning rules.
4. Preserve every feedback file as an audit trail.
5. Never directly adopt `savedPath` as PLAN.md.

When plan review returns:

```ts
{ approved: true, feedback: "...", savedPath? }
```

PAUL must:

1. Write `.paul/phases/{phase-slug}/PLAN-REVIEW-NOTES.md` with feedback text, `reviewId`, ISO timestamp, and optional `savedPath` reference.
2. Proceed to APPLY.
3. Let APPLY read `PLAN-REVIEW-NOTES.md` as advisory context if Phase 286 adds that required-reading note.

When code review returns feedback, Phase 287 owns the exact workflow placement, but the recorded artifact is `.paul/phases/{phase-slug}/CODE-REVIEW-NOTES.md` and remains advisory.

## Architectural Lineage

This integration reuses existing PALS architectural patterns:

- v2.65 Phase 279 contract-over-research authority hierarchy: this contract wins over research/source ambiguity.
- v2.65 installed-resource marker check pattern: Phase 285 may use similar marker checks for installed Plannotator/Pi extension resources.
- v2.63 section-by-section workflow rewrite pattern: Phases 286–287 should edit only the relevant workflow sections rather than rewrite whole workflows.
- v2.56–v2.61 sibling Pi-extension extraction recipe and loader-compat invariant: Phase 285 bridge work belongs under `drivers/pi/extensions/` and must preserve Pi loader compatibility.
- CODI optional/advisory absence posture: Plannotator is optional, opt-in, and graceful when unavailable.

## Out of Scope for v2.66

The following are out of scope for v2.66:

- non-PAUL markdown plan review;
- automatic routing to `/paul:fix`;
- cross-harness driver support;
- Stage CLI integration;
- Validation Hygiene, deferred as a v2.67 candidate;
- REV/Plannotator merger;
- `.paul/*` authority modification;
- adoption of Plannotator's `--plan` mode;
- adoption of Plannotator's internal phase machine;
- adoption of `plannotator_submit_plan`;
- adoption of `plannotator.json`;
- new PALS module manifest entries for Plannotator;
- new `/paul:*` commands such as `/paul:annotate`;
- production code changes in Phase 284.

## Source Evidence

Phase 284 source investigation resolved or explicitly deferred these questions:

1. Event delivery mechanism — resolved: Pi extension event bus via `pi.events.on("plannotator:request", ...)` and `pi.events.emit("plannotator:review-result", ...)` in `plannotator-events.ts`.
2. Async result race recovery — resolved: `review-status` request returns `pending`, `completed + result`, or `missing` from `~/.pi/plannotator-review-status.json`.
3. Extension-presence probe — unresolved; deferred to Phase 285 empirical probe. Source shows request/response statuses but not listener introspection.
4. Exact result schema — resolved for exposed event/types in `plannotator-events.ts` and `plannotator-browser.ts`.
5. `savedPath` payload semantics — partially resolved: produced by `saveFinalSnapshot(...)` and emitted as a path; exact serialized file format unresolved because generated storage implementation was unavailable in raw source; deferred to Phase 285 empirical probe or installed-package inspection.
6. Multi-iteration behavior — resolved at the event/session level: `server/serverPlan.ts` creates a fresh `randomUUID()` `reviewId` per started plan-review server/session, and storage computes versions by plan slug/content history. PALS must treat each re-emitted review as a fresh review and keep its own iteration numbering in sidecars.
7. UI-abandoned handling — unresolved as an upstream event: raw source showed approve/deny decision publication and session stop rejection, but no plan-review abandoned result event. PALS timeout policy deferred to Phase 285 numeric implementation.
8. `/plannotator-annotate` namespace check — resolved: `index.ts` registers `/plannotator-annotate`; PALS does not add a wrapper.

Primary upstream evidence URLs:

- `https://raw.githubusercontent.com/backnotprop/plannotator/main/apps/pi-extension/README.md`
- `https://raw.githubusercontent.com/backnotprop/plannotator/main/apps/pi-extension/package.json`
- `https://raw.githubusercontent.com/backnotprop/plannotator/main/apps/pi-extension/plannotator-events.ts`
- `https://raw.githubusercontent.com/backnotprop/plannotator/main/apps/pi-extension/index.ts`
- `https://raw.githubusercontent.com/backnotprop/plannotator/main/apps/pi-extension/plannotator-browser.ts`
- `https://raw.githubusercontent.com/backnotprop/plannotator/main/apps/pi-extension/server.ts`
- `https://raw.githubusercontent.com/backnotprop/plannotator/main/apps/pi-extension/server/serverPlan.ts`
- `https://raw.githubusercontent.com/backnotprop/plannotator/main/apps/pi-extension/server/serverReview.ts`
- `https://raw.githubusercontent.com/backnotprop/plannotator/main/apps/pi-extension/server/serverAnnotate.ts`
- `https://raw.githubusercontent.com/backnotprop/plannotator/main/apps/pi-extension/tool-scope.ts`