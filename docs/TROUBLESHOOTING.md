# Troubleshooting Guide

Common issues and how to fix them. Each entry follows **Symptom → Cause → Fix**.

---

## Installation Issues

### Slash commands not appearing after install

**Symptom:** `/paul:plan` and other commands don't show up in Claude Code.

**Cause:** Claude Code loads commands at session start. Commands installed mid-session aren't picked up.

**Fix:** Start a new Claude Code session. Commands load from `~/.claude/commands/` on startup.

---

### install.sh fails with "Expected directories" error

**Symptom:** `ERROR: install.sh must be run from the PALS repo root.`

**Cause:** Running `install.sh` from outside the cloned repo directory.

**Fix:** `cd` into the PALS repo root before running: `cd pals && ./install.sh`

---

### Permission denied on install

**Symptom:** `Permission denied` when running `./install.sh`.

**Cause:** Script not marked executable.

**Fix:** `chmod +x install.sh && ./install.sh`

---

### Legacy cleanup prompt appears

**Symptom:** Installer asks about removing `~/.claude/paul-framework/`.

**Cause:** A pre-PALS (standalone PAUL) installation was detected.

**Fix:** Type `y` to remove it — PALS replaces the legacy framework entirely. Type `n` to skip and clean up manually later.

---

## Module Issues

### Module not loading (hooks not firing)

**Symptom:** Module is installed but its hooks never fire during plan/apply.

**Cause 1:** Module disabled in `pals.json`.

**Fix:** Check `pals.json` at your project root. Ensure `"enabled": true` for the module. Run `/paul:config` to toggle.

**Cause 2:** Module not in `modules.yaml`.

**Fix:** Re-run `./install.sh` from the PALS repo. Check `~/.pals/modules.yaml` lists the module.

---

### Hook dispatch shows "skip" for all modules

**Symptom:** Dispatch log shows every module skipping (e.g., `[dispatch] pre-plan: TODD → skip`).

**Cause:** The work type doesn't match the module's domain. For example, documentation-only phases skip TODD (no TDD candidates) and WALT (no code to test).

**Fix:** This is expected behavior. Modules skip gracefully when their domain isn't relevant.

---

### Reference file not found during hook dispatch

**Symptom:** Hook fires but can't load its ref file.

**Cause:** Reference file missing from `~/.pals/references/`. Usually caused by a partial install or manual file deletion.

**Fix:** Re-run `./install.sh` to restore all module files.

---

### module.yaml parse error during install

**Symptom:** Module silently skipped or installer outputs garbled data.

**Cause:** YAML formatting issue in `module.yaml`. The installer uses a custom parser (no PyYAML dependency).

**Fix:** Check indentation (2 spaces, no tabs). Ensure list items use `- ` prefix. Compare against a working module like `modules/dean/module.yaml`.

---

## State & Session Issues

### STATE.md out of sync with actual progress

**Symptom:** `/paul:progress` shows wrong phase or loop position.

**Cause:** STATE.md wasn't updated after the last action — usually from a session that ended abruptly.

**Fix:** Read STATE.md and ROADMAP.md manually. Update STATE.md to reflect actual state: current phase, loop position (PLAN/APPLY/UNIFY markers), and last activity timestamp.

---

### Handoff file not found on resume

**Symptom:** `/paul:resume` references a handoff file that doesn't exist.

**Cause:** Handoff was archived or deleted. Check `.paul/handoffs/archive/`.

**Fix:** Resume works without a handoff — it falls back to STATE.md and loop position. If you need the handoff content, check the archive directory.

---

### Loop position stuck after APPLY

**Symptom:** APPLY shows complete but UNIFY marker is still empty. `/paul:progress` keeps suggesting UNIFY.

**Cause:** `/paul:unify` was never run after `/paul:apply` completed.

**Fix:** Run `/paul:unify` with the plan path to reconcile and close the loop. Example: `/paul:unify .paul/phases/32-pals-documentation/32-01-PLAN.md`

---

### "Previous loop not closed" warning when planning

**Symptom:** `/paul:plan` warns that a previous loop is still open.

**Cause:** A plan was applied but never unified — the loop didn't close.

**Fix:** Run `/paul:unify` for the outstanding plan first, then proceed with planning.

---

## Git & GitHub Issues

### Git config not applied from pals.json

**Symptom:** Git automation features (auto-push, auto-PR) don't trigger during phase transitions.

**Cause:** Git config in `pals.json` has automation disabled (all defaults are off).

**Fix:** Check your project's `pals.json` for the `git` section:
```json
{
  "git": {
    "auto_commit": false,
    "auto_push": false,
    "auto_pr": false,
    "ci_check": false,
    "branching": "phase"
  }
}
```
Set the desired flags to `true`. These are configured during `/paul:init` or can be edited manually.

---

### Auto-PR/push not triggering

**Symptom:** Phase transition completes but no PR is created and nothing is pushed.

**Cause 1:** No git remote configured. All remote operations guard on `remote != null`.

**Fix:** Add a remote: `git remote add origin <url>`

**Cause 2:** Auto flags are `false` in `pals.json` git config.

**Fix:** Set `"auto_push": true` and/or `"auto_pr": true` in `pals.json`.

---

### Branch naming conflicts

**Symptom:** Git errors when creating a phase branch that already exists.

**Cause:** A previous attempt at this phase created the branch but work was rolled back.

**Fix:** Delete the stale branch (`git branch -d feature/NN-phase-name`) and let the transition workflow create a fresh one.

---

## Common Mistakes

### Running /paul:apply without approving the plan

**Symptom:** Apply starts executing before you've reviewed the plan.

**Cause:** The apply workflow requires explicit approval but can be triggered if you respond "yes" or "1" prematurely.

**Fix:** Always read the plan output from `/paul:plan` before confirming. You can ask questions or request changes before approving.

---

### Editing STATE.md manually

**Symptom:** State becomes inconsistent with actual project progress.

**Cause:** STATE.md is managed by the kernel workflows. Manual edits can create mismatches.

**Fix:** Let the workflows manage STATE.md. If you must fix it, update all sections consistently: Current Position, Loop Position, and Session Continuity. Verify against ROADMAP.md.

---

### Forgetting /paul:unify after apply

**Symptom:** Work is done but the loop never closes. Next session shows stale loop position.

**Cause:** The plan-apply-unify loop requires all three phases. Skipping unify leaves the loop open.

**Fix:** Run `/paul:unify` immediately after apply completes. The unify phase reconciles planned vs actual, records deviations, and advances the project state.

---

### Creating plans for the wrong phase

**Symptom:** Plan targets a phase that's already complete or doesn't exist.

**Cause:** Running `/paul:plan` without checking current position.

**Fix:** Run `/paul:progress` first to see where you are. It suggests the correct next action.
