# v0.4+ Brainstorm

**Generated:** 2026-03-11
**Status:** Exploring — not yet a milestone

## Enhancement Ideas (Existing Pals)

1. **CARL gets smarter** — Domain auto-detection. CARL reads your codebase and *suggests* rules ("I see you're using Next.js — want me to enforce App Router patterns?"). Proactive instead of reactive.

2. **TODD goes visual** — Test coverage dashboard. TODD enforces TDD but has no visibility into *where* coverage is thin. A `/paul:coverage` that maps untested code paths.

3. **WALT learns from history** — Quality trend tracking. WALT gates individual PRs but doesn't track whether quality is improving or degrading over time. Add a quality ledger.

## New Pals

4. **DEAN** — **D**ependency **E**valuation & **A**udit **N**otifier. Watches deps for vulnerabilities, outdated packages, license issues. Runs during apply, blocks on critical CVEs.

5. **IRIS** — **I**ntelligent **R**eview & **I**nspection **S**ystem. Automated code review pal. Before unify, IRIS does a structured review: naming, patterns, security, performance.

6. **SKIP** — **S**mart **K**nowledge & **I**nformation **P**ersistence. Project memory pal. Tracks *why* decisions were made, links code to requirements, builds searchable knowledge base.

7. **DAVE** — **D**eploy **A**utomation & **V**erification **E**ngine. CI/CD pal. Generates GitHub Actions, validates pipelines, does post-deploy smoke tests.

8. **RUBY** — **R**efactor **U**tility & **B**etter-code **Y**ielder. Proactive refactoring suggestions. After milestones, scans for tech debt and suggests cleanup.

## Architectural Questions

### Modularity — "Pick Your Pals"
- How do users choose which pals to install?
- How do pals declare dependencies on each other?
- How does the lifecycle (plan/apply/unify) adapt when pals are missing?

### Stateless/Headless — "PALS without Claude Code"
- How does PALS work in OpenClaw, NanoClaw, Agent SDK?
- No slash commands, no hooks, no interactive prompts
- Need to separate brain (logic) from interface (slash commands)

### Multi-Project — "The Buddy System"
- Shared CARL rules across a portfolio
- Cross-project PAUL patterns

---
*Brainstorm session: 2026-03-11*
