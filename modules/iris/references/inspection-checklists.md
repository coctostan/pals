<overview>
Inspection checklists organized by change type. Select the primary checklist based on the detected change type, then always include the general checklist items.

**Usage:** /paul:review detects the change type from git diff characteristics and presents the most relevant checklist. Multiple types may apply for mixed changes.
</overview>

<feature_checklist>

## Feature Checklist

New functionality or significant additions.

- [ ] **Correctness:** Does it do what it's supposed to? Test the happy path end-to-end
- [ ] **Edge cases:** What happens with empty input, null values, maximum sizes, concurrent access?
- [ ] **Error handling:** Are failures handled gracefully? Do error messages help the user?
- [ ] **Security:** Is user input validated? Are auth checks in place? Any new attack surface?
- [ ] **Tests:** Are there tests for the new behavior? Do they cover edge cases?
- [ ] **Backwards compatibility:** Does this break existing functionality? Are APIs additive?
- [ ] **Documentation:** Are new APIs/commands/features documented? Are inline comments clear?
- [ ] **Dependencies:** Were new dependencies added? Are they justified and maintained?

</feature_checklist>

<bugfix_checklist>

## Bugfix Checklist

Targeted fixes for reported issues.

- [ ] **Root cause:** Is the actual root cause fixed, not just the symptom?
- [ ] **Regression test:** Is there a test that would have caught this bug?
- [ ] **Related code:** Are similar patterns elsewhere affected by the same bug?
- [ ] **Minimal fix:** Is the fix focused? No scope creep or "while I'm here" changes?
- [ ] **Side effects:** Could this fix break other behavior? Check callers and dependents
- [ ] **Commit message:** Does it reference the issue/bug report?

</bugfix_checklist>

<refactor_checklist>

## Refactor Checklist

Structural changes without behavior modification.

- [ ] **Behavior preserved:** Does the code produce identical results before and after?
- [ ] **Tests pass:** Do all existing tests still pass without modification?
- [ ] **No scope creep:** Is this purely structural, or did new features sneak in?
- [ ] **Readability improved:** Is the code genuinely clearer, not just different?
- [ ] **Naming:** Are renamed symbols consistent across all references?
- [ ] **Imports/exports:** Are all module boundaries still clean after restructuring?

</refactor_checklist>

<config_checklist>

## Config / Infrastructure Checklist

Configuration, CI/CD, deployment, or infrastructure changes.

- [ ] **Secrets:** No credentials, API keys, or tokens committed
- [ ] **Environment parity:** Does this work in dev, staging, and production?
- [ ] **Rollback plan:** Can this change be reverted without data loss?
- [ ] **Monitoring:** Will failures be detected? Are alerts in place?
- [ ] **Permissions:** Are file permissions and access controls correct?
- [ ] **Documentation:** Are deployment steps or config requirements documented?

</config_checklist>

<general_checklist>

## General Checklist (All Change Types)

Apply these items to every review regardless of change type.

- [ ] **Naming:** Are variables, functions, and files named clearly and consistently?
- [ ] **Readability:** Can a new team member understand this code without explanation?
- [ ] **Test coverage:** Are the changes adequately tested? Are tests meaningful (not just passing)?
- [ ] **No debug artifacts:** No `console.log`, `print()`, `debugger`, or test credentials left in
- [ ] **No commented-out code:** Remove dead code; git preserves history
- [ ] **Commit hygiene:** Are commits atomic and well-described? No "fix" or "wip" in final commits
- [ ] **Boundaries respected:** Does this change stay within its module/layer boundaries?

</general_checklist>

<change_type_detection>

## Change Type Detection Heuristics

Used by /paul:review to select the primary checklist.

| Signal | Detected Type |
|--------|--------------|
| New files created (non-test) | Feature |
| Only test files added/modified | Test improvement |
| Config files only (.env, .yaml, CI files, Dockerfile) | Config/Infrastructure |
| Small, focused change (<50 lines) in existing code | Bugfix |
| Large restructuring, renames, no new behavior | Refactor |
| Mix of new files + existing modifications | Feature (default) |
| Deleted files only | Cleanup/Refactor |

**When multiple types apply:** Use the primary type's checklist plus the general checklist. Note secondary types in the review output.

</change_type_detection>
