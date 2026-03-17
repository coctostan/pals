# Recommended Planning Model

## Goal
Define an implementation-ready collaboration model for PALS planning and onboarding that increases user involvement without weakening `.paul/*` artifact authority, backward compatibility, or cross-harness interoperability.

---

## Recommendation Summary
PALS should keep its current artifact-first architecture and executable planning discipline, but add a stronger **definition layer** ahead of plan generation. The right change is not to replace skills, markdown workflows, or shared artifacts. The right change is to make those workflows better at gathering, preserving, and reviewing user intent.

The recommended model has three pillars:
1. **Adjustable collaboration levels** for project, milestone, and phase planning
2. **Structured requirement capture** that preserves must-haves, constraints, deferred items, open questions, and assumptions explicitly
3. **Layered plan review** so users can choose how much planning detail to inspect before continuing

---

## 1. Collaboration Levels

## Proposed levels
Use the same three levels across:
- project planning / onboarding
- milestone discussion / creation
- phase discussion / planning

### Low
**Intent:** Minimal interruption. PAUL mostly proceeds unless blocked.

**Behavior:**
- asks only for missing essentials or clear blockers
- prefers direct synthesis from the user’s initial request
- captures requirements explicitly, but with minimal probing
- offers the standard review menu before continuing
- avoids deep alternative exploration unless ambiguity is material

**Best for:**
- obvious or low-risk work
- users who want speed over exploration
- repeated or incremental planning where context already exists

### Medium
**Intent:** Clarify what is still open.

**Behavior:**
- asks follow-up questions for ambiguities, constraints, or unclear success conditions
- surfaces open questions explicitly
- preserves requirements/constraints/deferred ideas in structured form
- may ask for confirmation on synthesized scope before moving on
- offers the standard review menu before continuing

**Best for:**
- normal feature shaping
- most project, milestone, and phase planning work
- users who want collaboration without a heavy product discovery ritual

### High
**Intent:** Thorough collaborative shaping.

**Behavior:**
- probes for edge cases, constraints, target users, assumptions, alternatives, and success criteria
- distinguishes exploratory vs direct-requirements mode more explicitly
- offers multiple candidate approaches/angles where useful
- may use simplified design-tree thinking:
  - desired outcome
  - problems/opportunities
  - candidate approaches
  - assumptions / open questions
- preserves richer PRD-style structure before plan generation
- still offers the same review menu before continuing

**Best for:**
- ambiguous or high-stakes work
- new project definition
- substantial milestone shaping
- onboarding where the problem framing is still emerging

---

## 2. Where the setting should live

## Recommendation
Support **both**:
- a **project default** in config
- a **per-run override** at the start of onboarding or planning

## Why both are needed
A project often has a natural default collaboration posture, but not every planning run should use the same depth.

Examples:
- trivial follow-up phase in a well-understood milestone → low
- standard feature planning → medium
- ambiguous milestone or major onboarding → high

## Proposed behavior
### Project default
Store a planning collaboration preference in project config, likely in `pals.json` under preferences or planning.

Example shape:
```json
{
  "planning": {
    "default_collaboration": "medium"
  }
}
```

### Per-run override
When entering a planning-oriented workflow, allow a quick override if useful.

Example interaction:
- “Planning collaboration level: medium (project default). Keep it, or switch to low/high?”

### Fallback behavior
If no project default exists:
- use `medium`
- make the chosen value explicit for the run

---

## 3. Scope of the setting
The collaboration setting should affect only:
- project planning / onboarding
- milestone discussion / milestone setup
- phase discussion / phase planning

It should **not** change:
- APPLY checkpoint behavior
- UNIFY retrospective behavior
- execution gating or validation semantics

This preserves the user’s request and keeps the change bounded to upstream definition work.

---

## 4. Required review interaction before proceeding

## Standard prompt
Before surfacing or committing to the plan, PAUL should ask:

**“Would you like to see the plan?”**

with these four options:
1. **Quick recap**
2. **Detailed recap**
3. **Full plan**
4. **No review needed**

## Meaning of each option
### 1. Quick recap
A short synthesis of:
- goal
- main tasks/phases
- major constraints
- open questions or assumptions if any

### 2. Detailed recap
A richer but still prose-first summary of:
- goal
- structured requirements
- key decisions
- major tasks/phases
- constraints
- deferred items
- open questions

### 3. Full plan
Show the full executable plan artifact or the full milestone/phase structure.

### 4. No review needed
Skip directly to the next workflow step once the user is satisfied with the discussion.

## Why this matters
This creates progressive disclosure and gives the user control over inspection depth without forcing every workflow to always expose the full plan first.

---

## 5. Required requirement structure
PALS should preserve important user intent explicitly during planning-oriented workflows. The specific file can vary, but the captured structure should include:
- **Must-Have Requirements**
- **Optional / Nice-to-Have**
- **Explicitly Deferred**
- **Constraints**
- **Open Questions**
- **Assumptions** (recommended, especially for onboarding/high collaboration)

## Why this matters
Current PALS prose summaries are often reasonable, but they can blur distinctions between:
- required vs optional
- deferred vs forgotten
- assumptions vs known facts
- unresolved questions vs silent defaults

This structure should become the loss-prevention layer between discussion and planning.

---

## 6. Recommended planning flow changes

## Project onboarding / init
### Current issue
Init gathers too little information and leaves `PROJECT.md` under-populated relative to its template potential.

### Recommendation
Add a richer onboarding mode that can produce a substantive planning brief / PRD input before the first milestone or first plan.

### Proposed onboarding behavior
- detect whether the run is exploratory or direct-requirements
- gather target users, problem, intended outcome, constraints, assumptions, and out-of-scope items
- preserve structured requirement buckets
- use brownfield mapping evidence when available
- sync durable conclusions into `PROJECT.md`

### Important boundary
Do not force a heavyweight PRD on all users. Low-collaboration onboarding should still be concise.

---

## Milestone discussion
### Current issue
Milestone discussion is feature-first and better than direct milestone creation, but it still converges to structure too quickly.

### Recommendation
Add collaboration-level-aware milestone discussion behavior.

### Proposed milestone changes
- at low: preserve features/constraints with minimal probing
- at medium: ask about open questions, success conditions, and limitations
- at high: also probe alternatives, assumptions, and milestone-level risks
- preserve structured feature/requirement buckets in `MILESTONE-CONTEXT.md` or a compatible enriched handoff
- offer the 4-option review menu before moving to milestone creation

---

## Phase discussion + planning
### Current issue
Phase discussion is goal-oriented but not explicit enough about requirement preservation; plan-phase is rigorous but assumes good inputs.

### Recommendation
Strengthen the handoff between discuss and plan.

### Proposed phase changes
- begin by deciding mode: exploratory vs direct requirements
- preserve must-haves / constraints / deferred / open questions explicitly in phase context
- for high collaboration, allow a simplified design-tree section if the phase is ambiguous
- before exposing or finalizing the executable plan, offer the 4-option review menu

---

## 7. Simplified design-tree model for high collaboration
PALS should not add a mandatory complex discovery framework. But for high-collaboration planning, it should support a simplified textual design tree.

## Recommended textual shape
- **Outcome:** what success should change
- **Problems / opportunities:** the main user or workflow pains
- **Candidate approaches:** 2-3 possible ways to address them
- **Assumptions / open questions:** what is still uncertain
- **Recommended direction:** current best path

## Why this is the right adaptation
This preserves the best part of opportunity solution trees — collaborative externalization of reasoning — without adding a new visual dependency or breaking markdown portability.

---

## 8. Artifact strategy

## Keep current authority model
Continue to treat `.paul/*` artifacts as the lifecycle truth.

## Recommended artifact posture
- reuse and enrich existing artifacts where possible
- avoid Pi-only or harness-specific truth files
- allow richer temporary handoff artifacts where useful, but sync important enduring knowledge into canonical project artifacts

## Likely artifact impact
### Enduring artifacts
- `PROJECT.md` should become a stronger repository of validated requirements, constraints, assumptions/decisions, target users, and success metrics

### Temporary / handoff artifacts
- milestone and phase context files can become richer structured capture layers
- these remain useful as discussion/session continuity tools even if later summarized into more stable artifacts

---

## 9. Interoperability and skill/process implications

## Skill + markdown process assessment
The current skill + markdown process is still viable and should remain the base architecture.

### What should change
- workflow behavior
- artifact population quality
- recap/review interactions
- collaboration depth handling

### What should not change
- canonical `/skill:paul-*` model
- shared kernel markdown as workflow truth
- `.paul/*` state authority
- Pi vs non-Pi portability boundaries

## Why this matters
The milestone goal is to improve the **interaction model**, not to replace the lifecycle engine.

---

## 10. Backward compatibility strategy
To keep the change safe:
- default collaboration should be `medium` when no config exists
- existing workflows should still work if the richer structures are absent
- review menu behavior should layer on top of current discussion/planning rather than requiring all legacy artifacts to be migrated at once
- low collaboration should feel close to current PALS behavior, but with better explicit preservation of requirements

This allows gradual adoption rather than a disruptive redesign.

---

## 11. Recommended implementation split

## Phase 66: Collaborative planning model
Implement:
- planning collaboration config default + per-run override
- exploratory vs direct-requirements mode selection
- low / medium / high collaboration semantics for project/milestone/phase planning
- the 4-option review prompt:
  1. Quick recap
  2. Detailed recap
  3. Full plan
  4. No review needed
- workflow wording and review routing changes needed to support the above

## Phase 67: Onboarding & PRD depth
Implement:
- richer onboarding / init capture behavior
- stronger structured requirement capture in discussion artifacts
- syncing of substantive requirement/constraint/open-question data into `PROJECT.md`
- brownfield/onboarding reference and template alignment
- validation/docs/interoperability coverage for the new artifact semantics

---

## Final Recommendation
PALS should evolve from **artifact-first execution discipline** into **artifact-first collaborative definition plus execution discipline**.

The architecture does not need to be replaced. The workflows need to become better at:
- asking at the right depth
- preserving what the user said explicitly
- offering alternatives when appropriate
- giving users control over how much plan detail they review
- producing stronger onboarding/PRD artifacts before implementation starts

That is the cleanest path to making planning feel substantially more collaborative while preserving the core PALS virtues that already work.

---

## Key Phrase
The target state is:

**low friction when the user wants speed, high collaboration when the user wants depth, and explicit requirements preservation in every case.**

low / medium / high
