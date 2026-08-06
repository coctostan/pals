# ─────────────────────────────────────────────────────────────────────────────
# Parse one phase SUMMARY into normalized ledger rows and manifest entries.
#
# Implements docs/PALS-FIELD-HARVEST-NORMALIZATION-CONTRACT.md. The contract is
# authoritative; where this parser disagrees with it, this parser is wrong.
#
# Inputs (-v):  phase_cell, deployment, relpath, registry, rows_out, manifest_out
# Outputs:      TSV appended to rows_out and manifest_out
# ─────────────────────────────────────────────────────────────────────────────

function trim(s) {
  gsub(/^[[:space:]]+|[[:space:]]+$/, "", s)
  return s
}

function clean_token(s) {
  gsub(/[`*]/, "", s)
  sub(/[[:space:]]*\([^()]*\)[[:space:]]*$/, "", s)
  # Outcome cells carry explanatory prose after an em/en dash or spaced hyphen.
  # Keep only the leading token (contract §4 "Outcome cell suffix").
  sub(/[[:space:]]+(—|–|-)[[:space:]].*$/, "", s)
  sub(/[[:space:]]*\([^()]*\)[[:space:]]*$/, "", s)
  return trim(s)
}

# Count-based outcomes: `0 drift`, `2 debt items flagged`, `1 decision captured`
# (contract §4 "Count-based outcomes"). Returns "" when not a count form.
function map_count(tok,   t, n, noun) {
  t = tolower(clean_token(tok))
  if (t !~ /^[0-9]+[[:space:]]+[a-z]/) return ""
  n = t; sub(/[[:space:]].*$/, "", n)
  noun = t; sub(/^[0-9]+[[:space:]]+/, "", noun); sub(/[[:space:]].*$/, "", noun)

  if (noun ~ /^decisions?$/) return "NOTE"
  if (noun !~ /^(concerns?|drift|debt|flags?|issues?)$/) return ""
  return (n + 0 == 0) ? "PASS" : "PASS_WITH_CONCERNS"
}

# ── Status mapping (contract §4) ─────────────────────────────────────────────
function map_single(tok,   t) {
  t = tolower(clean_token(tok))
  if (t in SMAP) return SMAP[t]
  return ""
}

function map_status(tok,   t, n, parts, i, best, cur) {
  t = tolower(clean_token(tok))
  if (t in SMAP) return SMAP[t]

  # Combined alternates resolve to the weaker claim so harvest never
  # overstates efficacy (contract §4).
  if (t ~ /\//) {
    n = split(t, parts, "/")
    best = ""
    for (i = 1; i <= n; i++) {
      cur = map_single(parts[i])
      if (cur == "") return ""
      if (best == "" || RANK[cur] < RANK[best]) best = cur
    }
    return best
  }

  cur = map_count(tok)
  if (cur != "") return cur

  return ""
}

function derive_finding(status) {
  return (status == "PASS_WITH_CONCERNS" || status == "WARN" || status == "BLOCK") ? "yes" : "no"
}

function derive_actioned(finding) {
  # Retroactive harvest never infers `yes` (contract §6).
  return (finding == "yes") ? "no" : "n/a"
}

function emit_row(mod, status, finding, actioned) {
  printf "%s\t%s\t%s\t%s\t%s\n", phase_cell, toupper(mod), status, finding, actioned >> rows_out
}

function emit_manifest(reason, detail) {
  printf "%s\t%s\t%s\t%s\n", deployment, relpath, reason, detail >> manifest_out
}

function emit_mapped(mod, status_tok,   st, f) {
  st = map_status(status_tok)
  if (st == "") {
    emit_manifest("unmapped-status", clean_token(status_tok))
    return
  }
  f = derive_finding(st)
  emit_row(mod, st, f, derive_actioned(f))
}

# ── Table helpers ────────────────────────────────────────────────────────────
function split_cells(line, arr,   t) {
  t = line
  sub(/^[[:space:]]*\|/, "", t)
  sub(/\|[[:space:]]*$/, "", t)
  return split(t, arr, "|")
}

function is_separator(arr, n,   i) {
  for (i = 1; i <= n; i++)
    if (trim(arr[i]) !~ /^:?-+:?$/) return 0
  return 1
}

# Returns the status column index for a dispatch-table header, or 0 if this is
# not a dispatch table. A `Module` column alone is NOT sufficient: module design
# grade tables and dependency upgrade tables also have one (contract §3
# "Dispatch table qualification"). Preference order avoids Hook, which is a
# qualifier rather than an outcome.
function dispatch_status_col(line,   c, n, j, h, best, rank) {
  if (line !~ /^[[:space:]]*\|/) return 0
  n = split_cells(line, c)
  if (tolower(trim(c[1])) != "module") return 0

  best = 0; rank = 99
  for (j = 2; j <= n; j++) {
    h = tolower(trim(c[j]))
    if (h == "status"   && rank > 1) { best = j; rank = 1 }
    if (h == "result"   && rank > 2) { best = j; rank = 2 }
    if (h == "outcome"  && rank > 3) { best = j; rank = 3 }
    if (h == "report"   && rank > 4) { best = j; rank = 4 }
    if (h == "evidence" && rank > 5) { best = j; rank = 5 }
  }
  return best
}

# ── Prose status search, longest token first ─────────────────────────────────
function find_status_in_text(text,   i, t, re) {
  t = tolower(text)
  for (i = 1; i <= TOKN; i++) {
    re = "(^|[^a-z0-9_/-])" TOKS[i] "([^a-z0-9_/-]|$)"
    if (t ~ re) return SMAP[TOKS[i]]
  }
  return ""
}

BEGIN {
  n = split(registry, r, " ")
  for (i = 1; i <= n; i++) REG[r[i]] = 1

  SMAP["pass"]                     = "PASS"
  SMAP["pass_with_concerns"]       = "PASS_WITH_CONCERNS"
  SMAP["pass_with_baseline"]       = "PASS_WITH_CONCERNS"
  SMAP["pass_with_known_baseline"] = "PASS_WITH_CONCERNS"
  SMAP["pass_with_retry"]          = "PASS_WITH_CONCERNS"
  SMAP["pass-no-block"]            = "PASS_WITH_CONCERNS"
  SMAP["warn"]                     = "WARN"
  SMAP["warning only"]             = "WARN"
  SMAP["block"]                    = "BLOCK"
  SMAP["skip"]                     = "SKIP"
  SMAP["skipped-no-symbols"]       = "SKIP"
  SMAP["not_applicable"]           = "SKIP"
  SMAP["n/a"]                      = "SKIP"
  SMAP["note"]                     = "NOTE"
  SMAP["captured in summary"]      = "NOTE"

  RANK["SKIP"] = 1; RANK["NOTE"] = 2; RANK["PASS"] = 3
  RANK["PASS_WITH_CONCERNS"] = 4; RANK["WARN"] = 5; RANK["BLOCK"] = 6

  # Longest first so PASS_WITH_BASELINE never degrades to PASS.
  TOKN = 0
  TOKS[++TOKN] = "pass_with_known_baseline"
  TOKS[++TOKN] = "pass_with_concerns"
  TOKS[++TOKN] = "pass_with_baseline"
  TOKS[++TOKN] = "skipped-no-symbols"
  TOKS[++TOKN] = "captured in summary"
  TOKS[++TOKN] = "pass_with_retry"
  TOKS[++TOKN] = "not_applicable"
  TOKS[++TOKN] = "pass-no-block"
  TOKS[++TOKN] = "warning only"
  TOKS[++TOKN] = "block"
  TOKS[++TOKN] = "pass"
  TOKS[++TOKN] = "skip"
  TOKS[++TOKN] = "note"
  TOKS[++TOKN] = "warn"
  TOKS[++TOKN] = "n/a"
}

{ L[NR] = $0 }

END {
  has_e = 0; has_table = 0; has_dispatch = 0
  for (i = 1; i <= NR; i++) {
    if (L[i] ~ /Status:[^|]*\|[[:space:]]*Finding\?:/) has_e = 1
    if (dispatch_status_col(L[i]) > 0)                  has_table = 1
    if (L[i] ~ /\[dispatch\]/)                          has_dispatch = 1
  }

  # Precedence: E > A/B/D > C (contract §3).
  if (has_e)          { parse_e();        exit }
  if (has_table)      { parse_tables();   exit }
  if (has_dispatch)   { parse_dispatch(); exit }

  emit_manifest("no-dispatch-evidence", "no module table or [dispatch] line")
}

# ── Dialect E ────────────────────────────────────────────────────────────────
function parse_e(   i, line, cur, s, f, a, st) {
  cur = ""
  for (i = 1; i <= NR; i++) {
    line = L[i]
    if (line ~ /^###[[:space:]]+/) {
      cur = line
      sub(/^###[[:space:]]+/, "", cur)
      cur = tolower(trim(cur))
      continue
    }
    if (line !~ /Status:[^|]*\|[[:space:]]*Finding\?:/) continue
    if (cur == "") continue

    if (!(cur in REG)) { emit_manifest("unknown-module", cur); continue }

    s = ""; f = ""; a = ""
    if (match(line, /Status:[[:space:]]*[A-Za-z_-]+/)) {
      s = substr(line, RSTART, RLENGTH); sub(/Status:[[:space:]]*/, "", s)
    }
    if (match(line, /Finding\?:[[:space:]]*(yes|no)/)) {
      f = substr(line, RSTART, RLENGTH); sub(/Finding\?:[[:space:]]*/, "", f)
    }
    if (match(line, /Actioned\?:[[:space:]]*(n\/a|yes|no)/)) {
      a = substr(line, RSTART, RLENGTH); sub(/Actioned\?:[[:space:]]*/, "", a)
    }

    st = map_status(s)
    if (st == "") { emit_manifest("unmapped-status", clean_token(s)); continue }

    # Explicit in-source tokens win (contract §5, §6).
    if (f == "") f = derive_finding(st)
    if (a == "") a = derive_actioned(f)
    emit_row(cur, st, f, a)
  }
}

# ── Dialects A / B / D ───────────────────────────────────────────────────────
function parse_tables(   i, line, c, n, first, in_table, status_col,
                         modcell, mm, lm, k, parts, q, p, w, fw, ambiguous) {
  in_table = 0; status_col = 0
  for (i = 1; i <= NR; i++) {
    line = L[i]
    if (line !~ /^[[:space:]]*\|/) { in_table = 0; continue }

    n = split_cells(line, c)
    if (is_separator(c, n)) continue

    first = tolower(trim(c[1]))
    if (first == "module") {
      # A non-dispatch module table (grades, upgrades) closes any open table
      # and contributes nothing.
      status_col = dispatch_status_col(line)
      in_table = (status_col > 0)
      continue
    }
    if (!in_table) continue
    if (status_col > n) continue

    modcell = trim(c[1])
    mm = modcell
    sub(/[[:space:]]*\([^()]*\)[[:space:]]*$/, "", mm)
    mm = trim(mm)

    if (mm ~ /\//) {
      # Combined module set (contract §3 dialect B).
      k = split(mm, parts, "/")
      ambiguous = 0
      for (q = 1; q <= k; q++) {
        p = trim(parts[q])
        split(p, w, /[[:space:]]+/)
        fw = tolower(w[1])
        if (fw in REG) {
          emit_mapped(fw, c[status_col])
          if (p ~ /[[:space:]]/) ambiguous = 1
        } else {
          ambiguous = 1
        }
      }
      if (ambiguous) emit_manifest("ambiguous-module-set", modcell)
      continue
    }

    # The leading word identifies the module; trailing hook/qualifier words
    # are discarded (contract §3 "Module cell normalization").
    split(mm, w, /[[:space:]]+/)
    lm = tolower(w[1])
    if (!(lm in REG)) { emit_manifest("unknown-module", mm); continue }
    emit_mapped(lm, c[status_col])
  }
}

# ── Dialect C ────────────────────────────────────────────────────────────────
function parse_dispatch(   i, line, seg, mod, rest, st, tok, m) {
  for (i = 1; i <= NR; i++) {
    line = L[i]
    if (line !~ /\[dispatch\]/) continue

    if (match(line, /\[dispatch\][[:space:]]+[A-Z]+[[:space:]]/)) {
      seg = substr(line, RSTART, RLENGTH)
      sub(/\[dispatch\][[:space:]]+/, "", seg)
      seg = trim(seg)
      mod = tolower(seg)
      rest = substr(line, RSTART + RLENGTH)
      if (!(mod in REG)) { emit_manifest("unknown-module", seg); continue }
      SEEN[mod] = 1
      st = find_status_in_text(rest)
      if (st != "") OUT[mod] = st
      continue
    }

    if (line ~ /executing/) {
      rest = line
      while (match(rest, /[A-Z][A-Z]+/)) {
        tok = tolower(substr(rest, RSTART, RLENGTH))
        if (tok in REG) ROSTER[tok] = 1
        rest = substr(rest, RSTART + RLENGTH)
      }
    }
  }

  for (m in ROSTER) SEEN[m] = 1
  for (m in SEEN) {
    # Invocation is evidenced but outcome is not: NOTE, not a guessed pass.
    st = (m in OUT) ? OUT[m] : "NOTE"
    emit_row(m, st, derive_finding(st), derive_actioned(derive_finding(st)))
  }
}
