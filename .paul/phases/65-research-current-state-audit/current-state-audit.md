# Current-State Audit

## Purpose
This audit documents how PALS currently handles project onboarding, milestone discussion, phase discussion, planning, and Pi skill routing. The goal is to identify where the system already supports collaboration well, where it collapses too quickly into structure or execution, and where requirements fidelity is currently too weak for the new milestone goals.

## Audit Scope
Reviewed surfaces:
- `kernel/workflows/init-project.md`
- `kernel/workflows/discuss-phase.md`
- `/Users/maxwellnewman/.pi/agent/skills/pals/workflows/discuss-milestone.md`
- `kernel/workflows/plan-phase.md`
- `kernel/templates/PROJECT.md`
- `kernel/references/brownfield-onboarding.md`
- `drivers/pi/skill-map.md`
- `~/pi/workspace/pi-megapowers/prompts/brainstorm.md` as an external comparison point already referenced by the user

---

## Executive Summary
PALS already has a strong artifact-first lifecycle and does several collaboration-positive things: it asks one question at a time during discussion workflows, distinguishes discussion from planning, preserves handoff artifacts, and keeps `.paul/*` as the authoritative state.

However, the current system still skews toward **workflow progression over requirement formation**. The biggest gaps are upstream of implementation:
- init captures only a thin project brief and explicitly defers most requirements work
- discuss workflows gather intent, but they do not preserve requirements in a structured, loss-resistant way
- plan-phase converts scope into executable structure without a deliberate collaboration-depth model
- there is no explicit mechanism for deciding whether the user wants lightweight planning or high-touch collaborative shaping
- there is no standard review choice between discussion and plan execution beyond approval of a finished plan

The result is that PALS is good at moving from idea to execution discipline, but weaker at **interactive requirement shaping**, **PRD-grade onboarding**, and **adjustable collaboration intensity**.

---

## Surface-by-Surface Findings

## 1. `init-project.md`
### What it currently optimizes for
`kernel/workflows/init-project.md` is optimized for fast setup and momentum. It explicitly frames init as conversational and low-friction, then routes quickly into planning.

### Where it collaborates well
Strengths:
- asks one question at a time
- distinguishes greenfield vs brownfield adoption
- can enrich init with codebase findings when brownfield mapping exists
- keeps the conversation user-facing rather than template-editing-heavy
- sets up artifacts that can be reused later

### Where collaboration depth is weak
Weak points:
- the generated `PROJECT.md` is intentionally skeletal; requirements and constraints are mostly deferred to later planning
- init asks for core value and a short description, but does not produce a real PRD, problem framing document, or explicit list of assumptions/open questions
- even in brownfield mode, the flow prioritizes fast setup over collaborative synthesis of discovered constraints into a complete definition artifact
- there is no decision point for how collaborative the user wants subsequent planning to be

### Evidence
- The workflow says init should “feel like the natural start of work, not a chore,” which is good for momentum but biases toward brevity.
- `create_project_md` explicitly leaves must/should/nice-to-have and constraints as placeholders to be “defined during planning.”
- `create_structure` ends with “Before planning, I need to understand what you're building,” but the actual information gathered remains shallow.

### Collaboration risk
Important project-level requirements can remain implicit too long. That makes later planning vulnerable to Claude-generated assumptions.

---

## 2. `discuss-phase.md`
### What it currently optimizes for
`kernel/workflows/discuss-phase.md` is optimized for pre-plan clarification of a single phase. Its philosophy is “goals first,” and it correctly separates user input gathering from Claude assumption surfacing.

### Where it collaborates well
Strengths:
- asks one question at a time
- leads with goals rather than implementation
- asks for approach, constraints, and open questions
- persists `CONTEXT.md` so discussion survives `/clear`
- explicitly warns against skipping confirmation

### Where collaboration depth is weak
Weak points:
- the output is a freeform phase handoff, not a structured requirements artifact
- it does not explicitly preserve must-haves, optional ideas, deferred ideas, constraints, and open questions in durable buckets
- the handoff is optimized to route into `/paul:plan`, not to support iterative requirement refinement
- there is no collaboration mode that changes how much probing happens
- there is no built-in recap or review menu before the plan gets authored

### Evidence
The workflow stores `goals` and `approach` notes, but not a normalized requirement set. It asks for confirmation of a synthesized summary, yet the artifact format is less rigorous than a PRD or even a structured brainstorming result.

### Collaboration risk
Good discussion can still collapse into a lossy handoff because later planning has to reinterpret prose rather than consume explicit requirement categories.

---

## 3. `discuss-milestone.md`
### What it currently optimizes for
The milestone discussion flow is stronger than raw milestone creation because it is explicitly feature-first and asks the user what they want to build before defining phases.

### Where it collaborates well
Strengths:
- presents prior accomplishments for context
- asks “What do you want to build next?” rather than “How many phases?”
- confirms synthesized scope before writing the handoff
- persists `MILESTONE-CONTEXT.md`

### Where collaboration depth is weak
Weak points:
- it still centers on feature grouping and milestone structure more than deep requirement capture
- there is no adjustable collaboration intensity
- it does not explicitly maintain a decision log of open questions, assumptions, alternatives considered, or out-of-scope items
- once synthesis is accepted, the next step is milestone creation, not an optional recap/review stage

### Evidence
The workflow is anti-pattern-aware about “features first” vs “phases first,” which is good. But its target output remains milestone framing rather than a requirement-rich product definition artifact.

### Collaboration risk
For ambiguous initiatives, users may still feel the system is “running with it” because the workflow is designed to converge to structure quickly.

---

## 4. `plan-phase.md`
### What it currently optimizes for
This workflow is optimized for producing executable plans. It is one of the strongest parts of PALS and already includes clarity testing, complexity gating, module hook dispatch, and rigorous task structure.

### Where it collaborates well
Strengths:
- requires plan specificity
- preserves boundaries explicitly
- has a good clarity test (“Could someone with no project context execute this?”)
- supports pre-plan hook suggestions and asks for user confirmation if a non-default plan type is suggested
- ends with plan review/approval before APPLY

### Where collaboration depth is weak
Weak points:
- collaboration mostly happens **before** this workflow, not inside it
- once plan-phase starts, it is oriented around scope analysis and execution packaging rather than requirement discovery
- there is no built-in way to ask: should this plan be generated with low, medium, or high collaboration?
- there is no standard pre-plan recap choice such as quick summary vs detailed summary vs full plan vs skip review
- approval currently happens on a finished plan, not on a graduated summary of intent

### Evidence
The workflow strongly protects execution quality, but its inputs are assumed to be adequate. This is excellent for disciplined delivery and weaker for collaborative shaping upstream.

### Collaboration risk
If earlier discussion was thin, plan-phase can produce a technically solid plan from an underdeveloped understanding of user intent.

---

## 5. `PROJECT.md` template
### What it currently optimizes for
The template is a comprehensive project brief structure and is conceptually closer to a PRD than what init currently fills in.

### Where it collaborates well
Strengths:
- includes requirements split by validated / active / planned / out of scope
- includes target users, context, constraints, key decisions, success metrics, tech stack, and links
- already contains much of the schema needed for substantive onboarding

### Where collaboration depth is weak in practice
Weak points:
- the template is good, but the default init flow under-populates it
- the current workflow uses `PROJECT.md` more like a living brief than a collaboratively generated PRD
- there is no explicit onboarding mode that helps users fill assumptions, open questions, alternatives, or scope exclusions in a structured way

### Evidence
The template’s structure is already stronger than the actual init conversation. This suggests the main gap is not missing file shape, but missing **workflow behavior to populate it well**.

### Collaboration risk
PALS has latent PRD capacity, but the workflow currently leaves too much of it empty or delayed.

---

## 6. `brownfield-onboarding.md`
### What it currently optimizes for
This guide is strong on adoption strategy, scoping caution, and respecting existing codebases.

### Where it collaborates well
Strengths:
- emphasizes understanding before changing
- promotes boundary setting and gradual adoption
- advises scoping small, preserving conventions, and using codebase evidence
- gives concrete scenarios for monorepo, legacy, mid-project, and team adoption

### Where collaboration depth is weak
Weak points:
- it is a good guide, but not an interactive capture flow
- it helps scope the first milestone but does not itself generate a substantive onboarding artifact
- user goals, assumptions, and decision points still depend on adjacent workflows

### Collaboration risk
Brownfield onboarding is strategically careful but not yet sufficiently conversational or PRD-producing.

---

## 7. `drivers/pi/skill-map.md`
### What it currently optimizes for
The Pi skill map is optimized for preserving canonical workflow truth while adding adapter ergonomics.

### Where it collaborates well
Strengths:
- clearly separates `/paul-*` routing from `/skill:paul-*` canonical entry
- reinforces that shared workflow markdown remains the implementation truth
- avoids Pi-only lifecycle truth

### Where friction remains
Weak points:
- discoverability is better than before, but the user still interacts with multiple conceptual layers: command wrapper, skill, workflow, artifacts, installed module overlays
- the layering is architecturally sound but can feel indirect when the user wants a more collaborative product-thinking conversation
- because the collaboration model is not explicit, the adapter cannot signal whether the current run is in low/medium/high collaboration mode

### Collaboration risk
The skill + markdown architecture is interoperable and disciplined, but it can feel more like a lifecycle engine than a collaborative product-definition partner.

---

## 8. Comparison point: `pi-megapowers/prompts/brainstorm.md`
### What it does better than current PALS upstream planning
The brainstorm prompt introduces several mechanics that directly address PALS's current weaknesses:
- early triage between exploratory vs direct requirements mode
- mandatory project scan before substantive questions
- explicit requirement preservation buckets: must-have, optional, deferred, constraint, open question
- explicit instruction not to silently drop reduced-scope items
- requirement artifact review before saving
- “brainstorming is optional; requirements capture is not”

### Why this matters
This prompt is closer to a collaborative product-definition workflow than current PALS discuss/init behavior. It preserves user intent as structured truth instead of letting it remain embedded in prose.

### Caution
PALS should not copy the entire workflow blindly. It still needs:
- artifact-first interoperability
- backward compatibility with current lifecycle files
- low-overhead defaults for users who do not want a heavy process

---

## Cross-Cutting Findings

## What PALS already does well
- Strong artifact authority: `.paul/*` remains the lifecycle truth
- Strong plan rigor once execution planning begins
- Good one-question-at-a-time conversational discipline in discuss flows
- Good preservation of context handoff files (`MILESTONE-CONTEXT.md`, `CONTEXT.md`)
- Good separation between planning and execution semantics
- Strong interoperability posture across kernel and Pi surfaces

## Main gaps to solve
### 1. No adjustable collaboration model
There is currently no formal low/medium/high planning collaboration setting at project, milestone, or phase level.

### 2. Weak requirements normalization
User intent is often preserved as prose summaries rather than explicit requirement buckets.

### 3. Thin onboarding artifact generation
Init creates just enough to get moving, but not enough to produce a substantive PRD-grade onboarding outcome.

### 4. Missing intermediate review layer
PALS supports plan approval, but not the newly requested interaction of:
1. Quick recap
2. Detailed recap
3. Full plan
4. No review needed
before presenting the whole plan as the only major review object.

### 5. Current skill + markdown process is sound but under-expressive
The architecture itself is not the problem. The weakness is that the workflow behavior populating those artifacts is not yet collaborative enough.

---

## Root-Cause Assessment
The current system was designed to fix chaos in execution by making plans executable, state persistent, and lifecycle truth explicit. It succeeds there.

The new problem is upstream: users want PALS to behave less like a disciplined plan generator and more like a **collaborative requirement-shaping partner** before the plan exists. That requires new interaction semantics, not a new authority layer.

In other words:
- the artifact-first architecture is still correct
- the markdown + skills model is still viable
- the missing piece is a richer **definition workflow** that can preserve user intent with more fidelity and with variable interaction depth

---

## Implications for the Next Phases
Phase 66 should focus on collaboration semantics and review flow:
- collaboration level behavior
- default + override model
- recap/review choices before plan reveal
- how these interact with project, milestone, and phase planning

Phase 67 should focus on onboarding and artifact depth:
- turning init/discuss outputs into stronger requirement/PRD artifacts
- preserving requirements, constraints, deferred items, and open questions explicitly
- keeping shared markdown artifacts authoritative and cross-harness-safe
