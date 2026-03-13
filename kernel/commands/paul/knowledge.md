---
name: pals:knowledge
description: Capture and search project knowledge — decisions, rationale, and context
argument-hint: "[capture|search query text]"
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep]
---

<objective>
Capture project knowledge (decisions, rationale, trade-offs, constraints, lessons) into a searchable
knowledge base, or search existing knowledge to surface relevant context.

**When to use:** To record why a decision was made, to find past rationale, or to review project knowledge.

**SKIP integration:** Uses SKIP's knowledge-capture.md and knowledge-search.md references.
</objective>

<execution_context>
@~/.pals/modules/skip/references/knowledge-capture.md
@~/.pals/modules/skip/references/knowledge-search.md
</execution_context>

<context>
Query/Mode: $ARGUMENTS (optional — "capture", or search query text)

Project working directory.
</context>

<process>

<step name="determine_mode">
**Determine operating mode from arguments.**

1. If $ARGUMENTS is empty or not provided:
   - Mode: **dashboard**
2. If $ARGUMENTS is "capture":
   - Mode: **capture**
3. Otherwise:
   - Mode: **search**
   - Query: $ARGUMENTS
</step>

<step name="locate_knowledge_base">
**Find or note absence of KNOWLEDGE.md.**

1. Check for knowledge base file:
   - Look for `KNOWLEDGE.md` in project root
   - Then check `.paul/KNOWLEDGE.md`
   - Then check `docs/KNOWLEDGE.md`
2. Store path if found, or note "not found"
</step>

<step name="mode_dashboard">
**Mode: Dashboard (no arguments)**

1. If KNOWLEDGE.md not found:
   ```
   ════════════════════════════════════════
   SKIP — Project Knowledge Dashboard
   ════════════════════════════════════════

   Knowledge Base: Not started

   SKIP captures the "why" behind your project:
   - Decisions — choices made between alternatives
   - Rationale — reasoning behind approaches
   - Trade-offs — acknowledged costs of decisions
   - Constraints — external limitations shaping design
   - Lessons — insights gained from experience

   ────────────────────────────────────────
   Get started:
     /paul:knowledge capture    — Record your first entry
     /paul:knowledge [query]    — Search project context
   ────────────────────────────────────────
   ```

2. If KNOWLEDGE.md found:
   - Read the file
   - Count entries by type (grep for `**Type:**` lines)
   - Extract recent entries (last 5 by date)
   - Display dashboard:
   ```
   ════════════════════════════════════════
   SKIP — Project Knowledge Dashboard
   ════════════════════════════════════════

   Knowledge Base: [path]
   Total Entries: [N]

   By Category:
     Decisions:     [N]
     Rationale:     [N]
     Trade-offs:    [N]
     Constraints:   [N]
     Lessons:       [N]

   Recent Entries:
     [date] [type] [title]
     [date] [type] [title]
     [date] [type] [title]

   ────────────────────────────────────────
   Usage:
     /paul:knowledge capture    — Record new knowledge
     /paul:knowledge [query]    — Search knowledge base
   ────────────────────────────────────────
   ```
</step>

<step name="mode_capture">
**Mode: Capture (argument is "capture")**

1. Ask the user what type of knowledge to capture:
   ```
   What type of knowledge are you recording?

   [1] Decision — a choice made between alternatives
   [2] Rationale — reasoning behind an approach
   [3] Trade-off — acknowledged costs of a decision
   [4] Constraint — external limitation shaping design
   [5] Lesson — insight gained from experience
   ```

2. Wait for user selection.

3. Ask for a brief title:
   ```
   Brief title for this entry:
   (e.g., "Chose flat workflow structure over nested directories")
   ```

4. Wait for user response.

5. Ask for content based on type — use the appropriate template from
   @~/.pals/modules/skip/references/knowledge-capture.md:
   - For decisions: ask for context, decision, alternatives, rationale, impact
   - For rationale: ask for explanation and key factors
   - For trade-offs: ask for what was gained, what was accepted, revisit conditions
   - For constraints: ask for source, constraint, workarounds, expiration
   - For lessons: ask for what happened, what was learned, how to apply

6. Format the entry using the template from knowledge-capture.md.

7. Write to KNOWLEDGE.md:
   - If file doesn't exist: create it with a header and the first entry
   - If file exists: prepend the new entry after the header (newest first)
   - Header format:
     ```markdown
     # Project Knowledge Base

     Maintained by SKIP — Smart Knowledge & Information Persistence.
     Entries are chronological (newest first). Search with `/paul:knowledge [query]`.

     ---
     ```

8. Confirm:
   ```
   ────────────────────────────────────────
   Knowledge captured:
     [date] [type] — [title]
     Written to: [path]
   ────────────────────────────────────────
   ```
</step>

<step name="mode_search">
**Mode: Search (argument is query text)**

Follow search strategy from @~/.pals/modules/skip/references/knowledge-search.md:

1. Search KNOWLEDGE.md for query terms (if file exists):
   - Match in titles (highest priority)
   - Match in content
   - Match in type fields

2. Search .paul/STATE.md Decisions table for query terms

3. Search .paul/phases/*/SUMMARY.md for decisions sections matching query

4. Search .paul/PROJECT.md Key Decisions table for query terms

5. Collect and rank matches:
   - Title matches rank highest
   - Recent entries rank higher
   - Type-matched entries rank higher (infer from question pattern)

6. Display results:
   - If matches found: show entries with context (see knowledge-search.md retrieval format)
   - If no matches found:
     ```
     No knowledge entries found matching "[query]".

     Suggestions:
     - Try broader terms
     - Search by type: /paul:knowledge type:decision [query]
     - The knowledge may not have been captured yet —
       consider adding it with /paul:knowledge capture
     ```
</step>

</process>

<output>
- Dashboard: knowledge base overview with entry counts and recent entries
- Capture: new entry written to KNOWLEDGE.md
- Search: matching entries from across project knowledge sources
</output>
