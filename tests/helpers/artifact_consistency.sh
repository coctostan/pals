# Artifact consistency helper for PALS validation suites.
#
# Phase 237 Artifact Consistency Guardrails / Plan 237-01.
# Source: docs/PALS-ARTIFACT-CONSISTENCY-GUARDRAILS.md.
#
# Authority: Derived aid only. `.paul/*` artifacts remain authoritative
# lifecycle truth. This helper reports drift; it never writes, repairs,
# or decides lifecycle status. No telemetry. No hidden state.
#
# Safe to source: defines functions only, runs no checks, emits no output.
# Public function: artifact_consistency_check "<repo_root>"
#   Returns: 0 on PASS, 1 on drift. Emits diagnostics to stderr only on FAIL.

# ── Internal helpers ───────────────────────────────────────────────

_ac_diag() {
  # Emit a single diagnostic line to stderr.
  printf '  # %s\n' "$1" 1>&2
}

_ac_grep_fixed_q() {
  # _ac_grep_fixed_q PATTERN FILE
  # Returns 0 if PATTERN is a fixed-string match in FILE, else 1.
  grep -Fq -- "$1" "$2" 2>/dev/null
}

_ac_extract_state_phase_number() {
  # Echo the integer phase number from STATE.md "Phase: N of M ..."
  # Empty if not found.
  local state_file="$1"
  [ -f "$state_file" ] || return 0
  awk '
    /^Phase:[[:space:]]+[0-9]+/ {
      for (i = 1; i <= NF; i++) {
        if ($i ~ /^[0-9]+$/) { print $i; exit }
      }
    }
  ' "$state_file"
}

_ac_extract_state_phase_slug_part() {
  # Echo the parenthesized phase name from STATE.md "Phase: N of M (Name) — ..."
  # Empty if not found. Example output: "Artifact Consistency Guardrails"
  local state_file="$1"
  [ -f "$state_file" ] || return 0
  awk -F'[()]' '
    /^Phase:[[:space:]]+[0-9]+[[:space:]]+of[[:space:]]+[0-9]+/ {
      print $2; exit
    }
  ' "$state_file"
}

_ac_extract_state_resume_file() {
  # Echo the value following "Resume file:" in STATE.md.
  # Empty if not present or empty.
  local state_file="$1"
  [ -f "$state_file" ] || return 0
  awk '
    /^Resume file:/ {
      sub(/^Resume file:[[:space:]]*/, "")
      print
      exit
    }
  ' "$state_file"
}

_ac_find_active_handoffs() {
  # Echo zero or more active root handoff paths under .paul/HANDOFF*.md.
  # Archived handoffs under .paul/handoffs/archive are intentionally excluded.
  local repo_root="$1"
  [ -d "$repo_root/.paul" ] || return 0
  find "$repo_root/.paul" -maxdepth 1 -type f -name 'HANDOFF*.md' 2>/dev/null
}

# ── Individual drift checks ────────────────────────────────────────

_ac_check_state_vs_roadmap() {
  # Failure: STATE phase number is not present in the ROADMAP current
  # milestone phase table OR the slug name is not echoed in ROADMAP.
  local repo_root="$1"
  local state_file="$repo_root/.paul/STATE.md"
  local roadmap_file="$repo_root/.paul/ROADMAP.md"
  local rc=0

  if [ ! -f "$state_file" ]; then
    _ac_diag "Missing .paul/STATE.md"
    return 1
  fi
  if [ ! -f "$roadmap_file" ]; then
    _ac_diag "Missing .paul/ROADMAP.md"
    return 1
  fi

  local phase_num phase_name
  phase_num="$(_ac_extract_state_phase_number "$state_file")"
  phase_name="$(_ac_extract_state_phase_slug_part "$state_file")"

  if [ -z "$phase_num" ]; then
    _ac_diag "STATE.md does not declare a current 'Phase: N of M' line"
    return 1
  fi

  # The current-milestone phase table in ROADMAP renders rows like:
  #   "| 237 | Artifact Consistency Guardrails | ..."
  # A simple anchored match for "| <num> |" is enough to confirm membership.
  if ! grep -Eq "^\|[[:space:]]*${phase_num}[[:space:]]*\|" "$roadmap_file" 2>/dev/null; then
    _ac_diag "ROADMAP current milestone table does not list phase ${phase_num}"
    rc=1
  fi

  if [ -n "$phase_name" ]; then
    if ! _ac_grep_fixed_q "$phase_name" "$roadmap_file"; then
      _ac_diag "ROADMAP does not mention STATE phase name: ${phase_name}"
      rc=1
    fi
  fi

  return "$rc"
}

_ac_check_milestones_pointer() {
  # Failure: MILESTONES.md does not name STATE's current phase number, OR
  # the live-status row still names a phase number that STATE has marked
  # complete (e.g., "Phase 235 ready to plan" while STATE is on 237).
  local repo_root="$1"
  local state_file="$repo_root/.paul/STATE.md"
  local milestones_file="$repo_root/.paul/MILESTONES.md"
  local rc=0

  if [ ! -f "$milestones_file" ]; then
    _ac_diag "Missing .paul/MILESTONES.md"
    return 1
  fi

  local phase_num
  phase_num="$(_ac_extract_state_phase_number "$state_file")"
  if [ -z "$phase_num" ]; then
    return 0
  fi

  # MILESTONES should mention the current phase number somewhere in the
  # Live Status table or the Current/Future Milestone Pointer paragraph.
  if ! grep -Eq "Phase[[:space:]]+${phase_num}([^0-9]|$)" "$milestones_file" 2>/dev/null; then
    _ac_diag "MILESTONES.md does not mention current Phase ${phase_num}"
    rc=1
  fi

  return "$rc"
}

_ac_check_latest_summary_frontmatter() {
  # Failure: a .paul/phases/<slug>/<plan>-SUMMARY.md path that ROADMAP
  # references does not exist, or its YAML frontmatter `phase:` value
  # disagrees with the slug, or `plan:` does not match the filename plan.
  local repo_root="$1"
  local roadmap_file="$repo_root/.paul/ROADMAP.md"
  local rc=0

  [ -f "$roadmap_file" ] || return 0

  # Pull all referenced SUMMARY paths under .paul/phases/.
  local summaries
  summaries="$(grep -oE '\.paul/phases/[A-Za-z0-9._-]+/[0-9A-Za-z._-]+-SUMMARY\.md' "$roadmap_file" 2>/dev/null \
    | sort -u)"

  [ -n "$summaries" ] || return 0

  local rel
  while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    local abs="$repo_root/$rel"
    if [ ! -f "$abs" ]; then
      _ac_diag "ROADMAP references missing SUMMARY: $rel"
      rc=1
      continue
    fi

    # Expected slug: directory under .paul/phases/.
    local slug plan_id
    slug="$(printf '%s' "$rel" | awk -F'/' '{print $3}')"
    # Filenames look like '<phase-num>-<plan-id>-SUMMARY.md'; the frontmatter
    # plan field stores '<plan-id>' only (e.g. '01' for '236-01-SUMMARY.md').
    plan_id="$(basename "$rel" -SUMMARY.md | awk -F'-' '{print $2}')"

    # Read frontmatter (first YAML block between leading --- markers).
    local fm_phase fm_plan
    fm_phase="$(awk '
      BEGIN { in_fm = 0 }
      NR == 1 && /^---[[:space:]]*$/ { in_fm = 1; next }
      in_fm && /^---[[:space:]]*$/ { exit }
      in_fm && /^phase:[[:space:]]*/ {
        sub(/^phase:[[:space:]]*/, "")
        gsub(/[[:space:]]+$/, "")
        print
        exit
      }
    ' "$abs")"
    fm_plan="$(awk '
      BEGIN { in_fm = 0 }
      NR == 1 && /^---[[:space:]]*$/ { in_fm = 1; next }
      in_fm && /^---[[:space:]]*$/ { exit }
      in_fm && /^plan:[[:space:]]*/ {
        sub(/^plan:[[:space:]]*/, "")
        gsub(/[[:space:]]+$/, "")
        print
        exit
      }
    ' "$abs")"

    if [ -n "$fm_phase" ] && [ "$fm_phase" != "$slug" ]; then
      _ac_diag "SUMMARY frontmatter phase '$fm_phase' disagrees with directory slug '$slug' ($rel)"
      rc=1
    fi
    if [ -n "$fm_plan" ] && [ -n "$plan_id" ] && [ "$fm_plan" != "$plan_id" ]; then
      _ac_diag "SUMMARY frontmatter plan '$fm_plan' disagrees with filename plan '$plan_id' ($rel)"
      rc=1
    fi
  done <<<"$summaries"

  return "$rc"
}

_ac_check_resume_file() {
  # Failure: STATE Session Continuity has a non-empty `Resume file:` value
  # whose path does not exist (active or archived).
  local repo_root="$1"
  local state_file="$repo_root/.paul/STATE.md"
  local rc=0

  [ -f "$state_file" ] || return 0

  local resume
  resume="$(_ac_extract_state_resume_file "$state_file")"
  if [ -z "$resume" ]; then
    return 0
  fi

  # Resolve relative paths against repo root.
  local abs="$resume"
  case "$resume" in
    /*) abs="$resume" ;;
    *)  abs="$repo_root/$resume" ;;
  esac

  if [ ! -f "$abs" ]; then
    _ac_diag "STATE 'Resume file: $resume' does not exist on disk"
    rc=1
  fi

  return "$rc"
}

_ac_check_active_handoffs() {
  # Failure: an active root .paul/HANDOFF*.md exists that does not match
  # STATE's `Resume file:` value. Archived handoffs under
  # .paul/handoffs/archive/ are never failures.
  local repo_root="$1"
  local state_file="$repo_root/.paul/STATE.md"
  local rc=0

  local handoffs
  handoffs="$(_ac_find_active_handoffs "$repo_root")"
  [ -n "$handoffs" ] || return 0

  local resume resume_basename
  resume="$(_ac_extract_state_resume_file "$state_file")"
  resume_basename=""
  if [ -n "$resume" ]; then
    resume_basename="$(basename "$resume")"
  fi

  local h
  while IFS= read -r h; do
    [ -n "$h" ] || continue
    local h_basename
    h_basename="$(basename "$h")"
    if [ -z "$resume_basename" ] || [ "$h_basename" != "$resume_basename" ]; then
      _ac_diag "Active handoff '.paul/$h_basename' is not STATE's Resume file"
      rc=1
    fi
  done <<<"$handoffs"

  return "$rc"
}

# ── Public entry point ─────────────────────────────────────────────

artifact_consistency_check() {
  # Usage: artifact_consistency_check "$REPO_ROOT"
  # Returns 0 if all drift classes pass, 1 otherwise.
  local repo_root="${1:-.}"
  local rc=0

  _ac_check_state_vs_roadmap         "$repo_root" || rc=1
  _ac_check_milestones_pointer       "$repo_root" || rc=1
  _ac_check_latest_summary_frontmatter "$repo_root" || rc=1
  _ac_check_resume_file              "$repo_root" || rc=1
  _ac_check_active_handoffs          "$repo_root" || rc=1

  return "$rc"
}

# When executed directly, run the check against the repo this file lives in.
if [ "${BASH_SOURCE[0]:-}" = "${0:-}" ] && [ -n "${BASH_SOURCE[0]:-}" ]; then
  _ac_self_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  _ac_repo_root="$(cd "$_ac_self_dir/../.." && pwd)"
  if artifact_consistency_check "$_ac_repo_root"; then
    echo "artifact_consistency_check: PASS"
    exit 0
  else
    echo "artifact_consistency_check: FAIL" 1>&2
    exit 1
  fi
fi
