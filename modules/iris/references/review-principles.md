<overview>
IRIS — Intelligent Review & Inspection System. Provides structured guidance for code review: what to look for, how to prioritize, and how to give actionable feedback.

**Philosophy:** Guide reviewers with structure, not replace judgment. IRIS surfaces relevant patterns and checklists based on what changed — focused review, not exhaustive audit.

**Core principle:** Detect change type → Select checklist → Surface relevant patterns → Suggest specific actions. Never auto-fix — only identify and guide.
</overview>

<approach>

## Detect → Select → Surface → Suggest

### 1. Detect
Analyze what changed: file types, change size, change pattern (new feature, bugfix, refactor, config). Use git diff to understand scope and nature of changes.

### 2. Select
Choose the appropriate inspection checklist based on detected change type. Feature changes get different scrutiny than bugfixes or refactors.

### 3. Surface
Present the review patterns most relevant to the specific changes. A change touching SQL gets injection checks; a change adding an API endpoint gets auth/validation checks.

### 4. Suggest
Provide specific, actionable review comments tied to the actual code changes. "Check line 42 for input validation" not "consider security."

</approach>

<review_scope>

## Focused Review, Not Exhaustive Audit

- Review what changed, not the entire codebase
- Prioritize: security > correctness > performance > readability
- Flag high-severity issues explicitly, note low-severity as suggestions
- Respect context: a prototype doesn't need production-grade review

## Tone Guidance

- Constructive: "Consider using X because Y" not "This is wrong"
- Specific: Point to exact files and lines, not vague concerns
- Actionable: Every finding should have a clear suggested fix
- Proportional: Match review depth to change significance

</review_scope>

<evolution>

## Future Evolution (v0.7+)

IRIS follows the same growth pattern as DEAN and WALT:

| Version | Capability |
|---------|-----------|
| v0.6 | Read-only guidance via /paul:review (current) |
| v0.7 | post-apply hook: auto-generate review notes for changes made during a plan |
| v0.8+ | pre-unify hook: flag unreviewed changes before closing the loop |
| Future | PR review integration, review history tracking, team convention learning |

**Hook integration pattern (future):**
- `post-apply`: Analyze all files changed during plan execution. Generate review notes highlighting patterns and checklist items relevant to the changes.
- `pre-unify`: Verify that changes were reviewed (or explicitly marked as self-reviewed) before closing the loop.

</evolution>

<constraints>

## Constraints

- Never auto-fix or auto-modify code based on review findings
- Never block execution — IRIS is advisory only in v0.6
- Review guidance is based on patterns, not deep static analysis
- Git is required for change detection
- Focus on the diff, not the entire file (unless context is needed)
- Respect boundaries: don't review files outside the specified scope

</constraints>
