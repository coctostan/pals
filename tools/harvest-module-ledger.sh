#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# PALS retroactive field harvest
#
# Normalizes historical SUMMARY module dispatch evidence into the row format
# fixed by docs/PALS-MODULE-EFFICACY-LEDGER-CONTRACT.md, following the parsing,
# mapping, and exclusion rules in docs/PALS-FIELD-HARVEST-NORMALIZATION-CONTRACT.md.
#
# The contracts are authoritative. This script implements them; it does not
# define them. On any disagreement the contracts win and this script is wrong.
#
# Guarantees:
#   - --root is READ-ONLY. Nothing under it is ever written.
#   - Writes only under --out-dir, which must resolve inside the PALS repo.
#   - Deterministic: identical inputs produce byte-identical outputs.
#   - Never coerces an unmapped status token; never infers Actioned? = yes.
#
# Usage:
#   tools/harvest-module-ledger.sh --root <dir> --deployment <slug> \
#                                  --out-dir <dir> [--manifest <path>] [--dry-run]
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

export LC_ALL=C

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"

CANONICAL_REGISTRY="arch aria codi dana dave dean docs gabe iris luke omar pete reed rev ruby seth skip todd vera walt"

ROOT=""
DEPLOYMENT=""
OUT_DIR=""
MANIFEST=""
DRY_RUN=0

die() { printf 'harvest: %s\n' "$1" >&2; exit 1; }

usage() {
  sed -n '2,21p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

while [ $# -gt 0 ]; do
  case "$1" in
    --root)       ROOT="${2:-}"; shift 2 ;;
    --deployment) DEPLOYMENT="${2:-}"; shift 2 ;;
    --out-dir)    OUT_DIR="${2:-}"; shift 2 ;;
    --manifest)   MANIFEST="${2:-}"; shift 2 ;;
    --dry-run)    DRY_RUN=1; shift ;;
    -h|--help)    usage 0 ;;
    *)            die "unknown argument: $1" ;;
  esac
done

[ -n "$ROOT" ]       || die "--root is required"
[ -n "$DEPLOYMENT" ] || die "--deployment is required"
[ -n "$OUT_DIR" ]    || die "--out-dir is required"
[ -d "$ROOT" ]       || die "--root is not a directory: $ROOT"

case "$DEPLOYMENT" in
  *[!a-z0-9-]*) die "--deployment must be a lowercase slug: $DEPLOYMENT" ;;
esac

ROOT_ABS="$(cd -- "$ROOT" && pwd -P)"
PHASES_DIR="$ROOT_ABS/.paul/phases"
[ -d "$PHASES_DIR" ] || die "no .paul/phases directory under --root: $ROOT_ABS"

# ── Write-boundary enforcement ───────────────────────────────────────────────
# Two distinct guarantees, in priority order:
#   1. HARD: output never lands inside the harvested deployment. This is the
#      contract-critical read-only guarantee and has no exceptions.
#   2. Output otherwise stays inside the PALS repo, or a process temp dir so
#      fixtures can be harvested without touching the working tree.
mkdir -p -- "$OUT_DIR"
OUT_ABS="$(cd -- "$OUT_DIR" && pwd -P)"

case "$OUT_ABS/" in
  "$ROOT_ABS"/*) die "refusing to write inside the harvested deployment: $OUT_ABS (root: $ROOT_ABS)" ;;
esac

TMP_ROOT="$(cd -- "${TMPDIR:-/tmp}" && pwd -P)"
case "$OUT_ABS/" in
  "$REPO_ROOT"/*) : ;;
  "$TMP_ROOT"/*)  : ;;
  /tmp/*)         : ;;
  *) die "refusing to write outside the PALS repo or a temp dir: $OUT_ABS (repo: $REPO_ROOT)" ;;
esac

LEDGER="$OUT_ABS/${DEPLOYMENT}-MODULE-LEDGER.md"
[ -n "$MANIFEST" ] || MANIFEST="$OUT_ABS/UNPARSEABLE.md"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf -- "$TMP_DIR"' EXIT
ROWS_RAW="$TMP_DIR/rows.tsv"
MANIFEST_RAW="$TMP_DIR/manifest.tsv"
: > "$ROWS_RAW"
: > "$MANIFEST_RAW"

# ── Discovery ────────────────────────────────────────────────────────────────
find "$PHASES_DIR" -type f -name '*SUMMARY.md' -print \
  | LC_ALL=C sort > "$TMP_DIR/summaries.txt"

while IFS= read -r summary; do
  [ -n "$summary" ] || continue
  rel="${summary#"$ROOT_ABS"/}"
  tail="${rel#.paul/phases/}"

  # Segment depth below .paul/phases/ decides ownership.
  #   phase-dir/file            -> owned by this deployment
  #   phase-dir/nested/file     -> foreign evidence (class X), excluded
  depth="$(printf '%s' "$tail" | awk -F'/' '{print NF}')"

  if [ "$depth" -gt 2 ]; then
    printf '%s\t%s\t%s\t%s\n' \
      "$DEPLOYMENT" "$rel" "excluded-foreign-evidence" "nested below phase directory" \
      >> "$MANIFEST_RAW"
    continue
  fi

  if [ "$depth" -lt 2 ]; then
    printf '%s\t%s\t%s\t%s\n' \
      "$DEPLOYMENT" "$rel" "no-phase-id" "summary is not inside a phase directory" \
      >> "$MANIFEST_RAW"
    continue
  fi

  phase_dir="${tail%%/*}"
  base="$(basename -- "$summary")"

  # Phase number from the phase directory's leading digits.
  phase_no="$(printf '%s' "$phase_dir" | sed -n 's/^\([0-9][0-9]*\).*/\1/p')"
  if [ -z "$phase_no" ]; then
    printf '%s\t%s\t%s\t%s\n' \
      "$DEPLOYMENT" "$rel" "no-phase-id" "phase directory has no leading number: $phase_dir" \
      >> "$MANIFEST_RAW"
    continue
  fi

  # Plan number from {NN}-{PP}-SUMMARY.md. Absence is not a failure (contract §2).
  plan_no="$(printf '%s' "$base" | sed -n 's/^[0-9][0-9]*-\([0-9][0-9]*\)-SUMMARY\.md$/\1/p')"
  if [ -n "$plan_no" ]; then
    phase_cell="$DEPLOYMENT/$phase_no-$plan_no"
  else
    phase_cell="$DEPLOYMENT/$phase_no"
  fi

  awk -v phase_cell="$phase_cell" \
      -v deployment="$DEPLOYMENT" \
      -v relpath="$rel" \
      -v registry="$CANONICAL_REGISTRY" \
      -v rows_out="$ROWS_RAW" \
      -v manifest_out="$MANIFEST_RAW" \
      -f "$SCRIPT_DIR/lib/parse-summary.awk" \
      -- "$summary"
done < "$TMP_DIR/summaries.txt"

# ── Deterministic ordering ───────────────────────────────────────────────────
ROWS_SORTED="$TMP_DIR/rows.sorted.tsv"
MANIFEST_SORTED="$TMP_DIR/manifest.sorted.tsv"
LC_ALL=C sort -t "$(printf '\t')" -k1,1 -k2,2 -u "$ROWS_RAW" > "$ROWS_SORTED"
LC_ALL=C sort -t "$(printf '\t')" -k2,2 -k3,3 -k4,4 -u "$MANIFEST_RAW" > "$MANIFEST_SORTED"

render_ledger() {
  printf '# Field Harvest Module Ledger — %s\n\n' "$DEPLOYMENT"
  printf '> **Derived aid — not lifecycle truth.** Rows are normalized from historical SUMMARY module dispatch evidence by `tools/harvest-module-ledger.sh` per `docs/PALS-FIELD-HARVEST-NORMALIZATION-CONTRACT.md`. Source SUMMARY files remain authoritative. This file is warm, derived, and regenerable; it is never written by UNIFY, never gates lifecycle flow, and never demotes a module.\n\n'
  printf '| Phase | Module | Status | Finding? | Actioned? |\n'
  printf '|---|---|---|---|---|\n'
  while IFS="$(printf '\t')" read -r p m s f a; do
    [ -n "$p" ] || continue
    printf '| %s | %s | %s | %s | %s |\n' "$p" "$m" "$s" "$f" "$a"
  done < "$ROWS_SORTED"
}

render_manifest() {
  printf '# Field Harvest Unparseable Manifest\n\n'
  printf '> **Derived aid — not lifecycle truth.** Each row records evidence that could not be normalized without invention, per `docs/PALS-FIELD-HARVEST-NORMALIZATION-CONTRACT.md` §7. A large or lopsided manifest is a finding about the contract, not noise to suppress.\n\n'
  printf '| Deployment | Path | Reason | Detail |\n'
  printf '|---|---|---|---|\n'
  while IFS="$(printf '\t')" read -r d p r t; do
    [ -n "$d" ] || continue
    printf '| %s | %s | %s | %s |\n' "$d" "$p" "$r" "$t"
  done < "$MERGED_MANIFEST"
}

# The manifest is shared across deployments: preserve other deployments' rows,
# replace only this deployment's, and re-sort. Idempotent by construction.
MERGED_MANIFEST="$TMP_DIR/manifest.merged.tsv"
: > "$MERGED_MANIFEST"
if [ -f "$MANIFEST" ]; then
  sed -n 's/^| \(.*\) | \(.*\) | \(.*\) | \(.*\) |$/\1\t\2\t\3\t\4/p' "$MANIFEST" \
    | awk -F'\t' -v d="$DEPLOYMENT" '$1 != d && $1 != "Deployment"' >> "$MERGED_MANIFEST" || true
fi
cat "$MANIFEST_SORTED" >> "$MERGED_MANIFEST"
LC_ALL=C sort -t "$(printf '\t')" -k1,1 -k2,2 -k3,3 -k4,4 -u -o "$MERGED_MANIFEST" "$MERGED_MANIFEST"

if [ "$DRY_RUN" -eq 1 ]; then
  render_ledger
  printf '\n'
  render_manifest
else
  render_ledger   > "$LEDGER"
  render_manifest > "$MANIFEST"
fi

printf 'harvest: %s — %s rows, %s manifest entries\n' \
  "$DEPLOYMENT" "$(wc -l < "$ROWS_SORTED" | tr -d ' ')" "$(wc -l < "$MANIFEST_SORTED" | tr -d ' ')" >&2
