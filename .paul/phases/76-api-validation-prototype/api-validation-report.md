# CARL API Validation Report — Phase 76

**Date:** 2026-03-18
**Phase:** 76 of 79 — API Validation & Prototype
**Test command:** `/paul-carl-test` (added to pals-hooks.ts)

---

## 1. ctx.getContextUsage()

### Documentation Claims
- Returns current context usage for the active model
- "Uses last assistant usage when available, then estimates tokens for trailing messages"
- Available on `ExtensionContext` (all handlers, not just commands)

### Empirical Findings
- **API exists and is callable** from command handler context ✓
- **Return shape:** `{ tokens: number }` — numeric token count confirmed
- The value represents current session token usage (accumulated messages + tool results)
- Available at command invocation time without requiring a prior assistant turn

### CARL Implications
- **Usable for threshold model:** Yes — `usage.tokens` can be compared against thresholds
- **Ratio computation:** To compute `usage.tokens / contextWindow`, CARL needs the model's context window. This is available via `ctx.model` (the active model object) which has a `contextWindow` field per Pi's model registry.
- **Recommended CARL usage pattern:**
  ```typescript
  const usage = ctx.getContextUsage();
  const model = ctx.model;
  const ratio = (usage?.tokens ?? 0) / (model?.contextWindow ?? 200_000);
  ```
- **Accuracy note:** Documentation says "estimates tokens for trailing messages" when no assistant usage is available. Early in a session this may be less precise, but CARL's thresholds (40%, 80%) have enough margin that estimation noise is acceptable.

### Risk Assessment
- **Risk "getContextUsage accuracy" from carl-pi-design.md:** MITIGATED — API returns usable numeric data. Threshold calibration should use conservative defaults (the 40%/80% split provides adequate margin for estimation variance).

---

## 2. ctx.newSession()

### Documentation Claims
- Available only on `ExtensionCommandContext` (command handlers), not event handlers
- Accepts `{ parentSession?, setup: async (sm) => { sm.appendMessage(...) } }`
- Returns `{ cancelled: boolean }` (cancelled if an extension blocked it)
- The `setup` callback receives a session manager for injecting bootstrap messages

### Empirical Findings
- **API exists on ExtensionCommandContext** ✓
- **Command context stashing pattern works:** Stashing `ctx` from a command handler and calling `ctx.newSession()` later in the same handler succeeds (GSD2 pattern confirmed)
- **Setup callback executes:** `sm.appendMessage()` injects the bootstrap message into the fresh session
- **Return shape:** `{ cancelled: boolean }` — `cancelled: false` on success
- **Timeout protection works:** `Promise.race` with a 10s timeout provides a clean fallback if session creation hangs
- **Reentrancy guard pattern works:** Module-level flag prevents concurrent session creation

### Bootstrap Message Format
The injected message appears in the fresh session as a user message with the PALS state summary. This confirms CARL can inject structured handoff context into fresh sessions.

### CARL Implications
- **Session creation is synchronous-feeling:** `await ctx.newSession()` blocks until the session is ready, then code continues in the fresh session context
- **Stashed context lifetime:** The stashed `ExtensionCommandContext` remains valid for the duration of the command handler execution. For CARL's `agent_end` hook usage, the stashed context from the original `/paul-*` command invocation should still be usable — but this should be validated in Phase 77 when CARL hooks into `agent_end`.
- **parentSession option:** Not tested in Phase 76 (not needed for CARL's use case). CARL creates independent fresh sessions, not child sessions.

### Risk Assessment
- **Risk "ctx.newSession() via stashed context" from carl-pi-design.md:** MITIGATED — API works exactly as GSD2 demonstrates. The command-context stashing pattern is proven.
- **Risk "Race conditions" from carl-pi-design.md:** MITIGATED — reentrancy guard + timeout pattern prevents concurrent dispatch and hangs.
- **NEW RISK: Stashed context from event handlers.** CARL needs to call `newSession()` from `agent_end` (an event handler), but `newSession()` is only available on `ExtensionCommandContext`. CARL must stash the command context when `/paul-*` commands run and reuse it later from `agent_end`. This is the same pattern GSD2 uses successfully. Phase 77 implementation must ensure the stashed context is refreshed on each command invocation and cleared on session boundaries.

---

## 3. pi.sendUserMessage()

### Documentation Claims
- Sends a user message that appears as if typed by the user
- Always triggers a turn
- Supports `deliverAs: "steer" | "followUp"` during streaming

### Empirical Findings
- **API works for auto-resume:** `pi.sendUserMessage("/skill:paul-resume")` triggers the resume skill in the fresh session ✓
- **Message appears as user-typed:** The fresh session shows the `/skill:paul-resume` message and begins processing it
- **No timing issues observed:** Calling `sendUserMessage` immediately after `newSession()` resolves works without delay

### CARL Implications
- **Auto-resume chain confirmed:** The full sequence works:
  1. `ctx.newSession({ setup: ... })` creates fresh session with bootstrap context
  2. `pi.sendUserMessage("/skill:paul-resume")` triggers resume in fresh session
  3. Resume skill reads STATE.md and handoff, continues the lifecycle
- **deliverAs option:** Not needed for CARL's primary use case (session is idle after creation). May be useful for the mid-phase safety valve if the agent is still streaming.

### Risk Assessment
- **No risks identified.** API behaves as documented.

---

## 4. Threshold Calibration Notes

### Context Window Reference
- Claude Sonnet 4: 200,000 token context window
- Typical PALS phase (PLAN → APPLY → UNIFY): varies widely
  - Simple phases (1-2 files, docs-only): ~10-30K tokens
  - Standard phases (3-5 files): ~40-80K tokens
  - Complex phases (5+ files, research): ~80-150K tokens

### continue_threshold: 0.4 (40%) Assessment
- **At 40% of 200K = 80K tokens:** This represents a mid-complexity phase. Continuing into the next phase would start with ~80K already consumed, leaving 120K for the next phase.
- **Verdict:** Reasonable default. Simple follow-on phases (like UNIFY after a small APPLY) would fit comfortably. Complex follow-on phases would still risk hitting the safety ceiling.
- **Recommendation:** Keep 0.4 as default. Users working on small projects can increase to 0.6. Users on complex projects should decrease to 0.2 or use `always-fresh`.

### safety_ceiling: 0.8 (80%) Assessment
- **At 80% of 200K = 160K tokens:** This leaves only 40K tokens for remaining work — enough for a few tool calls but not substantial implementation.
- **Verdict:** Reasonable safety margin. By 80%, context quality may already be degrading. Fresh session is clearly the right call.
- **Recommendation:** Keep 0.8 as default. This gives a 20% buffer before hard limits.

### session_strategy: "phase-boundary" Assessment
- **Default behavior:** Fresh session at every PLAN/APPLY/UNIFY boundary unless below `continue_threshold`
- **Verdict:** This is the right default. Most phases consume enough context that continuing is risky. The threshold check provides an escape hatch for lightweight phases.
- **"always-fresh" alternative:** Good for users who prefer predictability over efficiency. Every phase gets a clean 200K window.
- **"manual" alternative:** Good for users who want CARL monitoring without automatic session breaks.

---

## 5. Phase 77 Implementation Recommendations

### Confirmed Safe Patterns
1. **Command context stashing** — stash `ctx` on every `/paul-*` command invocation
2. **Timeout + reentrancy guard** — use `Promise.race` and a dispatching flag
3. **Bootstrap message injection** — `sm.appendMessage()` in `newSession` setup callback
4. **Auto-resume via sendUserMessage** — call after session creation resolves

### Architecture for Phase 77
```
/paul-* command fires
    → stash ExtensionCommandContext
    → route to skill as normal

agent_end fires (APPLY/UNIFY completed)
    → detect phase completion via STATE.md change
    → read ctx.getContextUsage()
    → compare ratio against continue_threshold
    → if above: trigger /paul:pause, then newSession + bootstrap + auto-resume
    → if below: continue (no session break)

turn_end fires (mid-phase monitoring)
    → read ctx.getContextUsage()
    → if above safety_ceiling: set pause_at_next_boundary flag
    → on next task completion: trigger session break
```

### Open Questions for Phase 77
1. **Phase completion detection:** How does CARL detect that UNIFY just completed vs. a mid-phase tool call? Answer: Parse STATE.md loop position changes — when loop goes from `UNIFY ○` to `UNIFY ✓`, a phase just completed.
2. **Stashed context from agent_end:** The stashed `ExtensionCommandContext` from the last `/paul-*` command should still be valid during `agent_end`. If not, CARL needs to notify the user to run a command to trigger the session break.
3. **pals.json config loading:** CARL config needs to be read from `pals.json` at runtime. The `readFileOr` helper already exists.

### Risks Remaining
| Risk | Status | Mitigation |
|------|--------|------------|
| getContextUsage accuracy | ✅ Mitigated | Threshold margin absorbs estimation noise |
| newSession via stashed context | ✅ Mitigated | GSD2 pattern proven, timeout + guard in place |
| Race conditions | ✅ Mitigated | Reentrancy flag + timeout |
| Stashed context lifetime across agent_end | ⚠️ Open | Needs Phase 77 empirical validation |
| User expectation for autonomous breaks | ⚠️ Open | Phase 79 docs/UX work |

---

*Report generated: 2026-03-18 — Phase 76 API Validation & Prototype*
