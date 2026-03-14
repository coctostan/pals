# Scan Codebase Task

## Input
- Project directory (defaults to current working directory)

## Workflow

### Phase 1: Detect Technologies

1. **Load rule catalog** from `kernel/modules/carl/config/rule-catalog.yaml`
2. **Scan project directory** for each technology's detection signatures:
   - For `file` signatures: use Glob to check if matching files exist in project root
   - For `package_json` signatures: read `package.json` and check if the package is in `dependencies` or `devDependencies`
3. **Build detected technologies list** — record which signature matched for each

### Phase 2: Check Existing Domains

For each detected technology:

1. **Check `.carl/` directory** for existing domain file matching the catalog's `domain` value
2. **If domain exists:**
   - Read domain file rules
   - Compare against catalog rules
   - Identify rules NOT already present as "new suggestions"
   - If all catalog rules already present, mark as "fully covered"
3. **If domain doesn't exist:**
   - Mark as "new domain" with all catalog rules as suggestions

### Phase 3: Present Results

Display results in this format:

```
════════════════════════════════════════
CARL CODEBASE SCAN
════════════════════════════════════════

Detected Technologies:
  ✓ {tech.name} ({matched_signature} found)
  ✓ {tech.name} ({matched_signature} found)
  ✗ No additional technologies detected

────────────────────────────────────────
```

Then for each technology with suggestions:

**New domains:**
```
NEW DOMAIN: {domain} ({rule_count} rules)
  1. {rule_text}
  2. {rule_text}
  ...
```

**Existing domains with new rules:**
```
EXISTING DOMAIN: {domain} ({new_count} new rules)
  + {new_rule_text}
  + {new_rule_text}
```

**Fully covered domains:**
```
  ✓ {domain} — all catalog rules already present
```

Then the action prompt:
```
────────────────────────────────────────
[A] Accept all  [S] Select individually  [N] Skip
```

If no technologies detected:
```
No technologies detected in this project.
Tip: Make sure you're in the project root directory.
```

### Phase 4: Handle User Choice

**[A] Accept all:**
1. For each new domain: delegate to `./tasks/create-domain.md` workflow
   - Domain name from catalog `domain` field
   - Recall keywords from catalog `recall` field
   - All catalog rules as initial rules
2. For each existing domain with new rules: delegate to `./tasks/add-rule.md` workflow
   - Add each new rule to the existing domain
3. Report summary of what was created

**[S] Select individually:**
1. Walk through each domain group one at a time:
   ```
   {tech.name} → domain: {domain} ({rule_count} rules)
   Accept this domain? [Y/n]
   ```
2. If accepted: create/add using delegation (same as Accept all)
3. If rejected: skip and move to next
4. For existing domains, offer per-rule selection:
   ```
   Add rule: "{rule_text}"? [Y/n]
   ```

**[N] Skip:**
1. Display: "Scan complete. No changes made."
2. Exit

### Phase 5: Report Results

After creating domains/rules:

```
════════════════════════════════════════
SCAN COMPLETE
════════════════════════════════════════

Created:
  + Domain: {domain} ({rule_count} rules)
  + Domain: {domain} ({rule_count} rules)

Updated:
  ~ Domain: {domain} (+{new_count} rules)

Skipped:
  - {domain} (user declined)

Total: {created} domains created, {updated} updated, {rules} rules added
════════════════════════════════════════
```

## Detection Logic

### File Detection
Use the Glob tool to check for matching files:
- `next.config.*` → matches next.config.js, next.config.mjs, next.config.ts
- `tsconfig.json` → exact match
- `go.mod` → exact match
- `Dockerfile` → exact match
- `prisma/schema.prisma` → nested path match
- `docker-compose.yml` / `docker-compose.yaml` / `compose.yml` / `compose.yaml` → any match

### Package.json Detection
Read `package.json` if it exists. For each `package_json` signature:
- Check `dependencies[package]` exists
- Check `devDependencies[package]` exists
- Either match counts as detected

### Deduplication
Some technologies overlap (e.g., Next.js projects also have React).
- Show all detected technologies
- If Next.js detected, still show React (different domains, different rules)
- Node.js detection (package.json exists) is the broadest — still suggest Node.js domain even if framework-specific domains also detected

## Delegation

This task does NOT implement file creation directly. It delegates to:

- **Create domain:** `./tasks/create-domain.md` — handles domain file creation and manifest entry
- **Add rule:** `./tasks/add-rule.md` — handles appending rules to existing domains

This ensures CARL CRUD operations stay in one place and scan-codebase only handles detection and presentation.

## Error Cases

**No .carl/ directory:**
```
No .carl/ directory found in this project.
Initialize CARL first with: /carl:manager *create GLOBAL
Or install PALS which sets up .carl/ automatically.
```

**Rule catalog not found:**
```
Error: Rule catalog not found at kernel/modules/carl/config/rule-catalog.yaml
This file is part of the CARL module — reinstall PALS to restore it.
```

**package.json parse error:**
```
Warning: Could not parse package.json — skipping package-based detection.
File-based detection will still run.
```
