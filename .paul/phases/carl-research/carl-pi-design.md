# CARL Pi-Native Design — Session Boundary Manager

## Core Principle

**Fresh session per phase by default. Continue only when context is cheap.**

Each PALS lifecycle step (PLAN, APPLY, UNIFY) gets a clean session with exactly the context it needs, built from `.paul/` artifacts. When a phase completes with low context usage, CARL allows the next phase to continue in the same session. When context is under pressure, CARL enforces the break.

## Decision Model

```
Phase completes (PLAN done, APPLY done, or UNIFY done)
    ↓
Check ctx.getContextUsage()
    ↓
┌─────────────────────────────────────────────┐
│ Usage < threshold (e.g., 40%)?              │
│   YES → continue into next phase            │
│   NO  → fresh session + structured handoff  │
└─────────────────────────────────────────────┘
```

The threshold is configurable in `pals.json`. Default: fresh session at every phase boundary (conservative). Users can increase the threshold to allow continuation when they prefer fewer session breaks.

### Configuration

```json
{
  "carl": {
    "session_strategy": "phase-boundary",
    "continue_threshold": 0.4,
    "safety_ceiling": 0.8
  }
}
```

- **`session_strategy`**: `"phase-boundary"` (default) | `"always-fresh"` | `"manual"`
  - `phase-boundary`: fresh session at phase end unless below `continue_threshold`
  - `always-fresh`: fresh session at every phase boundary, no exceptions
  - `manual`: CARL monitors but never creates sessions autonomously
- **`continue_threshold`**: context usage ratio below which the next phase continues in-session (default: 0.4 = 40%)
- **`safety_ceiling`**: context usage ratio that triggers mid-phase pause (default: 0.8 = 80%)

## Lifecycle Integration

### Where CARL acts

CARL hooks into the existing PALS lifecycle at three points:

1. **Phase completion** — after UNIFY closes the loop, before routing to the next PLAN
2. **Milestone completion** — after `/paul:milestone complete`, before the next milestone starts
3. **Mid-phase safety** — during APPLY, if context exceeds `safety_ceiling`

### Phase completion flow (primary mechanism)

```
UNIFY completes
    ↓
CARL reads ctx.getContextUsage()
    ↓
Below continue_threshold?
    ├── YES: STATE.md updated, continue to next PLAN in same session
    └── NO:  
         1. Trigger /paul:pause (creates handoff file)
         2. ctx.newSession({ setup: bootstrap })
         3. Bootstrap message injects: STATE.md snapshot, handoff summary, next action
         4. pi.sendUserMessage("/skill:paul-resume") — auto-resume in fresh session
```

### Mid-phase safety (safeguard only)

```
turn_end fires during APPLY
    ↓
CARL reads ctx.getContextUsage()
    ↓
Above safety_ceiling?
    ├── NO: continue silently
    └── YES:
         1. Notify user: "Context pressure high. Will pause at next task boundary."
         2. Set flag: pause_at_next_boundary = true
         3. On next task completion (detected via STATE.md change):
              - Trigger /paul:pause
              - ctx.newSession({ setup: bootstrap })
              - Resume with remaining tasks
```

This is the safeguard, not the primary mechanism. Most phases will complete before hitting the ceiling.

## Implementation Architecture

### Extension structure

CARL is implemented as additions to the existing `pals-hooks.ts` extension (not a separate extension). This keeps PALS as one coherent extension with shared state.

### Command context stashing (from GSD2 pattern)

```typescript
// When any /paul-* command starts, stash the ExtensionCommandContext
let stashedCmdCtx: ExtensionCommandContext | undefined;

pi.registerCommand("paul-plan", {
  handler: async (args, ctx) => {
    stashedCmdCtx = ctx;  // Stash for later newSession() calls
    routeCommand("paul-plan", args, ctx);
  },
});
```

### Session creation

```typescript
async function createFreshSession(reason: string): Promise<boolean> {
  if (!stashedCmdCtx) return false;
  
  const handoffContent = buildHandoffContent();
  
  const result = await stashedCmdCtx.newSession({
    setup: async (sm) => {
      sm.appendMessage({
        role: "user",
        content: [{ type: "text", text: buildBootstrapPrompt(handoffContent) }],
        timestamp: Date.now(),
      });
    },
  });
  
  if (result.cancelled) return false;
  
  // Auto-resume in fresh session
  pi.sendUserMessage("/skill:paul-resume");
  return true;
}
```

### Bootstrap prompt

The fresh session gets a single injected message containing:

```markdown
## PALS Session Bootstrap

**Resuming from structured handoff.**

### Current State
Milestone: {milestone}
Phase: {phase} of {total}
Loop: {position}
Last completed: {what just finished}
Next action: {what to do next}

### Handoff Context
{Key decisions from this milestone}
{Deferred items}
{Git state}

### Resume
The handoff file at {path} contains full session continuity context.
Run /skill:paul-resume to continue.
```

This replaces the manual "start new session, type /paul:resume" cycle with an autonomous one.

## What CARL Replaces

| Old CARL (Claude Code) | New CARL (Pi-native) |
|------------------------|---------------------|
| Global rules injection | Removed — `AGENTS.md` handles this |
| Context bracket behavioral nudges | Removed — fresh sessions eliminate the problem |
| Star-commands | Removed — Pi prompt templates handle this |
| Manifest/domain system | Removed — no parallel rule system needed |
| Manual context monitoring | Replaced by automatic `getContextUsage()` checks |
| Manual pause/resume cycle | Replaced by autonomous session transitions |

## What CARL Preserves

- The `carl/` directory is removed from the Pi install (dead weight)
- The CARL name is reused for the Pi-native session boundary manager
- The core idea — context-aware behavior adaptation — is preserved but implemented through session architecture instead of rule injection

## Dependencies

- `ctx.getContextUsage()` — must return usable token count (documented in Pi extension API)
- `ctx.newSession({ setup })` — must work via stashed `ExtensionCommandContext` (proven by GSD2)
- `pi.sendUserMessage()` — for auto-resume after session creation (documented)
- `.paul/STATE.md` — already exists and is already parsed by pals-hooks.ts
- `/paul:pause` and `/paul:resume` workflows — already exist and work

## Risks

1. **`ctx.newSession()` via stashed context** — GSD2 proves this works, but PALS command handlers may need restructuring to stash properly
2. **`getContextUsage()` accuracy** — documented as "uses last assistant usage when available, then estimates" — may need empirical calibration of thresholds
3. **Race conditions** — session creation is async; need the same reentrancy guards GSD2 uses
4. **User expectation** — autonomous session breaks are unfamiliar; need clear UI notification
