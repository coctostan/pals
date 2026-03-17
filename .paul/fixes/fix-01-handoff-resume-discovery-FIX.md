---
phase: no-phase
plan: 01
type: fix
wave: 1
depends_on: []
files_modified:
  - kernel/workflows/resume-project.md
  - drivers/pi/skills/paul-resume/SKILL.md
  - kernel/commands/paul/resume.md
  - kernel/commands/paul/help.md
  - docs/ARTIFACT-SPEC.md
  - docs/TROUBLESHOOTING.md
autonomous: true
---

<objective>
## Fix
Make PAUL resume handoff discovery and documentation consistent by teaching resume to consider archived handoffs as fallback and by removing the claim that archived handoffs are never read.
</objective>

<tasks>

<task type="auto">
  <name>Fix: align handoff discovery and docs</name>
  <files>kernel/workflows/resume-project.md, drivers/pi/skills/paul-resume/SKILL.md, kernel/commands/paul/resume.md, kernel/commands/paul/help.md, docs/ARTIFACT-SPEC.md, docs/TROUBLESHOOTING.md</files>
  <action>
Update the canonical resume workflow to search active handoffs first and archived handoffs as fallback, while still trusting STATE.md as authoritative. Then align Pi skill and user-facing docs so they describe the same behavior and no longer claim archived handoffs are unreadable by active workflows.
  </action>
  <verify>Read the edited sections and grep for stale resume statements about only scanning `.paul/HANDOFF*.md` or archived handoffs not being read.</verify>
  <done>Resume discovery/docs are consistent and verified</done>
</task>

</tasks>

<verification>
- [ ] Fix applied and verified
- [ ] No regressions introduced
</verification>
