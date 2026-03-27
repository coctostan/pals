# Upstream CARL Inventory

**Repo:** https://github.com/ChristopherKahler/carl
**Version:** v2.0.1
**Last commit:** d9bca7c — 2026-03-23 — `chore: bump to 2.0.1`
**Total files:** 20
**Our PALS equivalent:** `modules/carl/` module + `drivers/pi/extensions/pals-hooks.ts` (CARL session boundary manager)

---

## Status Key

| Status | Meaning |
|--------|---------|
| **equivalent** | Same concept, similar content — both repos have it |
| **diverged** | Same concept, significantly different implementation |
| **novel** | No PALS counterpart — upstream only |
| **superseded** | PALS has a more advanced version |

---

## Fundamental Architecture Difference

Upstream CARL and our CARL serve **completely different purposes**:

| Aspect | Upstream CARL | Our CARL (PALS) |
|--------|--------------|-----------------|
| **Role** | Context Augmentation & Reinforcement Layer — dynamic rule injection based on what you're doing | Session Boundary Manager — autonomous session transitions based on context usage |
| **Mechanism** | Claude Code hook (`carl-hook.py`) + MCP server for runtime management | Pi extension event handler in `pals-hooks.ts` |
| **Core concept** | Domains with rules, keywords, and decisions — rules load/unload based on prompt matching | Phase-completion detection, configurable decision model, session creation + auto-resume |
| **Config** | `.carl/carl.json` — domains, rules, context brackets, commands | `pals.json` modules.carl — thresholds, continue_threshold, safety_ceiling |
| **Runtime** | Python hook + Node.js MCP server | TypeScript Pi extension |
| **Scope** | General-purpose (any Claude Code project) | PALS-specific (session management within PALS lifecycle) |

Our CARL evolved from the upstream concept but diverged into a specialized session boundary manager. The upstream CARL is a general-purpose rule injection system.

---

## Root Files (6 files)

| Path | Purpose | PALS Equivalent | Status | Notes |
|------|---------|-----------------|--------|-------|
| `README.md` | NPM-publishable README. Covers install via `npx carl-core`, domains, MCP tools, v1→v2 migration. | `modules/carl/README.md` (minimal) | diverged | Upstream has comprehensive docs for a standalone product. Ours is a module description within PALS. |
| `package.json` | NPM package for `carl-core` | None | diverged | Upstream is NPM-published; our CARL is not standalone |
| `LICENSE` | MIT | Same license in our repo | equivalent | Same |
| `.gitignore` | Standard | Same | equivalent | Same |
| `INSTALL.md` | Detailed installation guide (global/local, non-interactive, flags) | None standalone | diverged | Upstream has comprehensive install docs. Our CARL installs as part of PALS. |
| `CARL-BLOCK.md` | Instructions for adding CARL integration block to CLAUDE.md | None | **NOVEL** | Tells Claude to follow `<carl-rules>` blocks from system-reminders. This is the mechanism that makes Claude obey injected rules. We don't need this — our Pi extension injects context differently. |

## Documentation Files (1 file)

| Path | Purpose | PALS Equivalent | Status | Notes |
|------|---------|-----------------|--------|-------|
| `AUDIT-CLAUDEMD.md` | Guide for auditing CLAUDE.md content and migrating applicable rules to CARL domains | None | **NOVEL** | Helps users identify static CLAUDE.md content that could become dynamic CARL domains. Interesting concept: reduce context bloat by making rules conditional. Not directly applicable to our Pi-based approach but the audit methodology is useful. |

## Assets (1 file)

| Path | Purpose | PALS Equivalent | Status | Notes |
|------|---------|-----------------|--------|-------|
| `assets/terminal.svg` | Terminal screenshot for README | None | novel | Visual asset |

## Bin (2 files)

| Path | Purpose | PALS Equivalent | Status | Notes |
|------|---------|-----------------|--------|-------|
| `bin/install.js` | NPM installer — prompts for location, copies hook, creates .carl/carl.json, installs MCP server, wires settings.json | `drivers/pi/install.sh` | diverged | JS-based cross-platform installer. Handles both global and local install. |
| `bin/migrate-v1-to-v2.sh` | Migration script from v1 (manifest + domain files) to v2 (single carl.json) | None | **NOVEL** | Versioned migration tooling. We've never needed this for CARL but the pattern is useful — when changing config schemas, provide automated migration. |

## Hooks (1 file)

| Path | Purpose | PALS Equivalent | Status | Notes |
|------|---------|-----------------|--------|-------|
| `hooks/carl-hook.py` | Claude Code hook — Python script that injects context-aware rules into prompts | `drivers/pi/extensions/pals-hooks.ts` (partial) | diverged | **Core upstream mechanism.** Reads `.carl/carl.json`, matches prompt keywords against domain recall patterns, injects relevant rules as `<carl-rules>` blocks. Features: context brackets (FRESH/MODERATE/DEPLETED), context dedup, star commands, session tracking. Our Pi extension does lifecycle injection but not keyword-based rule matching. |

### carl-hook.py Key Features (for Phase 146 analysis):
- **Domain keyword matching** — domains have `recall` keywords; hook matches against prompt
- **Context brackets** — FRESH (>70%), MODERATE (40-70%), DEPLETED (<20%) with bracket-specific rules
- **Context dedup** — tracks what was recently injected, skips re-injection
- **Force emit every N** — re-injects rules periodically even if deduped
- **Session tracking** — creates session files in `.carl/sessions/`
- **Star commands** — custom `*command` definitions in config
- **Always-on domains** — GLOBAL domain always injects

## MCP Server (6 files)

| Path | Purpose | PALS Equivalent | Status | Notes |
|------|---------|-----------------|--------|-------|
| `mcp/index.js` | MCP server entry point — consolidates 4 tool groups | None | **NOVEL** | Full MCP server for runtime CARL management. Claude can add/modify/remove domains, log decisions, manage staging pipeline at runtime. We have no MCP integration. |
| `mcp/package.json` | MCP server package config | None | **NOVEL** | Node.js MCP server dependencies |
| `mcp/tools/domains.js` | Domain CRUD — add/remove/update domains, rules, keywords | None | **NOVEL** | Runtime domain management via MCP. Claude can create new CARL domains during a session. |
| `mcp/tools/decisions.js` | Decision logging — per-domain decision tracking in `.carl/decisions/*.json` | `.paul/STATE.md` decisions table | diverged | Upstream persists decisions per-domain in JSON files. We track decisions in STATE.md as a flat table. Their approach is more structured/queryable. |
| `mcp/tools/carl-json.js` | carl.json CRUD — full v2 management (domains, rules, staging, config) | None | **NOVEL** | Comprehensive carl.json manipulation via MCP. Consolidates all v2 operations. |
| `mcp/tools/staging.js` | Rule proposal staging pipeline — stage, review, approve/kill rule proposals | None | **NOVEL** | Rule governance: proposed rules go through staging before becoming active. Interesting quality gate for rule management. |

## Schemas (1 file)

| Path | Purpose | PALS Equivalent | Status | Notes |
|------|---------|-----------------|--------|-------|
| `schemas/carl.schema.json` | JSON Schema for carl.json — formal validation | `kernel/references/pals-json-schema.md` (informal) | **NOVEL** | Formal JSON Schema validation for carl.json. We have a reference doc describing pals.json structure but not a machine-readable schema. The pattern of formal schema validation is worth considering. |

## Template (2 files)

| Path | Purpose | PALS Equivalent | Status | Notes |
|------|---------|-----------------|--------|-------|
| `.carl-template/carl.json` | Default carl.json with GLOBAL domain, context brackets, starter rules | `modules/carl/` config | diverged | Upstream's default config includes: GLOBAL always-on rules, context bracket rules (MODERATE/DEPLETED behavior adaptation), empty custom commands. Our CARL config is thresholds-only in pals.json. |
| `.carl-template/sessions/.gitkeep` | Session tracking directory | None | novel | Upstream tracks sessions as files in `.carl/sessions/` |

---

## Summary Statistics

| Category | Total | Equivalent | Diverged | Novel | Superseded |
|----------|-------|------------|----------|-------|------------|
| Root files | 6 | 2 | 3 | 1 | 0 |
| Documentation | 1 | 0 | 0 | 1 | 0 |
| Assets | 1 | 0 | 0 | 1 | 0 |
| Bin | 2 | 0 | 1 | 1 | 0 |
| Hooks | 1 | 0 | 1 | 0 | 0 |
| MCP Server | 6 | 0 | 1 | 5 | 0 |
| Schemas | 1 | 0 | 0 | 1 | 0 |
| Template | 2 | 0 | 1 | 1 | 0 |
| **Total** | **20** | **2** | **7** | **11** | **0** |

## Items Flagged for Phase 146 Review

### NOVEL — No PALS equivalent

1. **MCP Server (entire `mcp/` directory)** — Runtime domain/rule/decision management via MCP tools. Claude can create domains, add rules, log decisions, manage staging pipeline during a session. Entirely novel capability.
2. **Rule Staging Pipeline** (`mcp/tools/staging.js`) — Proposed rules go through staging → review → approve/kill before becoming active. Quality gate for rule governance.
3. **Formal JSON Schema** (`schemas/carl.schema.json`) — Machine-readable validation for carl.json. We have informal schema docs but not formal validation.
4. **Migration Tooling** (`bin/migrate-v1-to-v2.sh`) — Automated config migration between versions. Pattern worth learning from.
5. **CLAUDE.md Audit Guide** (`AUDIT-CLAUDEMD.md`) — Methodology for identifying static content that should become dynamic rules.
6. **CARL Block** (`CARL-BLOCK.md`) — Mechanism for making Claude obey injected rules via CLAUDE.md integration.

### DIVERGED — Fundamentally different approaches

7. **Domain-based rule injection** (carl-hook.py) — Upstream CARL is a general-purpose contextual rule system. Domains have keywords; rules load/unload based on what the user is discussing. Our CARL is narrowly scoped to session boundary management.
8. **Context brackets** — Upstream CARL adapts Claude's behavior based on context usage (FRESH/MODERATE/DEPLETED). Our CARL only does session boundary detection at thresholds.
9. **Decision tracking** — Upstream tracks decisions per-domain in structured JSON files via MCP. We track decisions as flat text in STATE.md.
10. **Star commands** — Upstream CARL supports custom `*command` definitions in carl.json. We have `/paul:*` commands but not configurable custom commands.

### Key Question for Phase 146

**Should PALS adopt any of upstream CARL's general-purpose rule injection?**
- Our CARL intentionally narrowed to session management (Phase 77-78 design decision)
- Upstream's domain/rule/keyword matching is a different product
- The two CARLs have diverged so far that "adoption" would mean building new capability, not updating existing
- MCP integration is interesting but adds runtime dependency
