# Phase 71: Module Recommendations Matrix

This matrix turns the Phase 68 audit plus the completed Phase 69-70 work into explicit disposition guidance for every shipped module.

## Framing
- The audit showed the main problem was **not fake wiring**; it was weak proof and weak visibility.
- Phase 69 already fixed the durable end-of-loop evidence path.
- Phase 70 already added bounded live module visibility in Pi.
- Therefore, Phase 71 should prefer **keep** and **improve** over dramatic consolidation unless the evidence clearly supports more.

## Recommendation Legend
- **Keep** — current role and boundaries are directionally correct; preserve as-is other than normal maintenance
- **Improve** — keep the module, but refine proof, visibility, wording, or recommendation surfaces
- **Merge** — fold responsibility into another surface only if separate ownership is no longer justified
- **Remove** — remove only if the module creates more conceptual weight than user value

## Per-Module Recommendations

| Module | Current lifecycle role | Current proof / visibility surface | Recommendation | Rationale | Risk / compatibility posture | Recommended timing |
|--------|-------------------------|------------------------------------|----------------|-----------|------------------------------|-------------------|
| **CARL** | Outside PLAN/APPLY/UNIFY lifecycle; platform-hook context/rules layer | Intentionally not part of PAUL lifecycle proof; visible through its own command/config model rather than module dispatch | **Keep** | Phase 68 confirmed CARL's non-participation in lifecycle hooks is intentional architecture, not a gap. Pulling CARL into module-proof work would blur a useful boundary. | **Low risk / high compatibility** — preserve architectural independence | **Now (hold steady)** |
| **TODD** | Pre-plan, post-plan, pre-apply, post-task, post-apply TDD enforcement | Strong declared lifecycle presence; proof mostly appears through dispatch logs, task gating, and post-apply annotations | **Improve** | TODD is one of the clearest examples of real module value, but its impact can still feel implicit unless tasks and end reports describe the TDD story clearly. Improve report wording and recommendation clarity, not ownership. | **Low-medium risk / high compatibility** — additive clarity work only | **Soon** |
| **WALT** | Pre-apply baseline, post-apply quality gate, post-unify durable quality report + history side effect | Best current proof path: baselines, validation, durable `Module Execution Reports`, quality history, Pi live visibility fallback | **Improve** | WALT is the strongest proof-bearing module and should remain the anchor for "what good module evidence looks like." Improve consistency of summary language and validation interpretation rather than redesigning the module. | **Low risk / high compatibility** — reinforce the already-proven model | **Soon** |
| **DEAN** | Pre-plan dependency warnings, post-apply vulnerability regression checks | Mostly advisory unless dependency work is in scope; visible via dispatch/annotations and `/paul:deps` | **Keep** | DEAN has a coherent bounded role: front-load dependency risk, then prevent regressions after apply. It does not need stronger always-on visibility than the current proof model supports. | **Low risk / high compatibility** — preserve current bounded role | **Now (hold steady)** |
| **DAVE** | Pre-plan deploy warning, post-apply deployment-config validation | Conditional proof only when CI/CD or pipeline files are relevant; otherwise intentionally quiet | **Keep** | DAVE is intentionally situational. The right recommendation is not more ambient visibility but clearer expectation-setting that some modules are conditional and should remain silent off-path. | **Low risk / high compatibility** — no structural change needed | **Now (hold steady)** |
| **DOCS** | Pre-plan doc warnings, post-apply doc drift warnings | Advisory proof through plan context and post-apply annotations; `/paul:docs` command remains deferred | **Keep** | DOCS fits the ecosystem as a non-blocking oversight companion. Its value comes from selective drift awareness, not from dominating visible workflow surfaces. | **Low risk / high compatibility** — preserve bounded advisory behavior | **Now (hold steady)** |
| **IRIS** | Pre-plan review flags, post-apply structured review findings | Advisory review surface via dispatch + annotations + `/paul:review` | **Keep** | IRIS still has a distinct role from WALT: review intelligence rather than execution quality gating. The evidence does not support merging it into WALT or DOCS just because all are post-apply-advisory. | **Low risk / high compatibility** — keep separate responsibility | **Now (hold steady)** |
| **RUBY** | Pre-plan debt detection, post-unify durable refactor guidance | Proof now improved by Phase 69 durable post-unify reports, but still naturally later and less visible live | **Improve** | RUBY is a good candidate for recommendation/report refinement because its value arrives late in the loop. The answer is clearer post-unify summarization, not moving refactor logic earlier or merging it away. | **Medium risk / high compatibility** — refine end-report language only | **Later, after report polish priorities** |
| **SKIP** | Post-apply knowledge suggestions, post-unify durable knowledge report + suggestion side effects | Durable post-unify report path now exists, but user value depends on legibility of what was captured vs merely suggested | **Improve** | SKIP benefits the most from clearer separation between persisted report content and optional follow-on knowledge actions. Improve how summaries explain suggestions and side effects rather than changing ownership. | **Medium risk / high compatibility** — contract clarity, not architecture change | **Later, after report polish priorities** |

## Cross-Module Takeaways

### Strong keep signals
- **CARL** should stay independent from lifecycle-hook proof work.
- **DEAN, DAVE, DOCS, IRIS** already fit a bounded advisory/conditional pattern and do not need dramatic restructuring.

### Strong improve signals
- **TODD and WALT** are the most visible examples of modules whose execution value should be easier to read in plans, apply outputs, and end reports.
- **SKIP and RUBY** most benefit from clearer post-unify summary language because their value lands late and can otherwise feel invisible.

### Merge / remove recommendation
- **No merge recommendation at this time.** Phase 68 did not show duplicated ownership severe enough to justify consolidation.
- **No remove recommendation at this time.** The current problem is opacity, not dead weight.

## Recommended Sequence
1. Preserve the current architecture and module boundaries.
2. Improve report and validation legibility for the proof-bearing modules first (`TODD`, `WALT`, `SKIP`, `RUBY`).
3. Keep conditional/advisory modules intentionally quiet when their trigger conditions are absent.
4. Revisit merge/remove only if future evidence shows overlapping ownership or sustained non-use, not as a reaction to historical visibility weakness.

## Bottom Line
The best recommendation set is conservative by architecture and selective by UX/reporting:
- keep the module roster,
- improve the modules whose value most depends on readable proof,
- and resist turning a solved visibility problem into a new telemetry or consolidation project.
