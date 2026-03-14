---
name: pals:fix
description: Quick fix with 3 modes — standard (compressed loop), fast-forward (zero overhead), hotfix (execute first)
argument-hint: "<description of the fix>"
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion]
---

<objective>
Direct entry point for ad-hoc fixes without full PLAN ceremony.

**When to use:** Bug found during development, small change needed, urgent fix required.

**Output:** Depends on mode — FIX.md + SUMMARY (standard), git commit (fast-forward), or retroactive SUMMARY (hotfix).
</objective>

<execution_context>
kernel/references/fix-types.md
kernel/workflows/fix-loop.md
</execution_context>

<context>
Fix description: $ARGUMENTS (optional — will prompt if not provided)

.paul/STATE.md
</context>

<process>

<step name="gather_description">
**Get fix description:**

1. If $ARGUMENTS provided: use as description
2. If no arguments: prompt user:
   ```
   What needs fixing? (describe the issue briefly)
   ```
   Wait for response.
</step>

<step name="detect_state">
**Check for signals:**

1. Check for uncommitted changes:
   ```bash
   git status --porcelain
   ```
2. Parse description for urgency keywords: "urgent", "prod", "breaking", "hotfix", "critical"
3. Parse description for trivial keywords: "typo", "config", "tweak", "rename", "1 file", "one file", "single"
4. Count files mentioned in description
</step>

<step name="classify_and_recommend">
**Recommend fix mode based on signals:**

- If uncommitted changes detected → recommend **hotfix**
- If urgency keywords found → recommend **hotfix**
- If trivial keywords found OR exactly 1 file mentioned → recommend **fast-forward**
- Otherwise → recommend **standard**

**Present to user:**
```
════════════════════════════════════════
FIX MODE
════════════════════════════════════════

Issue: [description]

Recommended: [mode] — [reason]

  [s] Standard fix  — compressed PLAN→APPLY→UNIFY
  [f] Fast-forward  — zero overhead, direct execution
  [h] Hotfix        — execute first, document later

────────────────────────────────────────
Select mode, or press Enter for [recommended]:
```

Wait for user input. Accept: "s"/"standard", "f"/"ff"/"fast", "h"/"hotfix", or Enter for default.
</step>

<step name="route_to_fix_loop">
**Route to fix-loop workflow:**

Pass to kernel/workflows/fix-loop.md:
- mode: selected mode
- description: fix description
- uncommitted_changes: true/false

The fix-loop workflow handles all execution for the selected mode.
</step>

</process>

<success_criteria>
- [ ] Fix description gathered
- [ ] Mode recommended based on signals
- [ ] User selected mode
- [ ] Routed to fix-loop workflow
</success_criteria>
