<overview>
DEAN — Dependency Evaluation & Audit Notifier. Provides visibility into dependency health: vulnerabilities, outdated packages, and ecosystem detection.

**Philosophy:** Visibility first, enforcement later. DEAN starts as a read-only analysis tool (like WALT's early quality tracking). Future versions may add lifecycle hooks to block on critical CVEs during apply.

**Core principle:** Detect → Audit → Present → Suggest. Never auto-fix dependencies — only surface issues and suggest commands the developer can run.
</overview>

<approach>

## Detect → Audit → Present → Suggest

### 1. Detect
Identify which package managers and ecosystems are present in the project. Multiple ecosystems in one project (e.g., Node.js frontend + Python backend) are common and supported.

### 2. Audit
Run ecosystem-native audit tools to check for known vulnerabilities. Run outdated-package checks to surface staleness. Use JSON output where available for reliable parsing.

### 3. Present
Display a clear dashboard with severity-classified vulnerabilities and outdated package counts. Focus on actionable information — don't dump raw audit output.

### 4. Suggest
Provide specific commands the developer can run to fix issues. Never run fix commands automatically — dependency updates can introduce breaking changes that require human judgment.

</approach>

<evolution>

## Future Evolution (v0.7+)

DEAN follows WALT's growth pattern:

| Version | Capability |
|---------|-----------|
| v0.6 | Read-only visibility via /paul:deps (current) |
| v0.7 | post-apply hook: warn on new vulnerabilities introduced by a plan |
| v0.8+ | pre-apply hook: block on critical CVEs in existing deps before changes |
| Future | License audit, supply chain verification, SBOM generation |

**Hook integration pattern (future):**
- `post-apply`: Compare dependency state before/after plan execution. Flag if new vulnerabilities were introduced.
- `pre-apply`: Check existing dependency health before starting work. Block if critical CVEs exist (configurable threshold).

</evolution>

<constraints>

## Constraints

- Never auto-fix or auto-update dependencies
- Never modify lock files or package manifests
- Audit tools require network access — handle offline gracefully
- Some audit tools require separate installation (pip-audit, cargo-audit, govulncheck)
- Private registries may require authentication — note but don't block on auth errors
- Monorepos may have multiple ecosystems — report all, don't pick one

</constraints>
