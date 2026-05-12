# Semantic module-instruction assertion helpers for PALS cross-harness validation.
#
# Purpose: support Phase 278 semantic guardrails that replace stale marker-only
# expectations inherited from Phase 276 CODI rewrites. Each helper checks whether
# a file or pair of files satisfies a group of literal-pattern signals; helpers
# return shell success/failure only and never print TAP lines.
#
# Caller contract:
#   - Source this file once near existing helper imports.
#   - On failure, the helper sets the global MIS_LAST_MISSING to a short
#     human-readable diagnostic describing the missing signal group.
#   - Callers own tap_ok / tap_not_ok output using MIS_LAST_MISSING as the
#     diagnostic. This keeps TAP counters in the caller as required by
#     tests/helpers/tap.sh.
#
# Patterns are treated as literal text (grep -Fq). No regex semantics.
#
# All helpers use POSIX-friendly bash (locals + arrays).

: "${MIS_LAST_MISSING:=}"

# Internal: returns 0 if every PATTERN appears in FILE; otherwise 1 and sets
# MIS_LAST_MISSING to a comma-joined list of missing patterns prefixed with FILE.
mis_file_has_all() {
  local file="$1"
  shift
  # Optional `--` separator support for readability in call sites.
  if [ "${1:-}" = "--" ]; then
    shift
  fi

  MIS_LAST_MISSING=""

  if [ ! -f "$file" ]; then
    MIS_LAST_MISSING="File not found: $file"
    return 1
  fi

  local missing=()
  local pattern
  for pattern in "$@"; do
    if ! grep -Fq -- "$pattern" "$file" 2>/dev/null; then
      missing+=("$pattern")
    fi
  done

  if [ "${#missing[@]}" -eq 0 ]; then
    return 0
  fi

  MIS_LAST_MISSING="$file missing: ${missing[*]}"
  return 1
}

# Both files must contain every PATTERN. Sets MIS_LAST_MISSING on first failure.
mis_files_all_have_all() {
  local file1="$1"
  local file2="$2"
  shift 2
  if [ "${1:-}" = "--" ]; then
    shift
  fi

  if ! mis_file_has_all "$file1" -- "$@"; then
    return 1
  fi
  if ! mis_file_has_all "$file2" -- "$@"; then
    return 1
  fi
  return 0
}

# FILE must contain at least MIN of the supplied PATTERNs.
mis_file_has_min_of() {
  local file="$1"
  local min="$2"
  shift 2
  if [ "${1:-}" = "--" ]; then
    shift
  fi

  MIS_LAST_MISSING=""

  if [ ! -f "$file" ]; then
    MIS_LAST_MISSING="File not found: $file"
    return 1
  fi

  local hits=0
  local missing=()
  local pattern
  for pattern in "$@"; do
    if grep -Fq -- "$pattern" "$file" 2>/dev/null; then
      hits=$((hits + 1))
    else
      missing+=("$pattern")
    fi
  done

  if [ "$hits" -ge "$min" ]; then
    return 0
  fi

  MIS_LAST_MISSING="$file has $hits/${#} of required signals (min $min); missing: ${missing[*]}"
  return 1
}

# Both files must independently satisfy the min-of contract.
mis_files_all_have_min_of() {
  local file1="$1"
  local file2="$2"
  local min="$3"
  shift 3
  if [ "${1:-}" = "--" ]; then
    shift
  fi

  if ! mis_file_has_min_of "$file1" "$min" -- "$@"; then
    return 1
  fi
  if ! mis_file_has_min_of "$file2" "$min" -- "$@"; then
    return 1
  fi
  return 0
}

# ── CODI source-selector semantics ──────────────────────────────────
#
# Verify a CODI-bearing file (installed modules.yaml or repo module.yaml)
# carries the behaviour groups required by the CODI pre-plan contract:
#   (A) TS/JS file-extension breadth: at least 3 of {.ts, .tsx, .js, .jsx}
#   (B) Bounded explicit-seed extraction: at least 2 of
#       {top-level, exported, explicit, bounded, STEP 1}
#   (C) Per-symbol impact contract: 'impact' present AND at least one of
#       {per seed, once per, singleSymbol, never batched, Never batch}
#   (D) Safe skip semantics: at least 2 of
#       {skip, advisory, never block, no symbols, tool-unavailable,
#        codegraph tools unavailable, unavailable}
#   (E) Dispatch evidence emission: '[dispatch] CODI' AND at least one of
#       {success counts, N/R/U/K, skip reason, skip log}
#
# Diagnostic on failure cites which group failed.
mis_codi_source_selector_semantics_ok() {
  local file="$1"
  MIS_LAST_MISSING=""

  if [ ! -f "$file" ]; then
    MIS_LAST_MISSING="File not found: $file"
    return 1
  fi

  if ! mis_file_has_min_of "$file" 3 -- ".ts" ".tsx" ".js" ".jsx"; then
    MIS_LAST_MISSING="CODI selectors group A (TS/JS extension breadth) failed in $file"
    return 1
  fi

  if ! mis_file_has_min_of "$file" 2 -- \
      "top-level" "exported" "explicit" "bounded" "STEP 1"; then
    MIS_LAST_MISSING="CODI selectors group B (bounded explicit extraction) failed in $file"
    return 1
  fi

  if ! grep -Fq -- "impact" "$file" 2>/dev/null; then
    MIS_LAST_MISSING="CODI selectors group C (per-symbol impact) failed in $file: missing 'impact'"
    return 1
  fi
  if ! mis_file_has_min_of "$file" 1 -- \
      "per seed" "once per" "singleSymbol" "never batched" "Never batch"; then
    MIS_LAST_MISSING="CODI selectors group C (per-symbol impact isolation) failed in $file"
    return 1
  fi

  if ! mis_file_has_min_of "$file" 2 -- \
      "skip" "advisory" "never block" "no symbols" "tool-unavailable" \
      "codegraph tools unavailable" "unavailable"; then
    MIS_LAST_MISSING="CODI selectors group D (safe skip semantics) failed in $file"
    return 1
  fi

  if ! grep -Fq -- "[dispatch] CODI" "$file" 2>/dev/null; then
    MIS_LAST_MISSING="CODI selectors group E (dispatch evidence) failed in $file: missing '[dispatch] CODI'"
    return 1
  fi
  if ! mis_file_has_min_of "$file" 1 -- \
      "success counts" "N/R/U/K" "skip reason" "skip log"; then
    MIS_LAST_MISSING="CODI selectors group E (dispatch evidence detail) failed in $file"
    return 1
  fi

  return 0
}

# ── CODI reference (codi.md) source-selector + safe-setup semantics ─
#
# Groups (for installed or repo codi.md):
#   (A) Fit signal: at least 2 of {TS/JS, .ts, indexed, boundary, structural}
#   (B) Symbol extraction rules: 'Symbol Extraction Rules' OR 'Accepted seeds'
#       OR 'Allowed reads' AND at least one of {top-level, exported, declaration}
#   (C) Per-symbol impact: 'impact' AND one of {per, once, Never batch, batched}
#   (D) Safe skip/no-codegraph: at least 2 of
#       {skip, advisory, never block, codegraph, index, unavailable, safe}
#   (E) Post-unify pointer: 'codi-instrumentation.md'
mis_codi_ref_semantics_ok() {
  local file="$1"
  MIS_LAST_MISSING=""

  if [ ! -f "$file" ]; then
    MIS_LAST_MISSING="File not found: $file"
    return 1
  fi

  if ! mis_file_has_min_of "$file" 2 -- \
      "TS/JS" ".ts" "indexed" "boundary" "structural"; then
    MIS_LAST_MISSING="CODI ref group A (fit signal) failed in $file"
    return 1
  fi

  if ! mis_file_has_min_of "$file" 1 -- \
      "Symbol Extraction Rules" "Accepted seeds" "Allowed reads"; then
    MIS_LAST_MISSING="CODI ref group B (extraction rules header) failed in $file"
    return 1
  fi
  if ! mis_file_has_min_of "$file" 1 -- \
      "top-level" "exported" "declaration"; then
    MIS_LAST_MISSING="CODI ref group B (extraction-rules content) failed in $file"
    return 1
  fi

  if ! grep -Fq -- "impact" "$file" 2>/dev/null; then
    MIS_LAST_MISSING="CODI ref group C (impact mention) failed in $file"
    return 1
  fi
  if ! mis_file_has_min_of "$file" 1 -- \
      "per " "once" "Never batch" "batched"; then
    MIS_LAST_MISSING="CODI ref group C (per-symbol impact contract) failed in $file"
    return 1
  fi

  if ! mis_file_has_min_of "$file" 2 -- \
      "skip" "advisory" "never block" "codegraph" "index" "unavailable" "safe"; then
    MIS_LAST_MISSING="CODI ref group D (safe-skip/no-codegraph semantics) failed in $file"
    return 1
  fi

  if ! grep -Fq -- "codi-instrumentation.md" "$file" 2>/dev/null; then
    MIS_LAST_MISSING="CODI ref group E (post-unify pointer) failed in $file"
    return 1
  fi

  return 0
}

# ── CODI post-unify dispatch-outcome semantics (manifest) ───────────
#
# Verify a CODI-bearing modules.yaml (installed) carries the post-unify
# instrumentation contract:
#   - 'post-unify' present
#   - '.paul/CODI-HISTORY.md' or 'CODI-HISTORY.md' present
#   - 'codi-instrumentation.md' ref present
#   - 'no-dispatch-found' outcome token present
#   - PLAN-primary/SUMMARY-fallback read order signal (at least one of
#     {PLAN .. SUMMARY, summary_path, Module Execution Reports, Blast Radius})
#   - Append-row schema signal (at least one of
#     {Append, Plan, Date, Outcome, blast_radius})
mis_codi_post_unify_manifest_ok() {
  local file="$1"
  MIS_LAST_MISSING=""

  if [ ! -f "$file" ]; then
    MIS_LAST_MISSING="File not found: $file"
    return 1
  fi

  if ! mis_file_has_all "$file" -- \
      "post-unify" "CODI-HISTORY.md" "codi-instrumentation.md" "no-dispatch-found"; then
    return 1
  fi

  if ! mis_file_has_min_of "$file" 1 -- \
      "summary_path" "Module Execution Reports" "Blast Radius"; then
    MIS_LAST_MISSING="CODI post-unify manifest missing PLAN-primary/SUMMARY-fallback read-order signal in $file"
    return 1
  fi

  if ! mis_file_has_min_of "$file" 2 -- \
      "Append" "Plan" "Date" "Outcome" "blast_radius"; then
    MIS_LAST_MISSING="CODI post-unify manifest missing append/row-schema signals in $file"
    return 1
  fi

  return 0
}

# ── CODI pre-plan skip/success taxonomy semantics (manifest) ────────
#
# The installed manifest description describes STEP behaviour rather than
# repeating the verbatim log strings (those live in references/codi.md).
# Verify the manifest carries:
#   (A) At least 2 distinct skip-outcome signals from
#       {STEP 1, STEP 2, STEP 3, STEP 4,
#        no-symbols skip log, tool-unavailable skip log,
#        skipped-no-symbols, skipped-tool-unavailable, skipped-loop-error}
#   (B) At least one success/evidence-emission signal from
#       {[dispatch] CODI, success counts, N/R/U/K, success log, Blast Radius}
mis_codi_pre_plan_taxonomy_manifest_ok() {
  local file="$1"
  MIS_LAST_MISSING=""

  if [ ! -f "$file" ]; then
    MIS_LAST_MISSING="File not found: $file"
    return 1
  fi

  if ! mis_file_has_min_of "$file" 2 -- \
      "STEP 1" "STEP 2" "STEP 3" "STEP 4" \
      "no-symbols skip log" "tool-unavailable skip log" \
      "skipped-no-symbols" "skipped-tool-unavailable" "skipped-loop-error"; then
    MIS_LAST_MISSING="CODI pre-plan manifest missing skip-taxonomy signals in $file"
    return 1
  fi

  if ! mis_file_has_min_of "$file" 1 -- \
      "[dispatch] CODI" "success counts" "N/R/U/K" "success log" "Blast Radius"; then
    MIS_LAST_MISSING="CODI pre-plan manifest missing success/evidence-emission signal in $file"
    return 1
  fi

  return 0
}

# ── CODI canonical skip/success log strings (codi.md) ───────────────
#
# Verify the installed or repo codi.md carries the four canonical literal
# dispatch log strings. The deprecated 'impact returned empty blast radius
# for all symbols' is intentionally NOT required (Phase 276 retired
# `skipped-all-empty` as a legacy-only token per
# modules/codi/references/codi-instrumentation.md).
mis_codi_canonical_log_strings_ok() {
  local file="$1"
  mis_file_has_all "$file" -- \
    "no extractable symbols in phase scope" \
    "codegraph tools unavailable" \
    "impact loop errored:" \
    "impact × N symbols → R resolved, U unresolved, K total call-sites, injected blast_radius"
}
