# Shared TAP/reporting helpers for PALS validation suites.
# Safe to source: defines functions only and preserves caller-owned counters.

: "${PASS:=0}"
: "${FAIL:=0}"
: "${TOTAL:=0}"

tap_ok() {
  TOTAL=$((TOTAL + 1))
  PASS=$((PASS + 1))
  echo "ok $TOTAL - $1"
}

tap_not_ok() {
  TOTAL=$((TOTAL + 1))
  FAIL=$((FAIL + 1))
  echo "not ok $TOTAL - $1"
  if [ -n "${2:-}" ]; then
    echo "  # $2"
  fi
}

tap_check() {
  if [ "$2" -eq 0 ]; then
    tap_ok "$1"
  else
    tap_not_ok "$1" "${3:-}"
  fi
}

tap_file_contains_all() {
  local description="$1"
  local file="$2"
  shift 2

  if [ ! -f "$file" ]; then
    tap_not_ok "$description" "File not found: $file"
    return
  fi

  local missing=()
  local pattern
  for pattern in "$@"; do
    if ! grep -Fq -- "$pattern" "$file" 2>/dev/null; then
      missing+=("$pattern")
    fi
  done

  if [ "${#missing[@]}" -eq 0 ]; then
    tap_ok "$description"
  else
    tap_not_ok "$description" "Missing marker(s): ${missing[*]}"
  fi
}

tap_file_contains_none() {
  local description="$1"
  local file="$2"
  shift 2

  if [ ! -f "$file" ]; then
    tap_not_ok "$description" "File not found: $file"
    return
  fi

  local present=()
  local pattern
  for pattern in "$@"; do
    if grep -Fq -- "$pattern" "$file" 2>/dev/null; then
      present+=("$pattern")
    fi
  done

  if [ "${#present[@]}" -eq 0 ]; then
    tap_ok "$description"
  else
    tap_not_ok "$description" "Unexpected marker(s): ${present[*]}"
  fi
}

tap_hot_workflow_line_ceiling() {
  local description="$1"
  local ceiling="$2"
  shift 2

  local total=0
  local file
  for file in "$@"; do
    if [ ! -f "$file" ]; then
      tap_not_ok "$description" "File not found: $file"
      return
    fi

    local count
    count=$(wc -l < "$file" | tr -d ' ')
    total=$((total + count))
  done

  if [ "$total" -le "$ceiling" ]; then
    tap_ok "$description"
  else
    tap_not_ok "$description" "Hot workflow total $total exceeds ceiling $ceiling"
  fi
}

tap_file_line_ceiling() {
  local description="$1"
  local file="$2"
  local ceiling="$3"

  if [ ! -f "$file" ]; then
    tap_not_ok "$description" "File not found: $file"
    return
  fi

  local count
  count=$(wc -l < "$file" | tr -d ' ')
  if [ "$count" -le "$ceiling" ]; then
    tap_ok "$description"
  else
    tap_not_ok "$description" "$file has $count lines; ceiling is $ceiling"
  fi
}

tap_pattern_count_at_most() {
  local description="$1"
  local pattern="$2"
  local ceiling="$3"
  shift 3

  local count=0
  local file
  for file in "$@"; do
    if [ ! -e "$file" ]; then
      tap_not_ok "$description" "Path not found: $file"
      return
    fi
  done

  count=$(grep -R "$pattern" "$@" 2>/dev/null | wc -l | tr -d ' ')
  if [ "$count" -le "$ceiling" ]; then
    tap_ok "$description"
  else
    tap_not_ok "$description" "Pattern count $count exceeds ceiling $ceiling for $pattern"
  fi
}

section() {
  echo ""
  echo "# ════════════════════════════════════════"
  echo "# $1"
  echo "# ════════════════════════════════════════"
}
