# pals.json Schema Reference

Canonical schema for project-level PALS configuration. This is the single source of truth for field names, types, defaults, and migration behavior.

## schema_version

| Field | Type | Default | Since |
|-------|------|---------|-------|
| `schema_version` | string | none (absent on old projects) | v2.24 |

Matches the `kernel_version` from installed `modules.yaml`. Used by plan-phase and resume-project to detect when migration is needed. If missing or mismatched, the `migrate_pals_json` step runs automatically.

## modules

Module enable/disable config. All modules default to `enabled: true` if absent.

| Field | Type | Default | Since |
|-------|------|---------|-------|
| `modules.carl.enabled` | bool | true | v0.4 |
| `modules.carl.description` | string | "Session boundary manager (Pi extension)" | v0.4 |
| `modules.carl.session_strategy` | string | "phase-boundary" | v2.11 |
| `modules.carl.continue_threshold` | number | 0.4 | v2.11 |
| `modules.carl.safety_ceiling` | number | 0.8 | v2.11 |
| `modules.todd.enabled` | bool | true | v0.4 |
| `modules.todd.description` | string | "Test-driven development enforcement" | v0.4 |
| `modules.walt.enabled` | bool | true | v0.4 |
| `modules.walt.description` | string | "Quality gating & validation" | v0.4 |
| `modules.dean.enabled` | bool | true | v0.6 |
| `modules.dean.description` | string | "Dependency evaluation & audit notifier" | v0.6 |
| `modules.iris.enabled` | bool | true | v0.6 |
| `modules.iris.description` | string | "Intelligent review & inspection system" | v0.6 |
| `modules.skip.enabled` | bool | true | v0.7 |
| `modules.skip.description` | string | "Smart knowledge & information persistence" | v0.7 |
| `modules.dave.enabled` | bool | true | v0.7 |
| `modules.dave.description` | string | "Deploy automation & verification engine" | v0.7 |
| `modules.ruby.enabled` | bool | true | v0.7 |
| `modules.ruby.description` | string | "Refactor utility & better-code yielder" | v0.7 |
| `modules.arch.enabled` | bool | true | v2.20 |
| `modules.arch.description` | string | "Architecture pattern detection & boundary enforcement" | v2.20 |
| `modules.seth.enabled` | bool | true | v2.20 |
| `modules.seth.description` | string | "Security evaluation & threat hunting" | v2.20 |
| `modules.pete.enabled` | bool | true | v2.20 |
| `modules.pete.description` | string | "Performance evaluation & tuning expert" | v2.20 |
| `modules.gabe.enabled` | bool | true | v2.20 |
| `modules.gabe.description` | string | "Gateway & API boundary expert" | v2.20 |
| `modules.luke.enabled` | bool | true | v2.21 |
| `modules.luke.description` | string | "UI/UX pattern detection & review" | v2.21 |
| `modules.aria.enabled` | bool | true | v2.21 |
| `modules.aria.description` | string | "Accessibility assessment & enforcement" | v2.21 |
| `modules.dana.enabled` | bool | true | v2.21 |
| `modules.dana.description` | string | "Data pattern detection & migration safety" | v2.21 |
| `modules.omar.enabled` | bool | true | v2.22 |
| `modules.omar.description` | string | "Observability & logging review" | v2.22 |
| `modules.reed.enabled` | bool | true | v2.22 |
| `modules.reed.description` | string | "Resilience pattern detection & review" | v2.22 |
| `modules.vera.enabled` | bool | true | v2.22 |
| `modules.vera.description` | string | "Privacy assessment & PII protection" | v2.22 |
| `modules.docs.enabled` | bool | true | v0.9.1 |
| `modules.docs.description` | string | "Documentation drift detection & lifecycle oversight" | v0.9.1 |
| `modules.rev.enabled` | bool | true | v2.33 |
| `modules.rev.description` | string | "Thorough code review via subagent" | v2.33 |
| `modules.rev.model` | string\|null | `null` | v2.33 |
| `modules.rev.pr_review` | bool | `false` | v2.33 |
| `modules.rev.pr_review_block_on_critical` | bool | `true` | v2.33 |

**Note:** Runtime dispatch reads `modules.yaml` (installed registry), not this section. Per-project module disable at runtime is a planned future feature. Until then, this section is informational — all installed modules dispatch regardless.

## agents

Agent-routing config for bounded subagent paths. These fields control optional delegated execution defaults without changing parent lifecycle authority.

| Field | Type | Default | Since |
|-------|------|---------|-------|
| `agents.implementer.enabled` | bool | `true` | v2.34 |
| `agents.implementer.model` | string\|null | `null` | v2.34 |

`agents.implementer` documents the explicit config surface used by delegated APPLY for the repo-controlled `pals-implementer`. Migration should add this block when missing and preserve any existing user-provided values.

## git

Git automation config. All fields have safe jq defaults.

| Field | Type | Default | Since | Purpose |
|-------|------|---------|-------|---------|
| `git.workflow` | string | `"none"` | v2.12 | `"github-flow"`, `"legacy"`, or `"none"` |
| `git.remote` | string\|null | `null` | v0.9.1 | Git remote URL |
| `git.base_branch` | string | `"main"` | v2.12 | Base branch for feature branches |
| `git.merge_method` | string | `"squash"` | v2.12 | PR merge method |
| `git.worktree_isolation` | bool | `false` | v1.0 | Use git worktrees for phase isolation |
| `git.auto_push` | bool | `false` | v0.9.1 | Push after APPLY |
| `git.auto_pr` | bool | `false` | v0.9.1 | Create PR after push |
| `git.ci_checks` | bool | `false` | v0.9.1 | Surface CI status |
| `git.delete_branch_on_merge` | bool | `true` | v2.12 | Delete feature branch after merge |
| `git.update_branch_when_behind` | bool | `true` | v2.13 | Auto-rebase when behind base |
| `git.require_pr_before_next_phase` | bool | `false` | v2.12 | Block next phase until PR merged |
| `git.require_reviews` | bool | `false` | v2.12 | Require PR reviews before merge |

**Legacy field:** `git.branching` (string, default: `"feature-per-phase"`) — used before `git.workflow` was added. If `git.workflow` is absent but `git.branching` exists, workflows resolve to `"legacy"` mode.

## planning

| Field | Type | Default | Since |
|-------|------|---------|-------|
| `planning.default_collaboration` | string | `"medium"` | v2.6 |

Values: `"low"`, `"medium"`, `"high"`.

## preferences

| Field | Type | Default | Since |
|-------|------|---------|-------|
| `preferences.auto_commit` | bool | `false` | v1.0 |
| `preferences.verbose_output` | bool | `false` | v1.0 |

## guided_workflow

| Field | Type | Default | Since |
|-------|------|---------|-------|
| `guided_workflow.auto_present.plan_review` | bool | `false` | v2.30 |
| `guided_workflow.auto_present.apply_approval` | bool | `false` | v2.30 |
| `guided_workflow.auto_present.continue_to_unify` | bool | `true` | v2.30 |
| `guided_workflow.auto_present.checkpoint_decision` | bool | `true` | v2.30 |
| `guided_workflow.auto_present.checkpoint_human_verify` | bool | `true` | v2.30 |
| `guided_workflow.auto_present.checkpoint_human_action` | bool | `true` | v2.30 |
| `guided_workflow.auto_present.resume_next` | bool | `true` | v2.30 |
| `guided_workflow.auto_present.phase_transition` | bool | `false` | v2.30 |
| `guided_workflow.auto_present.milestone_transition` | bool | `false` | v2.30 |

Controls whether the Pi guided workflow extension auto-presents interactive dialogs for each transition type.
- `false` = notify-only (user responds in chat prompt)
- `true` = auto-present interactive confirm/select dialog

## integrations

| Field | Type | Default | Since |
|-------|------|---------|-------|
| `integrations.sonarqube.enabled` | bool | `false` | v0.8 |
| `integrations.sonarqube.project_key` | string | `""` | v0.8 |

## Migration

When PALS is updated and a project has an older pals.json:

1. **Missing fields get defaults.** Workflows use `jq -r '.field // default'` so missing fields never crash.
2. **Automatic migration** runs during `/paul:init` on an existing project — adds missing fields with defaults, preserves existing values, shows what changed.
3. **No destructive changes.** Migration only adds — never removes or overwrites user choices.

The canonical field list above is the migration target. Any field present in this schema but absent from a project's pals.json should be added with its default.
