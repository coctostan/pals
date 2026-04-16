# CODI — Codegraph-Driven Structural Injection

## Purpose

PALS plans need accurate structural facts — which files are actually affected, which boundaries matter, which tests are at risk — and today those facts are guessed during `analyze_scope`. CODI bakes codegraph's structural truth into PLAN.md so the plan already carries the answers the agent would otherwise have to "remember" to call codegraph for mid-APPLY. The structural-truth source becomes a pre-plan hook, not a tool surface competing for the agent's attention.

## v0.1 Scope (Current)

- **Hook:** `pre-plan` only, priority 220, advisory-only. Note that the manifest description must never contain the word "block" in any casing — the shared dispatch classifier in `plan-phase.md` uses strict substring matching to distinguish advisory from enforcement hooks, so CODI uses "halt" and "skip" instead.
- **Behavior:** CODI always emits `[dispatch] CODI: hello, objective=<one-line phase objective summary>`.
- **No codegraph tool calls and no prerequisite checks** are performed at this stage. The sole purpose of v0.1 is to prove the dispatch plumbing end-to-end before Phase 171 introduces the first `impact` integration.

## Call-Time Failure Handling Philosophy

CODI does not pre-check for codegraph tool availability. There is no reliable filesystem marker that proves the runtime agent-tools (`impact`, `symbol_graph`, `trace`) are present in the current session — those are properties of the agent's tool namespace, not project state. A `.codegraph/` directory proves codegraph was once run; it does not prove the tools are callable right now.

Instead, starting in Phase 171, each codegraph tool call is wrapped with graceful failure handling at the call site. If the tool is unavailable or errors, CODI emits `[dispatch] CODI: skipped — codegraph tools unavailable` and exits cleanly — no error propagates to the plan, and no partial structural facts are injected.

v0.1 hello-world performs no tool calls, so it has no skip paths. It always emits hello-world. This honors the source-plan note that CODI "should detect [unavailability] and skip cleanly rather than erroring" without pretending we can predict tool availability before attempting use.

## Codegraph Tool Dependency (forward-looking)

CODI will start calling the following codegraph tools in Phase 171:

- `impact` — required for v0.1 → v0.2 (the downstream blast-radius surface).
- `symbol_graph` — v0.2 (upstream dependency context).
- `trace` — v0.3 (conditional, for runtime-behavior plans).

The v2.39 source plan explicitly recommends: *"build CODI v0.1 before finalizing the codegraph cuts."* Keeping v0.1 tool-free preserves optionality while the codegraph surface settles.

## Deferred Roadmap

- **v0.2** — add `symbol_graph` for upstream dependency context.
- **v0.3** — conditional `trace` for runtime-behavior plans.
- **v0.4** — formalize `<impact>` / `<dependencies>` / `<runtime_paths>` PLAN.md template sections.
- **v0.5+** — CODI at other PALS hooks (pre-apply / post-task / pre-unify).
- **Future** — reconsider whether a project-state gate (e.g. `.codegraph/` presence) should bypass dispatch entirely once v0.1 usage reveals the real cost of dispatching on projects without codegraph support.

## Source Plan Reference

Conceptual driver: `~/pi/workspace/thinkingSpace/plans/pals-codi-integration-plan.md`.
