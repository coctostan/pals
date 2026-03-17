---
phase: no-phase
plan: 01
type: fix
completed: 2026-03-16T17:07:56-04:00
---

## Fix Summary

**Issue:** Resume could archive handoffs into `.paul/handoffs/archive/` while normal discovery still only described/scanned top-level `.paul/HANDOFF*.md` files.
**Mode:** Standard fix

### Files Changed
| File | Change |
|------|--------|
| `kernel/workflows/resume-project.md` | Resume workflow now searches active handoffs first and archived handoffs as fallback; lifecycle notes only re-archive active consumed handoffs |
| `drivers/pi/skills/paul-resume/SKILL.md` | Pi resume skill instructions aligned with active-first/archive-fallback behavior |
| `kernel/commands/paul/resume.md` | Resume command docs now describe archive fallback explicitly |
| `kernel/commands/paul/help.md` | Help text now mentions archived handoff fallback and archived-path usage |
| `docs/ARTIFACT-SPEC.md` | Handoff lifecycle updated to say archived handoffs remain readable as fallback context |
| `docs/TROUBLESHOOTING.md` | Resume troubleshooting now tells users to check both active and archived handoff locations |
| `.paul/STATE.md` | Logged the standard fix without changing main loop position |

### Verification
- Read all edited resume workflow/skill/command/doc sections
- Confirmed no remaining stale statement that archived handoffs are "not read by any active workflow"
- Confirmed no remaining Pi skill instruction that only looks for `.paul/HANDOFF*.md`

### Result
Fix applied successfully. Resume documentation and workflow guidance are now internally consistent about archived handoff discovery.
