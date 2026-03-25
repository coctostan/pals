<purpose>
Compressed fix workflow implementing 3 modes: standard fix (lightweight PLAN→APPLY→UNIFY), fast-forward (zero overhead), and hotfix (execute first, retroactive UNIFY). Called by /paul:fix command after mode selection.
</purpose>

<when_to_use>
- Routed from /paul:fix command after mode classification
- NOT called directly — always via /paul:fix entry point
- Replaces full PLAN-APPLY-UNIFY loop for ad-hoc fixes
</when_to_use>

<loop_context>
This workflow is a COMPRESSED loop — it handles PLAN+APPLY+UNIFY in a single pass (standard mode), skips the loop entirely (fast-forward), or defers UNIFY (hotfix).

It does NOT replace the full loop for planned work. It supplements it for ad-hoc fixes.
</loop_context>

<references>
@references/fix-types.md
@references/loop-phases.md
references/module-dispatch.md
<!-- Module hooks dispatched where noted per mode -->
</references>

<process>

<!-- ═══════════════════════════════════════ -->
<!-- MODE: STANDARD FIX (compressed loop)   -->
<!-- ═══════════════════════════════════════ -->

<step name="standard_fix" condition="mode == standard">

<substep name="standard_create_fix">
**Create lightweight FIX.md:**

1. Determine phase directory from STATE.md current phase
2. Find next available plan number in that phase directory:
   ```bash
   ls .paul/phases/{phase-dir}/*-PLAN.md *-FIX.md 2>/dev/null | wc -l
   ```
   Next number = count + 1, zero-padded to 2 digits.

3. Create `.paul/phases/{phase-dir}/{phase}-{NN}-FIX.md`:

```markdown
---
phase: {phase-slug}
plan: {NN}
type: fix
wave: 1
depends_on: []
files_modified: [determined during execution]
autonomous: true
---

<objective>
## Fix
{user's fix description}
</objective>

<tasks>

<task type="auto">
  <name>Fix: {description summary}</name>
  <files>{files to modify — derive from description or discover}</files>
  <action>
{specific fix actions — derive from description}
  </action>
  <verify>{verification approach — tests, manual check, build}</verify>
  <done>Fix verified working</done>
</task>

</tasks>

<verification>
- [ ] Fix applied and verified
- [ ] No regressions introduced
</verification>
```

**Note:** FIX.md is intentionally lightweight — no acceptance_criteria, boundaries, skills, or checkpoint sections. Just objective + tasks + verify.
</substep>

<substep name="standard_execute">
**Auto-approve and execute:**

1. Display: "Executing fix..."
2. Execute each task in FIX.md:
   - Read task action
   - Implement the fix
   - Run verification
   - If verification fails: report and offer retry/stop
3. Update FIX.md `files_modified` with actual files changed
</substep>

<substep name="standard_hooks_post_apply">
**Dispatch post-apply hooks:**
1. Read `modules.yaml` (installed module registry; see `references/module-dispatch.md`). If not found, emit `[dispatch] post-apply: modules.yaml NOT FOUND — WARNING` and skip dispatch.
2. Resolve installed modules for `post-apply` by finding `installed_modules.*.hook_details.post-apply`
3. Sort by `hook_details.post-apply.priority` ascending
4. For each registered module, load only `hook_details.post-apply.refs` and follow `hook_details.post-apply.description`
5. If the registry only exposes the legacy flat `hooks` list and lacks `hook_details`, warn that the install is stale and prefer regenerating `modules.yaml` before relying on fallback behavior
6. Output: `[dispatch] post-apply: {MODULE(priority) → outcome} | ...`
7. If any module blocks: surface reason, offer fix/override
</substep>

<substep name="standard_auto_summary">
**Create compressed FIX-SUMMARY draft:**

Create `.paul/phases/{phase-dir}/{phase}-{NN}-FIX-SUMMARY.md`:
~~~~markdown
---
phase: {phase-slug}
plan: {NN}
type: fix
completed: {ISO timestamp}
---

## Fix Summary
**Issue:** {description}
**Mode:** Standard fix

### Files Changed
| File | Change |
|------|--------|
| {path} | {what changed} |

### Verification
{verification result}

### Result
Fix applied successfully. {any notes}
### Module Execution Reports
<!-- Finalized after post-unify from carried-forward post-apply annotations plus any post-unify module_reports / recorded side_effects. Omit this section if no module evidence persists. -->
~~~~
</substep>
<substep name="standard_hooks_post_unify">
**Dispatch post-unify hooks:**
1. Read `modules.yaml` (installed module registry; see `references/module-dispatch.md`), or confirm already loaded. If not found, emit `[dispatch] post-unify: modules.yaml NOT FOUND — WARNING` and skip dispatch.
2. Resolve installed modules for `post-unify` by finding `installed_modules.*.hook_details.post-unify`
3. Sort by `hook_details.post-unify.priority` ascending
4. For each registered module, load only `hook_details.post-unify.refs` and follow `hook_details.post-unify.description`
5. If the registry only exposes the legacy flat `hooks` list and lacks `hook_details`, warn that the install is stale and prefer regenerating `modules.yaml` before relying on fallback behavior
6. Pass carried-forward post-apply annotations and summary path
7. Collect `module_reports` and `side_effects`
8. Output: `[dispatch] post-unify: {MODULE(priority) → N reports / N side effects | skip} | ...`
</substep>

<substep name="standard_finalize_summary">
**Finalize FIX-SUMMARY after post-unify:**
1. Re-open FIX-SUMMARY before state updates.
2. Merge:
   - carried-forward post-apply annotations
   - post-unify `module_reports`
   - recorded `side_effects` that should remain visible after the fix loop closes
3. Write the durable `Module Execution Reports` section, or remove the placeholder entirely if no module evidence persisted.
</substep>

<substep name="standard_update_state">
**Update STATE.md:**

Add to `### Decisions` or create a `### Fixes` subsection under Accumulated Context:
```markdown
| Fix {NN} (standard): {description} | Phase {N} | {files changed} |
```

Loop position remains unchanged (fix is a side-loop, not the main loop).
Display completion:
```
════════════════════════════════════════
FIX COMPLETE (standard)
════════════════════════════════════════

Fix: {description}
Files: {list}
FIX.md: {path}
SUMMARY: {path}

Loop position unchanged — continue normal work.
════════════════════════════════════════
```
</substep>

</step>

<!-- ═══════════════════════════════════════ -->
<!-- MODE: FAST-FORWARD (zero overhead)     -->
<!-- ═══════════════════════════════════════ -->

<step name="fast_forward" condition="mode == fast-forward">

<substep name="ff_confirm">
**Confirm with user:**

```
Fast-forward: {description}

This will make the change directly and commit. No plan files, no hooks.
Proceed? (y/n)
```

Wait for confirmation. If "n": return to mode selection.
</substep>

<substep name="ff_execute">
**Execute directly:**

1. Make the change described by user
2. Verify the change works (quick check)
3. If verification fails: revert and report
</substep>

<substep name="ff_commit">
**Git commit:**

```bash
git add {changed files}
git commit -m "fix(ff): {description}"
```
</substep>

<substep name="ff_log">
**Log to STATE.md:**

Add one-line entry to Accumulated Context under a `### Fixes` subsection:
```markdown
- Fix (ff): {description} — {timestamp}
```

Display:
```
════════════════════════════════════════
FIX COMPLETE (fast-forward)
════════════════════════════════════════

{description}
Commit: {hash}

No plan files created. Continue normal work.
════════════════════════════════════════
```
</substep>

</step>

<!-- ═══════════════════════════════════════ -->
<!-- MODE: HOTFIX (execute first)           -->
<!-- ═══════════════════════════════════════ -->

<step name="hotfix" condition="mode == hotfix">

<substep name="hotfix_check_changes">
**Check current state:**

```bash
git status --porcelain
git diff --stat
```

Two paths:
- **Changes exist:** show diff, ask user to describe what was fixed
- **No changes yet:** tell user to make the fix, then continue
</substep>

<substep name="hotfix_describe">
**Get description (if not already provided):**

If changes already exist and no description:
```
Uncommitted changes detected:

{git diff --stat output}

What was fixed? (brief description for the commit)
```

Wait for description.
</substep>

<substep name="hotfix_commit">
**Commit the hotfix:**

```bash
git add {changed files}
git commit -m "hotfix: {description}"
```
</substep>

<substep name="hotfix_flag_retroactive">
**Flag for retroactive UNIFY:**

Update STATE.md:
1. Add to Session Continuity:
   ```markdown
   Pending retroactive UNIFY: hotfix — {description} (commit: {hash})
   ```
2. Add to Accumulated Context `### Fixes`:
   ```markdown
   | Hotfix: {description} | Phase {N} | Pending retroactive UNIFY |
   ```

Display:
```
════════════════════════════════════════
HOTFIX COMMITTED
════════════════════════════════════════

{description}
Commit: {hash}

⚠ Pending retroactive UNIFY — run /paul:unify when ready
  to generate documentation for this hotfix.

Continue normal work. UNIFY will detect the pending flag.
════════════════════════════════════════
```
</substep>

</step>

</process>

<output>
Depends on mode:
- **Standard:** FIX.md + finalized FIX-SUMMARY.md + hook results + STATE.md entry
- **Fast-forward:** Git commit + one-line STATE.md entry
- **Hotfix:** Git commit + retroactive UNIFY flag in STATE.md
</output>

<error_handling>
**Fix verification fails (standard/ff):**
- Report failure clearly
- Offer: retry, revert (git checkout), or escalate to full PLAN
- If escalated: "This fix is more complex than expected. Run /paul:plan to create a full plan."

**Git commit fails:**
- Check for uncommitted conflicts
- Report git status
- Do not force-commit

**No phase directory (new project):**
- Create .paul/fixes/ as fallback directory for fixes outside phase context
- Log to STATE.md with "no phase" note

**Mode escalation:**
- If fast-forward reveals complexity (multiple files, test failures): suggest upgrading to standard mode
- "This looks more complex than a fast-forward. Switch to standard fix? (y/n)"
</error_handling>
