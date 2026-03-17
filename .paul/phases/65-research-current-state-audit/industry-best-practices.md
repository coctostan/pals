# Best Practices

## Purpose
This document captures collaborative planning, product discovery, and PRD practices relevant to PALS Phase 65. Each practice is evaluated not just for intrinsic quality, but for fit with PALS constraints:
- shared `.paul/*` artifacts remain authoritative
- backward compatibility is preserved
- workflow sprawl is controlled
- APPLY / UNIFY behavior remains unchanged
- cross-harness / agentic interoperability is maintained

---

## Evaluation Framework
For each candidate practice:
- **Source / precedent** — where it came from
- **Mechanic** — what the practice actually does
- **Problem solved** — why it helps
- **Fit for PALS** — adopt, adapt, or reject
- **Constraint notes** — what limits its use inside PALS

---

## 1. Exploratory vs direct-requirements triage
**Source / precedent:** `~/pi/workspace/pi-megapowers/prompts/brainstorm.md`

**Mechanic:** Early in the conversation, determine whether the user needs exploratory discovery or mostly direct requirement capture. If unclear, ask one short clarifying question.

**Problem solved:** Prevents over-questioning when the request is already concrete and prevents under-questioning when the problem is still fuzzy.

**Fit for PALS:** **Adopt**

**Constraint notes:**
- Should be added as an upstream planning behavior, not as a Pi-only feature
- Must work across project, milestone, and phase definition flows
- Should remain lightweight at low collaboration settings

**Why it matters for PALS:**
This creates the missing “how collaborative should this run be?” branch point without forcing one fixed amount of discussion.

---

## 2. Explicit requirement preservation buckets
**Source / precedent:** `~/pi/workspace/pi-megapowers/prompts/brainstorm.md`

**Mechanic:** Require that important user intent be preserved explicitly as must-haves, optional items, deferred items, constraints, and open questions.

**Problem solved:** Prevents silent loss of user intent during summarization and scoping.

**Fit for PALS:** **Adopt**

**Constraint notes:**
- Should align with existing PALS artifacts instead of creating a disconnected new truth source
- Could be introduced first in onboarding/discussion artifacts, then reflected into `PROJECT.md`

**Why it matters for PALS:**
This directly addresses the user complaint that PALS “tends to just make plans without much user input.” The problem is not only lack of questions; it is lack of durable, explicit preservation.

---

## 3. One-question-at-a-time interviewing
**Source / precedent:** Already present in PALS discuss/init flows; reinforced by `brainstorm.md`

**Mechanic:** Ask one focused question, wait for the answer, and synthesize rather than running a long intake form.

**Problem solved:** Keeps interaction manageable and conversational.

**Fit for PALS:** **Keep / strengthen**

**Constraint notes:**
- This is already a PALS strength
- The real improvement is to pair it with stronger structured capture

**Why it matters for PALS:**
The right move is not to abandon the current conversational style, but to make its outputs more faithful and structured.

---

## 4. Opportunity Solution Trees / design-tree-style exploration
**Source / precedent:** Teresa Torres / Product Talk opportunity solution trees

**Mechanic:** Start from a desired outcome, branch into opportunities (user needs), then multiple candidate solutions, then assumption tests.

**Problem solved:** Prevents teams from jumping from a business goal to a single solution too quickly. Externalizes reasoning and compares alternatives before delivery.

**Fit for PALS:** **Adapt**

**Constraint notes:**
- PALS does not need a full visual OST system or new graph product
- The useful adaptation is conceptual: outcome → opportunity/problem → candidate approaches → key assumptions/open questions
- Must remain markdown-friendly and harness-agnostic

**Why it matters for PALS:**
A simplified textual design tree could deepen high-collaboration planning without inventing a heavy new artifact class.

---

## 5. Outcome-first planning
**Source / precedent:** Product discovery guidance and OST framing

**Mechanic:** Define the desired outcome before discussing detailed implementation.

**Problem solved:** Keeps planning tied to user/business value rather than outputs alone.

**Fit for PALS:** **Adopt**

**Constraint notes:**
- Compatible with existing “goals first” and “features first” discuss workflows
- Should be made more explicit in onboarding and milestone/phase planning summaries

**Why it matters for PALS:**
This is already directionally aligned with PALS philosophy. The gap is consistency and explicitness.

---

## 6. Multiple-solution generation before committing
**Source / precedent:** Opportunity solution trees and discovery practice recommending 3+ solutions per opportunity

**Mechanic:** Force comparison of multiple approaches before locking onto one.

**Problem solved:** Reduces tunnel vision and premature convergence.

**Fit for PALS:** **Adapt**

**Constraint notes:**
- Useful mainly for high collaboration or ambiguous planning runs
- Would be overkill as a mandatory step for every trivial milestone or phase
- Can be introduced as “offer alternatives” rather than “always generate 3+ options”

**Why it matters for PALS:**
The user explicitly asked for high collaboration to “go over all of the details and offer different ideas.” This practice maps directly to that request.

---

## 7. Assumption mapping
**Source / precedent:** Product discovery / assumption mapping approaches

**Mechanic:** Make assumptions explicit and prioritize the risky/uncertain ones.

**Problem solved:** Surfaces hidden bets before they become implementation mistakes.

**Fit for PALS:** **Adapt**

**Constraint notes:**
- PALS does not need a full certainty-vs-importance matrix UI
- It does need explicit assumptions/open-question capture inside planning artifacts
- Best fit is in onboarding/PRD and high-collaboration planning modes

**Why it matters for PALS:**
This helps prevent plan-phase from turning ambiguous user intent into silent Claude assumptions.

---

## 8. PRD sections for assumptions, open questions, and out-of-scope items
**Source / precedent:** Atlassian PRD guidance and Confluence PRD template

**Mechanic:** Maintain a collaborative requirements document with assumptions, user stories, success metrics, things to decide/research, and explicit out-of-scope items.

**Problem solved:** Creates a shared understanding artifact that remains useful as the team learns more.

**Fit for PALS:** **Adopt / adapt**

**Constraint notes:**
- PALS already has much of this shape in `PROJECT.md`; the main need is workflow support to populate it better
- Should not force heavy PRD authoring for every low-collaboration planning run
- Best implemented as richer onboarding and discussion-generated artifacts that sync into `PROJECT.md`

**Why it matters for PALS:**
This is probably the highest-value PRD precedent because it aligns with shared understanding without requiring a separate proprietary tool.

---

## 9. Collaborative PRD authoring with developers/designers, not solo authoring
**Source / precedent:** Atlassian guidance that PRDs should not be written alone and should create shared understanding across product, design, and development

**Mechanic:** Treat the requirement doc as a collaborative landing page rather than a one-author spec.

**Problem solved:** Prevents requirements from being brittle, one-sided, or disconnected from implementation realities.

**Fit for PALS:** **Adapt**

**Constraint notes:**
- PALS often runs with a single user and the agent rather than a full trio
- The practical adaptation is to make PAUL behave like a more collaborative thought partner and expose assumptions/open questions clearly

**Why it matters for PALS:**
Even with one human user, this supports the desired feeling of collaboration rather than unilateral plan generation.

---

## 10. Explicit review checkpoints before committing to a full plan
**Source / precedent:** User request plus broader collaborative planning norms

**Mechanic:** Before surfacing a full plan, offer lighter review forms such as quick recap or detailed recap.

**Problem solved:** Lets users calibrate how much detail they want and keeps planning from feeling like a one-way jump into structure.

**Fit for PALS:** **Adopt**

**Constraint notes:**
- Must fit between discussion/synthesis and executable plan generation or display
- Should not change APPLY behavior
- Should work in plain text across harnesses

**Why it matters for PALS:**
This is the most direct behavioral change requested by the user and is low-risk because it adds a review layer without changing lifecycle authority.

---

## 11. Progressive disclosure / layered review
**Source / precedent:** Atlassian’s “landing page with links” mindset and PALS’s own progressive disclosure in Pi skill descriptions

**Mechanic:** Present concise summaries first, with deeper detail available on demand.

**Problem solved:** Avoids overwhelming users while still making depth available.

**Fit for PALS:** **Adopt**

**Constraint notes:**
- The new review menu is a natural implementation surface
- Works well with low/medium/high collaboration because it scales detail without multiplying artifacts

**Why it matters for PALS:**
This gives users control over how much planning detail they inspect before approving direction.

---

## 12. “Brainstorming is optional; requirements capture is not”
**Source / precedent:** `brainstorm.md`

**Mechanic:** Do not force open-ended ideation when the request is already concrete, but always preserve requirements explicitly.

**Problem solved:** Avoids both over-process and under-definition.

**Fit for PALS:** **Adopt**

**Constraint notes:**
- Best fit for a collaboration-level model
- Low collaboration should still preserve requirements explicitly even if it asks fewer questions

**Why it matters for PALS:**
This principle keeps the new milestone from drifting into heavy ceremony.

---

## 13. Continuous discovery cadence and experiments
**Source / precedent:** Product discovery guidance emphasizing ongoing interviews, experiments, and assumption testing

**Mechanic:** Run ongoing research and validate assumptions with small experiments before building.

**Problem solved:** Reduces value, usability, feasibility, and viability risk.

**Fit for PALS:** **Adapt selectively**

**Constraint notes:**
- Useful as thinking guidance in onboarding and ambiguous planning
- Too heavy if translated directly into mandatory PALS loops
- Better as an advisory pattern for high-collaboration discovery-oriented work

**Why it matters for PALS:**
The core insight is useful: not every planning decision should go straight to implementation; some should remain explicit questions or experiments.

---

## 14. Rich visual boards and tool-specific collaboration surfaces
**Source / precedent:** Confluence/Jira whiteboarding, visual planning tools, proprietary discovery suites

**Mechanic:** Use highly visual, tool-native collaboration surfaces for requirement shaping.

**Problem solved:** Can improve team alignment in specific ecosystems.

**Fit for PALS:** **Reject as a core dependency**

**Constraint notes:**
- Would undermine cross-harness portability if required
- Conflicts with markdown artifact authority if it becomes the primary truth source
- Can be linked externally, but should not be required for core lifecycle operation

**Why it matters for PALS:**
PALS should remain tool-agnostic and markdown-first even while borrowing the thinking patterns behind these tools.

---

## 15. Replace the artifact-first model with runtime-only collaboration state
**Source / precedent:** Some chat-first agent systems

**Mechanic:** Keep collaboration state mostly in prompt/runtime memory rather than durable documents.

**Problem solved:** Can feel fluid in one session.

**Fit for PALS:** **Reject**

**Constraint notes:**
- Violates PALS’s artifact authority and session continuity model
- Harms interoperability and recoverability
- Reintroduces hidden state problems PALS was designed to prevent

**Why it matters for PALS:**
The milestone should deepen collaboration **around artifacts**, not bypass them.

---

## Best-Fit Shortlist for PALS
The strongest candidates for adaptation are:
1. Exploratory vs direct-requirements triage
2. Explicit requirement preservation buckets
3. Outcome-first framing
4. Simplified opportunity/design tree thinking for high-collaboration runs
5. Assumption + open-question capture
6. Layered review before plan reveal
7. Collaborative PRD enrichment inside existing artifact structures

---

## Practical Conclusions
### What should be adopted directly
- requirement preservation buckets
- one-question-at-a-time interviewing
- recap/review before full plan reveal
- explicit out-of-scope and open-question tracking
- exploratory vs direct-requirements mode

### What should be adapted, not copied literally
- opportunity solution trees / design trees
- assumption mapping
- multiple-solution generation
- continuous discovery practices
- collaborative PRD methods from larger product organizations

### What should be rejected as core design
- mandatory visual tooling
- runtime-only collaboration state
- heavyweight discovery rituals for every simple plan

---

## Implications for PALS Phase 66 and 67
Phase 66 should operationalize:
- collaboration levels
- triage mode selection
- review menu and progressive disclosure
- when alternative ideas are offered

Phase 67 should operationalize:
- stronger onboarding and PRD generation
- explicit requirement/constraint/deferred/open-question capture
- synchronization of richer planning artifacts back into `PROJECT.md` and related shared markdown files
