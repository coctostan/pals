# Handoff Archiving Issue

## Summary

PALS currently has a workflow inconsistency around session handoffs:

- `/paul:pause` creates handoffs in the active project root:
  - `.paul/HANDOFF-{date}-{context}.md`
- `/paul:resume` says consumed handoffs should be archived to:
  - `.paul/handoffs/archive/`
- but `/paul:resume` detection logic only looks for active handoffs in:
  - `.paul/HANDOFF*.md`

This means the newest and most relevant handoff can be moved into the archive location and then no longer be discoverable by the normal resume scan.

## Observed Behavior

This happened in practice in Quark:

- older active handoffs were still visible under `.paul/HANDOFF*.md`
- a newer, more relevant handoff existed under:
  - `.paul/handoffs/archive/HANDOFF-2026-03-16-phase37-ready.md`
- an initial resume pass missed that newer handoff because only the top-level active pattern was scanned

The result is confusing routing:

- the system appears to have "lost" the last handoff
- stale handoffs may be considered before fresher archived ones
- users reasonably assume handoffs are disappearing unexpectedly

## Root Cause

The problem is not random archiving. It is a workflow design mismatch.

### Creation behavior
`paul-pause` documents this output behavior:

- create `.paul/HANDOFF-{date}-{context}.md`
- update `STATE.md` to point to the handoff

### Resume lifecycle behavior
`paul-resume` / `resume-project.md` documents this lifecycle:

- consumed handoffs are archived after resume proceeds
- archive destination: `.paul/handoffs/archive/`

### Detection behavior
The same resume workflow tells the agent to detect handoffs via:

```bash
ls -t .paul/HANDOFF*.md 2>/dev/null | head -5
```

That scan does **not** include `.paul/handoffs/archive/`.

## Why This Is a Problem

1. The latest narrative session context may exist only in the archive.
2. Resume can miss the most useful handoff even though it still exists.
3. Users experience the archive as accidental deletion or mysterious disappearance.
4. The workflow violates the principle of least surprise: resume does not search where resume itself may have moved the file.

## Recommended Fix

### Best fix: combine both of these

#### 1. Resume should search both active and archived handoffs
Resume discovery should include:

- `.paul/HANDOFF*.md`
- `.paul/handoffs/archive/HANDOFF*.md`

Then choose the most recent relevant handoff, while still treating `STATE.md` as authoritative if there is any conflict.

#### 2. Archive only when superseded, not merely consumed
Instead of archiving the current handoff immediately on resume, keep it active until one of these happens:

- a newer handoff is created by `/paul:pause`
- the user explicitly archives or cleans up old handoffs

This keeps the latest handoff easy to find and prevents resume from hiding its own context source.

## Minimal Fix Options

If only one change is made:

- **Safest single fix:** make resume search both active and archived handoffs

That alone prevents missed handoffs even if auto-archiving remains in place.

## Suggested Policy

A sane handoff policy would be:

1. `/paul:pause` creates a new active handoff
2. `STATE.md` points to that handoff
3. `/paul:resume` reads active handoffs first, then archived handoffs as fallback
4. the currently referenced handoff is not auto-archived just because it was read
5. older handoffs are archived only when replaced by a newer handoff or during explicit cleanup

## Expected Outcome

With the above change:

- resume reliably finds the freshest handoff
- users stop seeing handoffs as "missing"
- archive history is preserved
- `STATE.md` remains authoritative without losing narrative continuity

## Short Version

The bug is:

- resume archives handoffs
- resume does not reliably search the archive

So PALS can move the latest handoff somewhere that normal resume logic does not check.
