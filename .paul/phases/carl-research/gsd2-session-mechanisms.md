# GSD2 Session Mechanisms — Reference for CARL Design

## Overview

GSD2 implements **fresh session per unit of work** using only standard Pi extension APIs. No Pi base code modifications. The core insight: instead of managing context degradation, eliminate it by giving each work unit a clean session with exactly the context it needs.

## Architecture

```
.gsd/ files on disk (state)
        ↓
   deriveState() — reads disk, determines phase and next unit
        ↓
   resolveDispatch() — declarative rule table maps phase → unit type + prompt builder
        ↓
   ctx.newSession() — fresh session (from ExtensionCommandContext, command-only)
        ↓
   pi.sendMessage({ content: focused_prompt }, { triggerTurn: true })
        ↓
   LLM works in clean context
        ↓
   agent_end fires → cycle repeats
```

## Key Mechanisms

### 1. State Derivation (state.ts)

Pure TypeScript, zero Pi dependencies. Reads `.gsd/` files on disk to determine:
- Current phase (`pre-planning`, `planning`, `executing`, `summarizing`, `completing-milestone`, etc.)
- Active milestone, slice, and task references
- What work has been completed vs what remains

**Key principle:** Disk is the only state that persists between sessions. No conversation history, no summaries, no compaction. The file system is the state machine.

```typescript
// state.ts — pure function, no side effects
export async function deriveState(basePath: string): Promise<GSDState> {
  // Reads roadmap, plan files, task files, summaries
  // Returns structured state with phase, activeSlice, activeTask, etc.
}
```

### 2. Dispatch Table (auto-dispatch.ts)

A declarative array of rules evaluated in order — first match wins:

```typescript
const DISPATCH_RULES: DispatchRule[] = [
  { name: "summarizing → complete-slice",     match: async (ctx) => { ... } },
  { name: "pre-planning → research-milestone", match: async (ctx) => { ... } },
  { name: "pre-planning → plan-milestone",     match: async (ctx) => { ... } },
  { name: "planning → research-slice",         match: async (ctx) => { ... } },
  { name: "planning → plan-slice",             match: async (ctx) => { ... } },
  { name: "executing → execute-task",          match: async (ctx) => { ... } },
  { name: "validating → validate-milestone",   match: async (ctx) => { ... } },
  { name: "completing → complete-milestone",   match: async (ctx) => { ... } },
];
```

Each rule returns one of:
- `{ action: "dispatch", unitType, unitId, prompt }` — proceed
- `{ action: "stop", reason }` — halt auto-mode
- `{ action: "skip" }` — skip and re-derive
- `null` — fall through to next rule

### 3. Fresh Session Creation (auto.ts)

Called from `dispatchNextUnit()` which runs from a registered command (not an event handler — `newSession()` requires `ExtensionCommandContext`):

```typescript
// Create fresh session with timeout protection
const sessionPromise = s.cmdCtx!.newSession();
const timeoutPromise = new Promise<{ cancelled: true }>((resolve) =>
  setTimeout(() => resolve({ cancelled: true }), NEW_SESSION_TIMEOUT_MS),
);
result = await Promise.race([sessionPromise, timeoutPromise]);
```

After session creation, inject the focused prompt:

```typescript
pi.sendMessage(
  { customType: "gsd-auto", content: finalPrompt, display: s.verbose },
  { triggerTurn: true },
);
```

### 4. Prompt Injection (auto-prompts.ts)

Each unit type has a dedicated prompt builder that **inlines file content directly** — the LLM never needs to read files itself:

```typescript
export async function inlineFile(
  absPath: string | null, relPath: string, label: string,
): Promise<string> {
  const content = absPath ? await loadFile(absPath) : null;
  if (!content) {
    return `### ${label}\nSource: \`${relPath}\`\n\n_(not found)_`;
  }
  return `### ${label}\nSource: \`${relPath}\`\n\n${content.trim()}`;
}
```

A typical execute-task prompt inlines:
- The task plan (authoritative execution contract)
- Slice plan excerpt (context for what this task is part of)
- Prior task summaries (carry-forward, compressed if needed)
- Project knowledge (smart-chunked by relevance)
- Templates for expected output artifacts
- Verification budget constraints

### 5. Agent End Handler (auto.ts)

The `agent_end` event drives the cycle. On every agent completion:

1. **Close out current unit** — snapshot metrics, verify expected artifact exists
2. **Record completion** — persist completed key to disk
3. **Derive next state** — `invalidateAllCaches()` then `deriveState()`
4. **Resolve dispatch** — run the rule table to find next unit
5. **Create fresh session** — `ctx.newSession()`
6. **Inject prompt** — `pi.sendMessage()`

The entire loop is:
```
agent_end → closeout → deriveState → resolveDispatch → newSession → sendMessage → agent_end
```

### 6. Command Context Stashing

Since `newSession()` is only available on `ExtensionCommandContext` (not event handlers), GSD stashes the command context when auto-mode starts:

```typescript
// In the /gsd auto command handler:
s.cmdCtx = ctx;  // ExtensionCommandContext stashed for later use

// Later, in dispatchNextUnit (called from agent_end handler):
const sessionPromise = s.cmdCtx!.newSession();  // Uses stashed command context
```

This is the critical pattern: **a command starts auto-mode and stashes its context, then event handlers use that stashed context for session operations.**

### 7. Safety Mechanisms

- **Timeout on newSession()** — `Promise.race` with configurable timeout prevents permanent hangs
- **Reentrancy guard** — `s.dispatching` flag prevents concurrent dispatch
- **Stuck detection** — tracks dispatch counts per unit, stops after threshold
- **Idempotency checks** — prevents re-dispatching already-completed units
- **Gap watchdog** — detects when auto-mode is active but no dispatch is happening
- **Session lock** — prevents multiple auto-mode processes on same project

## What GSD Does NOT Do

- No context usage monitoring — sessions are fresh, so context is never a concern
- No compaction — ever
- No conversation carry-forward — state is on disk, not in chat history
- No manual handoffs — the state machine handles everything

## Relevance to PALS/CARL

### Direct applicability
- `ctx.newSession()` API works as documented
- Command context stashing pattern is proven
- `pi.sendMessage({ triggerTurn: true })` for prompt injection works
- Disk-based state derivation is the right pattern (PALS already has `.paul/STATE.md`)
- Declarative dispatch rules are clean and testable

### Key differences for PALS
- GSD decomposes all work into small units upfront (tasks within slices within milestones)
- PALS gives the LLM more latitude within a phase — a single APPLY can span multiple tasks
- GSD creates a fresh session for every task; PALS would create fresh sessions at phase boundaries
- PALS needs a context pressure safeguard for long phases; GSD doesn't need one because units are small

### The hybrid model for CARL
- **Default:** Fresh session at every phase boundary (PLAN → APPLY → UNIFY each get their own session)
- **Continue condition:** If context usage at phase end is below a threshold (e.g., <40%), continue into the next phase without a session break
- **Safety valve:** If context usage exceeds a threshold mid-phase (e.g., >80%), trigger a structured pause and handoff

This gives PALS the predictability of GSD's fresh-session model while preserving the option to continue when context is plentiful.
