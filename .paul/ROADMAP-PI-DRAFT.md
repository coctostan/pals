# Pi Roadmap Draft

**Generated:** 2026-03-15
**Purpose:** Proposed roadmap sequence for evolving the Pi port of PALS after the v2.2 audit milestone.

## Roadmap Intent

Strengthen the Pi port in a staged way:
1. finish the audit and recommendations work already in progress
2. refine the interaction model
3. improve Pi-native workflow UX
4. explore advanced Pi-specific runtime options carefully

This roadmap assumes:
- artifact compatibility remains non-negotiable
- shared workflow markdown remains authoritative
- Pi-specific improvements should live in the adapter layer unless a broader abstraction emerges later

---

## v2.2 Pi Port Audit & Native Fit
**Status:** In progress
**Theme:** Determine whether the current Pi port is the best artifact-compatible use of Pi’s skills, commands, and extension model.

### Phases
| Phase | Name | Purpose |
|-------|------|---------|
| 53 | Current-State Audit | Inventory the current Pi port and compare it to Pi docs/examples |
| 54 | Gap Analysis vs Ideal Pi Usage | Define the gap between current implementation and ideal artifact-compatible Pi usage |
| 55 | Recommendations & Roadmap | Produce ranked recommendations and a practical roadmap |

### Intended result
- evidence-backed audit
- current vs ideal gap analysis
- ranked improvements
- Pi roadmap for follow-on milestones

---

## v2.3 Pi Interaction Model Refinement
**Status:** Proposed
**Theme:** Make the Pi adapter more deterministic, discoverable, and idiomatic without changing shared artifact ownership.

### Why this milestone
The audit indicates the biggest current weakness is not correctness but interaction-model depth:
- context injection is too heuristic
- command ergonomics are basic
- adapter docs/comments have some drift

### Phases
| Phase | Name | Purpose |
|-------|------|---------|
| 56 | Hook & Context Strategy | Choose the best Pi-native trigger model for PALS activation and state injection |
| 57 | Command Routing & Discoverability | Improve `/paul-*` command UX while keeping skills canonical |
| 58 | Adapter Consistency Cleanup | Align docs, comments, and help surfaces with the actual adapter architecture |

### Intended result
- more deterministic activation model
- improved command ergonomics
- cleaner adapter documentation and help surface

---

## v2.4 Pi Native UX Layer
**Status:** Proposed
**Theme:** Make PALS feel more seamless and visible inside Pi while keeping artifacts authoritative.

### Why this milestone
Once the interaction model is cleaned up, Pi-native visibility and workflow ergonomics can be layered on more safely.

### Phases
| Phase | Name | Purpose |
|-------|------|---------|
| 59 | Lifecycle Visibility UI | Surface milestone, phase, loop state, and next action in lightweight Pi UI |
| 60 | Guided Workflow Surface | Improve next-action discovery, status/help flows, and possibly introduce a Pi-native hub surface |
| 61 | Session Navigation Aids | Explore labels, names, bookmarks, or other additive session-navigation helpers tied to lifecycle moments |

### Intended result
- better lifecycle visibility
- more seamless resume/status/help experience
- stronger Pi-native ergonomics without semantic divergence

---

## v2.5 Pi Advanced Runtime Options
**Status:** Proposed
**Theme:** Explore deeper Pi-specific enhancements carefully, with strong guardrails around artifact truth.

### Why this milestone
These improvements may be valuable, but they should come after the safer adapter and UX work is validated.

### Phases
| Phase | Name | Purpose |
|-------|------|---------|
| 62 | Installation Scope Options | Evaluate global vs project-local Pi installation strategies |
| 63 | Bounded Runtime State | Explore whether Pi runtime state can safely enhance UX without competing with `.paul/*` |
| 64 | Packaging & Distribution Polish | Improve package/distribution structure if Pi becomes a stronger first-class target |

### Intended result
- clearer install strategy
- bounded model for Pi runtime state
- more polished long-term Pi distribution path

---

## Recommended execution order
1. Complete **v2.2 Pi Port Audit & Native Fit**
2. Create and execute **v2.3 Pi Interaction Model Refinement**
3. Create and execute **v2.4 Pi Native UX Layer**
4. Create and execute **v2.5 Pi Advanced Runtime Options**

---

## Guidance

### Keep doing
- shared markdown as source of truth
- skills as canonical entry points
- extension code as additive adapter glue

### Avoid
- moving workflow logic into Pi TypeScript
- Pi-only forks of skills or workflow markdown
- extension runtime state replacing `.paul/STATE.md`
- maximizing Pi-native behavior at the cost of portability

---

## Suggested next milestone
**v2.3 Pi Interaction Model Refinement**

### Rationale
It is the highest-leverage next step because it improves:
- activation correctness
- context quality
- command usability
- adapter clarity

before taking on broader Pi-native UX or deeper runtime features.
