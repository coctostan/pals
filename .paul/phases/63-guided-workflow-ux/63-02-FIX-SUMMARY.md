---
phase: 63-guided-workflow-ux
plan: 02
type: fix
completed: 2026-03-16T18:57:51Z
---

## Fix Summary

**Issue:** Enabled modules were described as dispatching from `kernel/modules.yaml`, but the installed registry only exposed flat hook names, so PLAN/APPLY/UNIFY could not literally resolve per-hook priority, descriptions, and refs from the runtime registry.
**Mode:** Standard fix

### Files Changed

| File | Change |
|------|--------|
| `drivers/pi/install.sh` | Generate richer installed `modules.yaml` with `hook_details` carrying per-hook priority, description, and refs |
| `drivers/claude-code/install.sh` | Generate the same richer installed registry for Claude Code |
| `kernel/references/module-dispatch.md` | Added portable dispatch reference explaining how workflows resolve installed hook metadata |
| `kernel/workflows/plan-phase.md` | Updated pre/post-plan dispatch instructions to use installed `hook_details` instead of conceptual source-manifest access |
| `kernel/workflows/apply-phase.md` | Updated pre-apply, post-task, and post-apply dispatch instructions to use installed `hook_details` |
| `kernel/workflows/unify-phase.md` | Updated pre/post-unify dispatch instructions to use installed `hook_details` |
| `kernel/workflows/fix-loop.md` | Updated compressed fix post-apply/post-unify dispatch instructions the same way |
| `docs/MODULE-SPEC.md` | Documented the richer `modules.yaml` runtime registry shape |
| `docs/HOOK-CONTRACT.md` | Aligned hook contract wording with installed-registry-driven dispatch |
| `tests/pi-end-to-end-validation.sh` | Added validation for runtime hook metadata and refs in Pi-installed `modules.yaml` |
| `tests/cross-harness-validation.sh` | Added cross-harness validation for hook metadata/refs parity |

### Verification

- `bash tests/pi-end-to-end-validation.sh` → PASS (94/94)
- `bash tests/cross-harness-validation.sh` → PASS (48/48)
- Temporary Pi + Claude Code installs both produced `modules.yaml` registries with `hook_details`, including TODD and WALT refs

### Result

Fix applied successfully. Installed module registries now carry the metadata PLAN/APPLY/UNIFY need for real runtime dispatch, and shared workflows now explicitly consult that installed metadata instead of relying on conceptual access to source `module.yaml` manifests.
