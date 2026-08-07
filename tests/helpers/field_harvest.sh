# Field-harvest normalization guardrail helpers for PALS validation suites.
#
# Purpose: support Phase 307 behavioral guardrails over tools/harvest-module-ledger.sh.
# Unlike marker-only checks, these helpers RUN the harvester against the committed
# fixture corpus and compare its output to hand-written goldens that encode
# docs/PALS-FIELD-HARVEST-NORMALIZATION-CONTRACT.md.
#
# Caller contract:
#   - Source this file once near existing helper imports.
#   - Helpers return shell success/failure only and never print TAP lines.
#   - On failure the helper sets the global FH_LAST_MISSING to a short
#     human-readable diagnostic. Callers own tap_ok / tap_not_ok output so TAP
#     counters stay in the caller as required by tests/helpers/tap.sh.
#
# The goldens are the specification. If the harvester and a golden disagree,
# that is a contract question to reason through — never a file to regenerate.

: "${FH_LAST_MISSING:=}"

FH_FIXTURE_ROOT="${FH_FIXTURE_ROOT:-tests/fixtures/field-harvest}"
FH_HARVESTER="${FH_HARVESTER:-tools/harvest-module-ledger.sh}"
FH_DEPLOYMENT="fixture"

# Internal: strip the markdown table wrapper back to TSV for exact comparison.
# Skips the header row and the |---| separator.
fh__table_to_tsv() {
  local file="$1"
  sed -n 's/^| \(.*\) |$/\1/p' "$file" \
    | grep -v '^-\{1,\}\( | -\{1,\}\)*$' \
    | grep -v '^Phase | Module | Status' \
    | grep -v '^Deployment | Path | Reason' \
    | sed 's/ | /\t/g'
}

# Run the harvester against the fixture corpus into DEST. Returns 1 on failure.
fh_run_harvest() {
  local repo_root="$1" dest="$2"
  FH_LAST_MISSING=""

  if [ ! -f "$repo_root/$FH_HARVESTER" ]; then
    FH_LAST_MISSING="Harvester not found: $repo_root/$FH_HARVESTER"
    return 1
  fi
  if [ ! -d "$repo_root/$FH_FIXTURE_ROOT/.paul/phases" ]; then
    FH_LAST_MISSING="Fixture corpus not found: $repo_root/$FH_FIXTURE_ROOT/.paul/phases"
    return 1
  fi

  if ! ( cd "$repo_root" && bash "$FH_HARVESTER" \
           --root "$FH_FIXTURE_ROOT" \
           --deployment "$FH_DEPLOYMENT" \
           --out-dir "$dest" ) >/dev/null 2>&1; then
    FH_LAST_MISSING="Harvester exited non-zero against the fixture corpus"
    return 1
  fi
  return 0
}

# Harvested rows must equal tests/fixtures/field-harvest/expected-rows.tsv exactly.
fh_check_golden_rows() {
  local repo_root="$1" dest="$2"
  local golden="$repo_root/$FH_FIXTURE_ROOT/expected-rows.tsv"
  local ledger="$dest/${FH_DEPLOYMENT}-MODULE-LEDGER.md"
  FH_LAST_MISSING=""

  if [ ! -f "$golden" ]; then FH_LAST_MISSING="Golden not found: $golden"; return 1; fi
  if [ ! -f "$ledger" ]; then FH_LAST_MISSING="Ledger not produced: $ledger"; return 1; fi

  local actual="$dest/actual-rows.tsv"
  fh__table_to_tsv "$ledger" > "$actual"

  if ! diff -q "$golden" "$actual" >/dev/null 2>&1; then
    FH_LAST_MISSING="Harvested rows differ from golden: $(diff "$golden" "$actual" | head -6 | tr '\n' ' ')"
    return 1
  fi
  return 0
}

# Manifest must equal tests/fixtures/field-harvest/expected-unparseable.tsv exactly.
fh_check_golden_manifest() {
  local repo_root="$1" dest="$2"
  local golden="$repo_root/$FH_FIXTURE_ROOT/expected-unparseable.tsv"
  local manifest="$dest/UNPARSEABLE.md"
  FH_LAST_MISSING=""

  if [ ! -f "$golden" ]; then FH_LAST_MISSING="Golden not found: $golden"; return 1; fi
  if [ ! -f "$manifest" ]; then FH_LAST_MISSING="Manifest not produced: $manifest"; return 1; fi

  local actual="$dest/actual-manifest.tsv"
  fh__table_to_tsv "$manifest" > "$actual"

  if ! diff -q "$golden" "$actual" >/dev/null 2>&1; then
    FH_LAST_MISSING="Manifest differs from golden: $(diff "$golden" "$actual" | head -6 | tr '\n' ' ')"
    return 1
  fi
  return 0
}

# Two independent runs must be byte-identical (contract §8 determinism).
fh_check_determinism() {
  local repo_root="$1" a="$2" b="$3"
  FH_LAST_MISSING=""

  if ! fh_run_harvest "$repo_root" "$b"; then return 1; fi

  local f
  for f in "${FH_DEPLOYMENT}-MODULE-LEDGER.md" "UNPARSEABLE.md"; do
    if ! diff -q "$a/$f" "$b/$f" >/dev/null 2>&1; then
      FH_LAST_MISSING="Non-deterministic output across runs: $f"
      return 1
    fi
  done
  return 0
}

# The harvested corpus must be untouched: --root is read-only (contract §1).
fh_check_sources_unmodified() {
  local repo_root="$1" before="$2"
  FH_LAST_MISSING=""
  local after
  after="$( cd "$repo_root" && find "$FH_FIXTURE_ROOT" -type f -exec cksum {} \; | LC_ALL=C sort )"
  if [ "$before" != "$after" ]; then
    FH_LAST_MISSING="Harvester modified its read-only source corpus"
    return 1
  fi
  return 0
}

# Capture a checksum snapshot of the fixture corpus for the check above.
fh_snapshot_sources() {
  local repo_root="$1"
  ( cd "$repo_root" && find "$FH_FIXTURE_ROOT" -type f -exec cksum {} \; | LC_ALL=C sort )
}

# Every Status cell must be one of the six enum values (ledger contract §Row Format).
fh_check_status_enum() {
  local ledger="$1"
  FH_LAST_MISSING=""
  if [ ! -f "$ledger" ]; then FH_LAST_MISSING="Ledger not found: $ledger"; return 1; fi

  local bad
  bad="$( sed -n 's/^| [^|]* | [^|]* | \([^|]*\) | [^|]* | [^|]* |$/\1/p' "$ledger" \
          | sed 's/^ *//; s/ *$//' \
          | grep -vx 'PASS\|PASS_WITH_CONCERNS\|WARN\|BLOCK\|SKIP\|NOTE\|Status' \
          | LC_ALL=C sort -u | tr '\n' ' ' )"
  if [ -n "$(printf '%s' "$bad" | tr -d ' ')" ]; then
    FH_LAST_MISSING="Status values outside the six-value enum: $bad"
    return 1
  fi
  return 0
}

# Retroactive harvest must not invent Actioned? = yes (contract §6). Any `yes`
# must be traceable to an explicit in-source Actioned?: yes token.
fh_check_no_inferred_actioned() {
  local repo_root="$1" ledger="$2"
  FH_LAST_MISSING=""
  if [ ! -f "$ledger" ]; then FH_LAST_MISSING="Ledger not found: $ledger"; return 1; fi

  local claimed sourced
  claimed="$( grep -c '| yes |$' "$ledger" 2>/dev/null || true )"
  sourced="$( grep -ro 'Actioned?: yes' "$repo_root/$FH_FIXTURE_ROOT" 2>/dev/null | wc -l | tr -d ' ' )"
  claimed="${claimed:-0}"; sourced="${sourced:-0}"

  if [ "$claimed" -gt "$sourced" ]; then
    FH_LAST_MISSING="Ledger claims $claimed Actioned?=yes rows but sources state only $sourced"
    return 1
  fi
  return 0
}

# The forward-looking UNIFY-owned ledger must never contain harvested rows.
fh_check_forward_ledger_unpolluted() {
  local forward_ledger="$1"
  FH_LAST_MISSING=""
  [ -f "$forward_ledger" ] || return 0
  if grep -qE '^\| [a-z0-9-]+/' "$forward_ledger" 2>/dev/null; then
    FH_LAST_MISSING="Namespaced field-harvest rows leaked into $forward_ledger"
    return 1
  fi
  return 0
}

# Rejecting an out-of-bounds --out-dir must leave the harvested deployment
# byte-identical AND path-identical: a refusal that still created a directory
# inside the source tree has already broken the read-only guarantee (contract
# §1). Verified against a disposable sandbox that stands in for an external
# deployment root, so the real field deployments are never used as test targets.
fh_check_write_boundary_creates_nothing() {
  local repo_root="$1" sandbox="$2"
  FH_LAST_MISSING=""

  mkdir -p "$sandbox/.paul/phases/01-boundary"
  printf '# Boundary sandbox summary\n' > "$sandbox/.paul/phases/01-boundary/01-01-SUMMARY.md"

  local before after
  before="$( cd "$sandbox" && find . | LC_ALL=C sort )"

  if ( cd "$repo_root" && bash "$FH_HARVESTER" \
         --root "$sandbox" \
         --deployment "$FH_DEPLOYMENT" \
         --out-dir "$sandbox/.paul/field-harvest" ) >/dev/null 2>&1; then
    FH_LAST_MISSING="Harvester accepted an --out-dir inside the harvested deployment"
    return 1
  fi

  after="$( cd "$sandbox" && find . | LC_ALL=C sort )"
  if [ "$before" != "$after" ]; then
    FH_LAST_MISSING="Rejected run still created paths inside the harvested deployment"
    return 1
  fi
  return 0
}
