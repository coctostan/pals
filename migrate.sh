#!/bin/bash
set -e

# ════════════════════════════════════════
# PALS Kernel/Module Migration Script
# ════════════════════════════════════════
# Restructures flat layout → kernel/ + modules/ using git mv
# Updates live symlinks and validates everything works
#
# Revert: git checkout . && rm -rf kernel/ modules/

PALS_ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$PALS_ROOT"

FORCE=false
if [ "$1" = "--force" ]; then
  FORCE=true
fi

echo "════════════════════════════════════════"
echo "PALS Migration: flat → kernel/modules"
echo "════════════════════════════════════════"
echo ""

# ── Pre-flight checks ────────────────────────────────────────────

echo "Pre-flight checks..."

# Verify repo root
if [ ! -f "$PALS_ROOT/install.sh" ] || [ ! -d "$PALS_ROOT/workflows" ] || [ ! -d "$PALS_ROOT/carl" ]; then
  echo "ERROR: Must run from PALS repo root."
  echo "Expected: install.sh, workflows/, carl/"
  exit 1
fi
echo "  [ok] Running from repo root"

# Check target dirs don't exist
if [ -d "$PALS_ROOT/kernel" ] || [ -d "$PALS_ROOT/modules" ]; then
  if [ "$FORCE" = true ]; then
    echo "  [warn] kernel/ or modules/ exist — --force specified, removing"
    rm -rf "$PALS_ROOT/kernel" "$PALS_ROOT/modules"
  else
    echo "ERROR: kernel/ or modules/ already exist. Use --force to overwrite."
    exit 1
  fi
fi
echo "  [ok] No existing kernel/ or modules/ directories"

# Detect carl-hook.py symlink
HOOK_SYMLINK="$HOME/.claude/hooks/carl-hook.py"
if [ -L "$HOOK_SYMLINK" ]; then
  HOOK_TARGET="$(readlink "$HOOK_SYMLINK")"
  echo "  [ok] carl-hook.py symlink found → $HOOK_TARGET"
else
  echo "  [warn] No symlink at $HOOK_SYMLINK (will create after move)"
fi

# Count source files
TOTAL_SRC=$(find workflows/ references/ templates/ rules/ carl/ hooks/ commands/ -type f ! -name '.gitkeep' | wc -l | tr -d ' ')
echo "  [ok] Source files found: $TOTAL_SRC"
echo ""

# ── Create directory structure ────────────────────────────────────

echo "Creating directory structure..."

mkdir -p kernel/workflows
mkdir -p kernel/references
mkdir -p kernel/templates/codebase
mkdir -p kernel/rules
mkdir -p kernel/commands/paul
mkdir -p modules/todd/references
mkdir -p modules/todd/workflows
mkdir -p modules/walt/references
mkdir -p modules/walt/workflows
mkdir -p modules/carl/config
mkdir -p modules/carl/hooks
mkdir -p modules/carl/commands/carl/tasks
mkdir -p modules/carl/commands/carl/templates

echo "  [ok] Directories created"
echo ""

# ── Move kernel workflows (20 files) ─────────────────────────────

echo "Moving kernel workflows..."

KERNEL_WORKFLOWS=(
  apply-phase.md
  complete-milestone.md
  configure-special-flows.md
  consider-issues.md
  create-milestone.md
  debug.md
  discovery.md
  discuss-milestone.md
  discuss-phase.md
  init-project.md
  map-codebase.md
  pause-work.md
  phase-assumptions.md
  plan-phase.md
  research.md
  resume-project.md
  roadmap-management.md
  transition-phase.md
  unify-phase.md
  verify-work.md
)

for f in "${KERNEL_WORKFLOWS[@]}"; do
  if [ -f "workflows/$f" ]; then
    git mv "workflows/$f" "kernel/workflows/$f"
  else
    echo "  [skip] workflows/$f not found"
  fi
done
echo "  [ok] Kernel workflows moved (${#KERNEL_WORKFLOWS[@]} files)"

# ── Move kernel references (11 files) ────────────────────────────

echo "Moving kernel references..."

KERNEL_REFS=(
  checkpoints.md
  ci-generation.md
  context-management.md
  git-strategy.md
  loop-phases.md
  plan-format.md
  research-quality-control.md
  sonarqube-integration.md
  specialized-workflow-integration.md
  subagent-criteria.md
  work-units.md
)

for f in "${KERNEL_REFS[@]}"; do
  if [ -f "references/$f" ]; then
    git mv "references/$f" "kernel/references/$f"
  else
    echo "  [skip] references/$f not found"
  fi
done
echo "  [ok] Kernel references moved (${#KERNEL_REFS[@]} files)"

# ── Move kernel templates (all) ──────────────────────────────────

echo "Moving kernel templates..."

TEMPLATE_COUNT=0
for f in templates/*.md; do
  if [ -f "$f" ]; then
    git mv "$f" "kernel/templates/$(basename "$f")"
    TEMPLATE_COUNT=$((TEMPLATE_COUNT + 1))
  fi
done
for f in templates/codebase/*.md; do
  if [ -f "$f" ]; then
    git mv "$f" "kernel/templates/codebase/$(basename "$f")"
    TEMPLATE_COUNT=$((TEMPLATE_COUNT + 1))
  fi
done
echo "  [ok] Kernel templates moved ($TEMPLATE_COUNT files)"

# ── Move kernel rules (all) ──────────────────────────────────────

echo "Moving kernel rules..."

RULE_COUNT=0
for f in rules/*.md; do
  if [ -f "$f" ]; then
    git mv "$f" "kernel/rules/$(basename "$f")"
    RULE_COUNT=$((RULE_COUNT + 1))
  fi
done
echo "  [ok] Kernel rules moved ($RULE_COUNT files)"

# ── Move kernel commands (all paul/) ─────────────────────────────

echo "Moving kernel commands..."

CMD_COUNT=0
for f in commands/paul/*.md; do
  if [ -f "$f" ]; then
    git mv "$f" "kernel/commands/paul/$(basename "$f")"
    CMD_COUNT=$((CMD_COUNT + 1))
  fi
done
echo "  [ok] Kernel commands moved ($CMD_COUNT files)"

# ── Move TODD module files ───────────────────────────────────────

echo "Moving TODD module files..."

TODD_REFS=(tdd.md tdd-detection.md tdd-plan-generation.md tdd-execution.md)
for f in "${TODD_REFS[@]}"; do
  if [ -f "references/$f" ]; then
    git mv "references/$f" "modules/todd/references/$f"
  else
    echo "  [skip] references/$f not found"
  fi
done

# plan-phase-tdd.md may not exist yet
if [ -f "workflows/plan-phase-tdd.md" ]; then
  git mv "workflows/plan-phase-tdd.md" "modules/todd/workflows/plan-phase-tdd.md"
fi

echo "  [ok] TODD files moved"

# ── Move WALT module files ───────────────────────────────────────

echo "Moving WALT module files..."

WALT_REFS=(
  quality-principles.md
  quality-runner.md
  quality-detection.md
  quality-lint.md
  quality-delta.md
  quality-history.md
)
for f in "${WALT_REFS[@]}"; do
  if [ -f "references/$f" ]; then
    git mv "references/$f" "modules/walt/references/$f"
  else
    echo "  [skip] references/$f not found"
  fi
done

if [ -f "workflows/quality-gate.md" ]; then
  git mv "workflows/quality-gate.md" "modules/walt/workflows/quality-gate.md"
fi

echo "  [ok] WALT files moved"

# ── Move CARL module files ───────────────────────────────────────

echo "Moving CARL module files..."

# Config files
CARL_CONFIGS=(manifest global context commands example-custom-domain)
for f in "${CARL_CONFIGS[@]}"; do
  if [ -f "carl/$f" ]; then
    git mv "carl/$f" "modules/carl/config/$f"
  else
    echo "  [skip] carl/$f not found"
  fi
done

# Hook
if [ -f "hooks/carl-hook.py" ]; then
  git mv "hooks/carl-hook.py" "modules/carl/hooks/carl-hook.py"
fi

# Commands
if [ -f "commands/carl/manager.md" ]; then
  git mv "commands/carl/manager.md" "modules/carl/commands/carl/manager.md"
fi
for f in commands/carl/tasks/*.md; do
  if [ -f "$f" ]; then
    git mv "$f" "modules/carl/commands/carl/tasks/$(basename "$f")"
  fi
done
for f in commands/carl/templates/*.md; do
  if [ -f "$f" ]; then
    git mv "$f" "modules/carl/commands/carl/templates/$(basename "$f")"
  fi
done

echo "  [ok] CARL files moved"

# ── Update live symlink ──────────────────────────────────────────

echo "Updating carl-hook.py symlink..."

NEW_HOOK_PATH="$PALS_ROOT/modules/carl/hooks/carl-hook.py"
if [ -f "$NEW_HOOK_PATH" ]; then
  ln -sf "$NEW_HOOK_PATH" "$HOOK_SYMLINK"
  chmod +x "$NEW_HOOK_PATH"
  echo "  [ok] Symlink updated: $HOOK_SYMLINK → $NEW_HOOK_PATH"

  # Validate symlink resolves
  if [ -f "$HOOK_SYMLINK" ]; then
    echo "  [ok] Symlink validated — target exists"
  else
    echo "  [FAIL] Symlink broken — target does not exist!"
    exit 1
  fi
else
  echo "  [FAIL] carl-hook.py not found at $NEW_HOOK_PATH after move!"
  exit 1
fi

# ── Create module.yaml manifests ─────────────────────────────────

echo "Creating module.yaml manifests..."

cat > modules/todd/module.yaml <<'YAML'
name: todd
display_name: TODD
description: >
  Test-Driven Development enforcement. Detects TDD candidates during planning,
  structures plans as RED-GREEN-REFACTOR, and enforces phase discipline during
  apply execution.
version: 1.0.0

dependencies:
  kernel: ">=0.4.0"
  modules: []

hooks:
  pre-plan:
    priority: 100
    description: Detect TDD candidates via file heuristics and phase metadata
  post-plan:
    priority: 100
    description: Restructure plan tasks as RED-GREEN-REFACTOR when TDD type detected
  pre-apply:
    priority: 50
    description: Enforce RED phase — verify test files exist or will be created first
  post-task:
    priority: 100
    description: Enforce GREEN phase — verify tests pass after each implementation task
  post-apply:
    priority: 200
    description: Signal REFACTOR opportunity — suggest cleanup if all tests green

files:
  references:
    - references/tdd.md
    - references/tdd-detection.md
    - references/tdd-plan-generation.md
    - references/tdd-execution.md
  workflows:
    - workflows/plan-phase-tdd.md
  templates: []
  config: []
  rules: []

commands: []

platform: {}
YAML
echo "  [ok] modules/todd/module.yaml"

cat > modules/walt/module.yaml <<'YAML'
name: walt
display_name: WALT
description: >
  Quality gating. Captures test baselines before apply, runs tests and lint
  after apply, detects regressions, and tracks quality trends across phases.
version: 1.0.0

dependencies:
  kernel: ">=0.4.0"
  modules: []

hooks:
  pre-apply:
    priority: 100
    description: Capture test baseline — run tests and record counts before changes
  post-apply:
    priority: 100
    description: Run tests, lint, typecheck; compare against baseline; gate on regressions
  post-unify:
    priority: 100
    description: Record quality delta in quality-history.md for trend tracking

files:
  references:
    - references/quality-principles.md
    - references/quality-runner.md
    - references/quality-detection.md
    - references/quality-lint.md
    - references/quality-delta.md
    - references/quality-history.md
  workflows:
    - workflows/quality-gate.md
  templates: []
  config: []
  rules: []

commands: []

platform: {}
YAML
echo "  [ok] modules/walt/module.yaml"

cat > modules/carl/module.yaml <<'YAML'
name: carl
display_name: CARL
description: >
  Context Augmentation & Reinforcement Layer. Manages domain-driven context
  rules that inject into every Claude prompt via keyword matching. Operates
  independently of the plan/apply/unify loop through Claude Code's native
  hook system.
version: 1.0.0

dependencies:
  kernel: ">=0.4.0"
  modules: []

hooks: {}
  # CARL does not use PAUL lifecycle hooks.
  # It operates through the platform.claude_code.hooks mechanism below.

files:
  references: []
  workflows: []
  templates: []
  config:
    - config/manifest
    - config/global
    - config/context
    - config/commands
    - config/example-custom-domain
  rules: []

commands:
  - name: carl:manager
    file: commands/carl/manager.md
    description: Manage CARL domains and rules
  - name: carl:tasks:add-rule
    file: commands/carl/tasks/add-rule.md
    description: Add a rule to a domain
  - name: carl:tasks:create-domain
    file: commands/carl/tasks/create-domain.md
    description: Create a new domain
  - name: carl:tasks:create-command
    file: commands/carl/tasks/create-command.md
    description: Create a new command
  - name: carl:tasks:edit-rule
    file: commands/carl/tasks/edit-rule.md
    description: Edit an existing rule
  - name: carl:tasks:toggle-domain
    file: commands/carl/tasks/toggle-domain.md
    description: Toggle domain active state

platform:
  claude_code:
    hooks:
      - event: UserPromptSubmit
        type: command
        command: "python3 ~/.claude/hooks/carl-hook.py"
        source: hooks/carl-hook.py
    settings_patch: {}
YAML
echo "  [ok] modules/carl/module.yaml"

# ── Clean up empty directories ───────────────────────────────────

echo "Cleaning up empty directories..."

# Remove .gitkeep files from now-empty dirs
rm -f hooks/.gitkeep

# Remove directories only if empty (or contain only empty subdirs)
for dir in workflows references templates/codebase templates rules hooks commands/paul commands/carl/tasks commands/carl/templates commands/carl carl commands; do
  if [ -d "$dir" ]; then
    if [ -z "$(ls -A "$dir" 2>/dev/null)" ]; then
      rmdir "$dir"
      echo "  [ok] Removed empty $dir/"
    else
      echo "  [skip] $dir/ not empty: $(ls "$dir" 2>/dev/null | head -3)"
    fi
  fi
done

echo ""

# ── Post-migration validation ────────────────────────────────────

echo "════════════════════════════════════════"
echo "Post-migration validation"
echo "════════════════════════════════════════"

ERRORS=0

KERNEL_COUNT=$(find kernel/ -type f | wc -l | tr -d ' ')
MODULE_COUNT=$(find modules/ -type f | wc -l | tr -d ' ')
echo "  Kernel files: $KERNEL_COUNT"
echo "  Module files: $MODULE_COUNT (includes 3 module.yaml)"
echo "  Total: $((KERNEL_COUNT + MODULE_COUNT))"

# Validate key files exist
check_file() {
  if [ ! -e "$1" ]; then
    echo "  [FAIL] Missing: $1"
    ERRORS=$((ERRORS + 1))
  fi
}

check_file kernel/workflows/plan-phase.md
check_file kernel/workflows/apply-phase.md
check_file kernel/workflows/unify-phase.md
check_file kernel/references/loop-phases.md
check_file kernel/templates/PLAN.md
check_file kernel/rules/style.md
check_file kernel/commands/paul/plan.md
check_file modules/todd/module.yaml
check_file modules/todd/references/tdd.md
check_file modules/walt/module.yaml
check_file modules/walt/references/quality-principles.md
check_file modules/walt/workflows/quality-gate.md
check_file modules/carl/module.yaml
check_file modules/carl/config/manifest
check_file modules/carl/hooks/carl-hook.py
check_file modules/carl/commands/carl/manager.md
check_file install.sh
check_file uninstall.sh
check_file README.md

# Validate symlink
if [ -L "$HOOK_SYMLINK" ]; then
  RESOLVED_TARGET="$(readlink "$HOOK_SYMLINK")"
  if echo "$RESOLVED_TARGET" | grep -q "modules/carl/hooks/carl-hook.py"; then
    echo "  [ok] Symlink points to modules/carl/hooks/carl-hook.py"
  else
    echo "  [FAIL] Symlink points to wrong target: $RESOLVED_TARGET"
    ERRORS=$((ERRORS + 1))
  fi
else
  echo "  [FAIL] No symlink at $HOOK_SYMLINK"
  ERRORS=$((ERRORS + 1))
fi

# Validate old dirs removed
for dir in workflows references templates rules carl hooks commands; do
  if [ -d "$dir" ]; then
    echo "  [FAIL] Old directory still exists: $dir/"
    ERRORS=$((ERRORS + 1))
  fi
done

echo ""
if [ $ERRORS -gt 0 ]; then
  echo "MIGRATION FAILED: $ERRORS validation errors above."
  echo "Revert with: git checkout . && rm -rf kernel/ modules/"
  exit 1
fi

echo "════════════════════════════════════════"
echo "Migration complete!"
echo "════════════════════════════════════════"
echo ""
echo "  kernel/    $KERNEL_COUNT files"
echo "  modules/   $MODULE_COUNT files (todd + walt + carl)"
echo "  Symlink:   ~/.claude/hooks/carl-hook.py → modules/carl/hooks/carl-hook.py"
echo ""
echo "Next: Update install.sh to reference new paths."
