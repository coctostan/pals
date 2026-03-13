# Milestone Context

**Generated:** 2026-03-13
**Status:** Ready for /paul:milestone

## Milestone 1: v0.9.2 Competitive Intelligence

### Features to Build

- Benchmark PALS against 8-10 agentic coding frameworks
- Gap analysis: what do competitors have that PALS lacks?
- Differentiator map: what does PALS have that others don't?
- Feature priority recommendations for v1.0
- Frameworks to analyze:
  - BMAD
  - OhMyOpencode
  - Superpowers
  - OpenSpec
  - SpecKit
  - Aider
  - Cline (formerly Claude Dev)
  - Continue.dev
  - SWE-agent
  - OpenHands (formerly OpenDevin)
  - MetaGPT
  - GPT Pilot
  - Cursor rules / .cursorrules
  - Mentat
  - Devin

### Scope

**Suggested name:** v0.9.2 Competitive Intelligence
**Estimated phases:** 1
**Focus:** Understand the landscape before committing to v1.0 scope

### Phase Mapping

| Phase | Focus | Features |
|-------|-------|----------|
| 34 | Competitive Research | Framework benchmarking, gap analysis, differentiator map, v1.0 recommendations |

### Constraints

- Research only — no code changes in this milestone
- Output is a report/analysis document, not implementation
- Should inform v1.0 phase planning

---

## Milestone 2: v1.0 Production Ready (draft — will be refined by v0.9.2 research)

### Features to Build

- Lightweight fix loop (`/paul:fix`) — compressed plan/apply/unify for bugfixes (1-3 files)
- Plan type expansion: `type: fix` and `type: hotfix` alongside existing execute/tdd/research
- Codebase onboarding (`/paul:map-codebase`) — scan and build project model for brownfield development
- Hotfix workflow — fix first, document after, retroactive unify
- Post-hoc reconciliation — "I fixed it, now let PAUL know"
- Link fixes back to phases that introduced regressions
- TBD features from competitive research findings

### Scope

**Suggested name:** v1.0 Production Ready
**Estimated phases:** 2-4 (will be refined after v0.9.2)
**Focus:** Make PALS work for real-world development beyond greenfield

### Phase Mapping (draft)

| Phase | Focus | Features |
|-------|-------|----------|
| 35 | Lightweight Fix Loop | /paul:fix command, type: fix plans, compressed loop |
| 36 | Brownfield & Hotfix | /paul:map-codebase, hotfix workflow, retroactive unify |
| 37+ | TBD | Informed by competitive research |

### Constraints

- Must not break existing greenfield workflow
- Fix loop must still track what happened (not bypass PAUL entirely)
- Hotfix must reconcile back into project state

---

## Additional Context

- User wants to separate research from implementation so findings can reshape v1.0
- PALS has been greenfield-only so far — brownfield/bugfix/hotfix are real gaps
- "Linux of Harness Engineering" vision means PALS should handle ALL development workflows, not just feature work

---

*This file is temporary. It will be deleted after /paul:milestone creates the milestone.*
