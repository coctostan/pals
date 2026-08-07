#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# PALS cross-deployment field-harvest roll-up
#
# Aggregates committed harvest output into the cross-deployment view specified
# by docs/PALS-FIELD-HARVEST-NORMALIZATION-CONTRACT.md §10.
#
# The contract is authoritative. This script implements it; it does not define
# it. On any disagreement the contract wins and this script is wrong.
#
# Guarantees:
#   - Inputs are the committed ledgers and manifest ONLY. Source SUMMARYs are
#     never re-parsed, so the roll-up cannot disagree with its inputs.
#   - --in-dir is READ-ONLY. Output goes only to --out.
#   - Deterministic: identical inputs produce byte-identical output.
#   - Malformed input is a hard error, never a silently empty roll-up.
#
# Usage:
#   tools/rollup-field-harvest.sh --in-dir <dir> --out <path> [--dry-run]
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

export LC_ALL=C

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"

STATUS_ORDER="PASS PASS_WITH_CONCERNS WARN BLOCK SKIP NOTE"

IN_DIR=""
OUT=""
DRY_RUN=0

die() { printf 'rollup: %s\n' "$1" >&2; exit 1; }

usage() {
  sed -n '2,20p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

# Absolute-path resolution that never creates a directory (same discipline as
# tools/harvest-module-ledger.sh: boundary checks must precede any mkdir).
resolve_abs_path() {
  local path="$1" suffix="" parent
  case "$path" in
    /*) : ;;
    *)  path="$PWD/$path" ;;
  esac
  while [ ! -d "$path" ]; do
    suffix="$(basename -- "$path")${suffix:+/$suffix}"
    parent="$(dirname -- "$path")"
    [ "$parent" != "$path" ] || break
    path="$parent"
  done
  path="$(cd -- "$path" && pwd -P)"
  if [ -n "$suffix" ]; then
    printf '%s/%s\n' "$path" "$suffix"
  else
    printf '%s\n' "$path"
  fi
}

while [ $# -gt 0 ]; do
  case "$1" in
    --in-dir)  IN_DIR="${2:-}"; shift 2 ;;
    --out)     OUT="${2:-}"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help) usage 0 ;;
    *)         die "unknown argument: $1" ;;
  esac
done

[ -n "$IN_DIR" ] || die "--in-dir is required"
[ -n "$OUT" ]    || die "--out is required"
[ -d "$IN_DIR" ] || die "--in-dir is not a directory: $IN_DIR"

IN_ABS="$(resolve_abs_path "$IN_DIR")"
OUT_ABS="$(resolve_abs_path "$OUT")"

# Output stays inside the PALS repo or a temp dir (fixtures harvest to temp).
TMP_ROOT="$(cd -- "${TMPDIR:-/tmp}" && pwd -P)"
case "$OUT_ABS/" in
  "$REPO_ROOT"/*) : ;;
  "$TMP_ROOT"/*)  : ;;
  /tmp/*)         : ;;
  *) die "refusing to write outside the PALS repo or a temp dir: $OUT_ABS (repo: $REPO_ROOT)" ;;
esac

MANIFEST_IN="$IN_ABS/UNPARSEABLE.md"

TMP_DIR="$(mktemp -d)"
cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

ROWS="$TMP_DIR/rows.tsv"        # deployment \t module \t status
REASONS="$TMP_DIR/reasons.tsv"  # deployment \t reason
: > "$ROWS"
: > "$REASONS"

# ── Ledger ingestion ─────────────────────────────────────────────────────────
# A ledger whose table cannot be read is an error: reporting "no evidence" for
# a deployment whose ledger merely failed to parse would invert its meaning.
LEDGER_COUNT=0
for ledger in "$IN_ABS"/*-MODULE-LEDGER.md; do
  [ -e "$ledger" ] || continue
  LEDGER_COUNT=$((LEDGER_COUNT + 1))

  base="$(basename -- "$ledger")"
  deployment="${base%-MODULE-LEDGER.md}"
  [ -n "$deployment" ] || die "cannot derive deployment name from: $base"

  grep -q '^| Phase | Module | Status | Finding? | Actioned? |$' "$ledger" \
    || die "malformed ledger (missing row header): $ledger"

  before="$(wc -l < "$ROWS" | tr -d ' ')"
  sed -n 's/^| \([^|]*\) | \([^|]*\) | \([^|]*\) | \([^|]*\) | \([^|]*\) |$/\1\t\2\t\3/p' "$ledger" \
    | awk -F'\t' -v d="$deployment" '
        function trim(s) { gsub(/^[[:space:]]+|[[:space:]]+$/, "", s); return s }
        { p = trim($1); m = trim($2); s = trim($3) }
        p == "Phase" { next }
        p ~ /^-+$/   { next }
        { printf "%s\t%s\t%s\n", d, m, s }
      ' >> "$ROWS"
  after="$(wc -l < "$ROWS" | tr -d ' ')"

  [ "$after" -gt "$before" ] || die "ledger produced no rows: $ledger"
done

[ "$LEDGER_COUNT" -gt 0 ] || die "no *-MODULE-LEDGER.md files found in: $IN_ABS"

# Every emitted status must be inside the six-value enum. A stray value means
# the ledger or the harvester is wrong; aggregating it would launder the error.
bad_status="$(cut -f3 "$ROWS" | sort -u | grep -vx 'PASS\|PASS_WITH_CONCERNS\|WARN\|BLOCK\|SKIP\|NOTE' | tr '\n' ' ' || true)"
[ -z "$(printf '%s' "$bad_status" | tr -d ' ')" ] \
  || die "status values outside the six-value enum: $bad_status"

# ── Manifest ingestion ───────────────────────────────────────────────────────
if [ -f "$MANIFEST_IN" ]; then
  grep -q '^| Deployment | Path | Reason | Detail |$' "$MANIFEST_IN" \
    || die "malformed manifest (missing header): $MANIFEST_IN"

  sed -n 's/^| \([^|]*\) | \([^|]*\) | \([^|]*\) | \(.*\) |$/\1\t\3/p' "$MANIFEST_IN" \
    | awk -F'\t' '
        function trim(s) { gsub(/^[[:space:]]+|[[:space:]]+$/, "", s); return s }
        { d = trim($1); r = trim($2) }
        d == "Deployment" { next }
        d ~ /^-+$/        { next }
        { printf "%s\t%s\n", d, r }
      ' >> "$REASONS"
fi

DEPLOYMENTS="$(cut -f1 "$ROWS" | sort -u)"

# ── Rendering ────────────────────────────────────────────────────────────────
render() {
  printf '# Field Harvest Cross-Deployment Roll-Up\n\n'
  printf '> **Derived aid — not lifecycle truth.** Aggregated from committed `.paul/field-harvest/*-MODULE-LEDGER.md` and `UNPARSEABLE.md` by `tools/rollup-field-harvest.sh` per `docs/PALS-FIELD-HARVEST-NORMALIZATION-CONTRACT.md` §10. Warm, derived, regenerable, byte-budget-exempt; never hand-edited.\n'
  printf '>\n'
  printf '> These counts measure **recorded dispatch evidence**. They do not measure module value, do not rank modules, and are not sufficient grounds to demote, disable, or reconfigure one. `rows harvested` is not `dispatches that occurred`. Phase 308 proposals must cite source SUMMARYs, not roll-up totals alone.\n\n'

  # Coverage: row counts are never shown without their unparseable volume.
  printf '## Coverage\n\n'
  printf '| Deployment | Rows | Unparseable | Unparseable Share |\n'
  printf '|---|---:|---:|---:|\n'
  total_rows=0
  total_unp=0
  for d in $DEPLOYMENTS; do
    r="$(awk -F'\t' -v d="$d" '$1 == d' "$ROWS" | wc -l | tr -d ' ')"
    u="$(awk -F'\t' -v d="$d" '$1 == d' "$REASONS" | wc -l | tr -d ' ')"
    printf '| %s | %s | %s | %s%% |\n' "$d" "$r" "$u" "$(share "$u" "$r")"
    total_rows=$((total_rows + r))
    total_unp=$((total_unp + u))
  done
  printf '| **Total** | **%s** | **%s** | **%s%%** |\n\n' \
    "$total_rows" "$total_unp" "$(share "$total_unp" "$total_rows")"

  # Module reach: absence renders as an em dash, never as a measured zero.
  printf '## Module Reach\n\n'
  printf '| Module'
  for d in $DEPLOYMENTS; do printf ' | %s' "$d"; done
  printf ' | Total |\n'
  printf '|---'
  for _ in $DEPLOYMENTS; do printf '|---:'; done
  printf '|---:|\n'
  for m in $MODULES; do
    printf '| %s' "$m"
    mt=0
    for d in $DEPLOYMENTS; do
      c="$(awk -F'\t' -v d="$d" -v m="$m" '$1 == d && $2 == m' "$ROWS" | wc -l | tr -d ' ')"
      if [ "$c" -eq 0 ]; then printf ' | —'; else printf ' | %s' "$c"; fi
      mt=$((mt + c))
    done
    printf ' | %s |\n' "$mt"
  done
  printf '\n'

  printf '## Status Distribution\n\n'
  printf '| Module'
  for s in $STATUS_ORDER; do printf ' | %s' "$s"; done
  printf ' |\n'
  printf '|---'
  for _ in $STATUS_ORDER; do printf '|---:'; done
  printf '|\n'
  for m in $MODULES; do
    printf '| %s' "$m"
    for s in $STATUS_ORDER; do
      c="$(awk -F'\t' -v m="$m" -v s="$s" '$2 == m && $3 == s' "$ROWS" | wc -l | tr -d ' ')"
      printf ' | %s' "$c"
    done
    printf ' |\n'
  done
  printf '\n'

  printf '## Unparseable Reasons\n\n'
  printf '| Deployment | Reason | Count |\n'
  printf '|---|---|---:|\n'
  sort "$REASONS" | uniq -c | awk '{ c = $1; d = $2; r = $3; printf "| %s | %s | %s |\n", d, r, c }'
}

# Integer percent of the unparseable share, rounded half up (contract §10).
share() {
  local u="$1" r="$2" denom
  denom=$((u + r))
  if [ "$denom" -eq 0 ]; then printf '0'; return; fi
  printf '%s' $(( (u * 200 + denom) / (denom * 2) ))
}

MODULES="$(cut -f2 "$ROWS" | sort -u)"

if [ "$DRY_RUN" -eq 1 ]; then
  render
else
  mkdir -p -- "$(dirname -- "$OUT_ABS")"
  render > "$OUT_ABS"
fi

printf 'rollup: %s deployments, %s rows, %s unparseable\n' \
  "$(printf '%s\n' "$DEPLOYMENTS" | wc -l | tr -d ' ')" \
  "$(wc -l < "$ROWS" | tr -d ' ')" \
  "$(wc -l < "$REASONS" | tr -d ' ')" >&2
