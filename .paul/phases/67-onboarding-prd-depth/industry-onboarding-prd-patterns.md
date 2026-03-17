# Best Practices: Onboarding, Product Briefs, PRDs, and Layered Artifact Design

## Goal
Survey relevant industry guidance for greenfield discovery, brownfield discovery, product briefs, PRDs, and documentation layering, then evaluate which patterns PALS should adopt, adapt, or reject.

## Sources Reviewed
| Source | Relevance | Key Takeaway |
|---|---|---|
| Atlassian — PRD / requirements guidance (`https://www.atlassian.com/agile/product-management/requirements`) | lightweight requirements structure | Use a requirements landing page with goals, assumptions, questions, out-of-scope items, and links to deeper detail rather than forcing everything inline. |
| Atlassian — information discoverability (`https://www.atlassian.com/blog/productivity/information-discoverability`) | long-document organization | Section headlines, lists, and progressive disclosure improve human and AI retrieval; tailored dense docs beat walls of text. |
| ProductPlan — product one-pager (`https://productplan.com/learn/product-one-pager`) | concise initiative brief | A brief should establish why, what success means, and what is intentionally not included, without becoming a full spec. |
| ProductPlan — product brief (`https://productplan.com/glossary/product-brief`) | collaborative product-definition summary | Product briefs should be concise, collaborative, and focused on goals, context, and direction. |
| ProductPlan — PRD (`https://productplan.com/glossary/product-requirements-document`) | deeper requirements artifact | PRDs capture explicit capabilities, use cases, assumptions, constraints, dependencies, and environment requirements in more detail than a brief. |
| Thoughtworks — successful discovery (`https://thoughtworks.com/en-us/insights/blog/agile-project-management/run-successful-discovery`) | shaping ambiguous work | Discovery should use structured questions, clear outcomes, stakeholder interviews, and stay distinct from implementation planning. |
| Thoughtworks — modernization anti-patterns (`https://www.thoughtworks.com/en-us/insights/blog/legacy-modernization/modernization-gone-wrong-spotting-and-avoiding-common-antipatterns`) | brownfield modernization discipline | Avoid overcommitting without discovery; involve legacy experts, map dependencies, and align on outcomes rather than dates. |
| AWS — wave-based refactoring discovery (`https://docs.aws.amazon.com/prescriptive-guidance/latest/wave-based-refactoring/discovery-phase.html`) | brownfield capability modeling | Discovery should capture business capabilities, dependencies, complexity, integrations, and business value before analysis and implementation. |
| AWS — detailed application assessment (`https://docs.aws.amazon.com/prescriptive-guidance/latest/application-portfolio-assessment-guide/detailed-application-assessment.html`) | brownfield validation techniques | Validate institutional knowledge with programmatic discovery, use top-down and bottom-up discovery together, and map dependencies early to avoid late surprises. |

## Cross-Cutting Patterns

### 1. Concise product brief first, deeper spec second
**Observed in:** ProductPlan one-pager + product brief guidance

**Mechanic:** Start with a short artifact that explains:
- why this initiative should exist
- what outcome it is trying to create
- what success roughly looks like
- what is intentionally not included

Do **not** start with a giant exhaustive spec.

**Why it matters:** This creates shared alignment quickly and keeps stakeholders from wading into implementation detail before the problem and scope are clear.

**PALS fit:** Strong. PALS needs a hot-path summary layer that is actually readable and reusable.

**Decision:** **Adopt**

### 2. A requirements landing page should track assumptions, questions, and out-of-scope items
**Observed in:** Atlassian PRD/requirements guidance

**Mechanic:** The main requirements page includes:
- goals / business objective
- assumptions
- questions needing research or decisions
- out-of-scope items
- success context
- links to user stories, interviews, and deeper design artifacts

**Why it matters:** It prevents unresolved assumptions and open questions from disappearing into prose, and it gives the team a shared place to orient before diving into details.

**PALS fit:** Strong, but PALS should use shared markdown artifacts rather than a dedicated SaaS blueprint.

**Decision:** **Adapt**
- Keep the explicit buckets: assumptions, open questions, out-of-scope/deferred.
- Use PALS artifacts and targeted reads instead of a single everything-inline page.

### 3. Progressive disclosure is a documentation strategy, not just a UI trick
**Observed in:** Atlassian discoverability guidance + Atlassian agile requirements guidance

**Mechanic:** Use a concise landing page plus links/sections that reveal deeper detail only when needed.

**Why it matters:** It reduces information overload while preserving access to the full picture.

**PALS fit:** Excellent. PALS already values bounded context and explicit loading. Progressive disclosure fits the artifact-first model.

**Decision:** **Adopt**

### 4. Discovery should stay separate from implementation planning
**Observed in:** Thoughtworks discovery guidance

**Mechanic:** Discovery is for understanding the problem, stakeholders, context, risks, and options. Planning implementation comes after that understanding is built.

**Why it matters:** If teams blend discovery and implementation too early, they jump to solutioning before they understand the real problem.

**PALS fit:** Excellent. This directly supports the user's choice to make Phase 67 research-first before implementation.

**Decision:** **Adopt**

### 5. Brownfield onboarding should start from capabilities, dependencies, and current-system evidence
**Observed in:** AWS discovery + AWS detailed application assessment + Thoughtworks modernization guidance

**Mechanic:** Brownfield discovery should collect and validate:
- business capabilities and sub-capabilities
- dependency maps and integrations
- complexity and criticality
- technical stack and environmental constraints
- current pain points and operational risks
- legacy-team / SME knowledge, validated against programmatic data when possible

**Why it matters:** Existing systems hide constraints and dependencies that will invalidate plans if they are not surfaced early.

**PALS fit:** Very strong. PALS already has `map-codebase`; Phase 67 should connect those technical findings more directly to product-definition capture.

**Decision:** **Adopt**

### 6. One durable artifact should not try to be both the executive brief and the full design appendix by default
**Observed in:** ProductPlan brief vs PRD distinction + Atlassian progressive-linking practice

**Mechanic:** Briefs and PRDs may overlap, but they are read differently. A concise summary is used frequently; a deep spec is consulted selectively.

**Why it matters:** Different audiences and different workflow moments need different detail levels.

**PALS fit:** Strong. This is the core of the user's concern about `PROJECT.md` size and hot-path cost.

**Decision:** **Adapt**
- Preserve one conceptual product model.
- Allow the hot-path summary and deeper definition layers to be separate in access pattern and possibly in file layout.

### 7. Massive all-inclusive PRDs are dangerous as default operating artifacts
**Observed in:** ProductPlan PRD guidance and product-ops commentary

**Mechanic:** Traditional PRDs act as the document of record for everything included in a release. They can be very detailed and useful for asynchronous handoff — but they also become heavy.

**Why it matters:** Large specs are sometimes necessary, but they are poor defaults for every lifecycle read.

**PALS fit:** Weak as a default. PALS is collaborative, iterative, and context-sensitive; a giant always-read PRD would work against that.

**Decision:** **Reject** as the default always-read artifact
- A deep PRD-style layer may still be useful.
- It should not become the mandatory hot-path document for all workflows.

### 8. Brownfield modernization should reject parity-first thinking and overcommitment without discovery
**Observed in:** Thoughtworks modernization guidance

**Mechanic:** Do not promise timelines or parity replacements before the legacy landscape, business outcomes, and hidden dependencies are understood.

**Why it matters:** Overcommitting before discovery creates missed deadlines, broken trust, and redesign churn.

**PALS fit:** Strong. This aligns with `brownfield-onboarding.md` and supports keeping brownfield onboarding evidence-first.

**Decision:** **Adopt**

## Adopt / Adapt / Reject Summary
| Pattern | Decision | Why |
|---|---|---|
| Concise product brief first | Adopt | Fits PALS need for a readable hot-path summary artifact. |
| Explicit assumptions / questions / out-of-scope buckets | Adapt | High-value structure, but should live inside shared markdown artifacts and selective reads. |
| Progressive disclosure / linked detail | Adopt | Matches PALS context-management philosophy directly. |
| Discovery separate from implementation planning | Adopt | Prevents premature solutioning and matches the user's approved Phase 67 direction. |
| Brownfield capability/dependency discovery | Adopt | Essential for safe onboarding of existing systems. |
| One conceptual model with distinct read layers | Adapt | Best way to reconcile simplicity with context efficiency. |
| Huge all-inclusive PRD as the default lifecycle artifact | Reject | Too heavy for PALS hot-path usage. |
| Overcommit / parity-first brownfield planning | Reject | Violates evidence-first modernization discipline. |

## File-Model Comparison

### Option A: One durable document
**Shape:** `PROJECT.md` contains everything: brief + deep requirements + assumptions + questions + detailed context.

**Strengths**
- One obvious source of truth
- Minimal file sprawl
- Less risk of cross-file drift

**Weaknesses**
- Hot-path bloat risk
- Harder to preserve concise summary behavior in practice
- Human and AI readers will tend to read the whole document, not just the intended sections

**Assessment for PALS:** viable only if PALS becomes very disciplined about targeted section reads and keeps the file compact. Risky given current usage patterns.

### Option B: Two durable documents
**Shape:** `PROJECT.md` for summary/context; `PRD.md` for deeper product definition.

**Strengths**
- Clear hot-path vs deep-detail separation
- Easier to keep the summary artifact readable
- Better fit for brownfield evidence + greenfield discovery coexisting

**Weaknesses**
- Must define ownership carefully to avoid drift
- Adds one more canonical artifact to the lifecycle

**Assessment for PALS:** operationally attractive if the responsibilities are explicit and the summary/detail contract is narrow.

### Option C: Layered hybrid
**Shape:** a concise landing artifact plus deeper linked detail; could be implemented as two files or as a strict summary-plus-appendix model.

**Strengths**
- Best alignment with progressive disclosure
- Supports one conceptual model with multiple read depths
- Lets PALS preserve artifact simplicity while honoring context-efficiency concerns

**Weaknesses**
- Requires clear rules about what belongs in the landing layer vs deep layer
- Still needs implementation discipline in workflows and validation

**Assessment for PALS:** best strategic fit. The exact file count can follow from the contract, but the layered model itself appears strongest.

## Research Takeaways for Phase 67
1. **PALS should distinguish summary from depth, even if both belong to one conceptual product model.**
2. **Greenfield and brownfield should share one durable schema, but brownfield intake must pull from evidence and dependency mapping.**
3. **Open questions, assumptions, deferred items, and out-of-scope items should be explicit durable concepts, not buried in prose.**
4. **The current `PROJECT.md` hot-path usage makes access pattern a real design concern.**
5. **The strongest industry fit is not "a giant PRD" and not "just a tiny project stub," but a layered model.**

## Bottom Line
Industry guidance points to a consistent conclusion:
- use a **concise brief / landing page** for orientation and alignment
- keep **deeper requirements and rationale** available but selectively consulted
- make **assumptions, questions, constraints, and out-of-scope items explicit**
- treat **brownfield discovery as evidence-first** and separate from implementation planning

That is the most relevant pattern set for Phase 67.
