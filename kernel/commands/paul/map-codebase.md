<objective>
Analyze existing codebase and create structured documentation in .paul/codebase/

Spawns parallel Explore agents to analyze technology stack, architecture, conventions, testing patterns, external integrations, and areas of concern.
</objective>

<execution_context>
@src/workflows/map-codebase.md
</execution_context>

<process>
**Follow workflow:** @src/workflows/map-codebase.md

The workflow implements:
1. Check if .paul/codebase/ exists (offer refresh/update/skip)
2. Create directory structure
3. Spawn 5 parallel Explore agents:
   - Agent 1: Stack + Integrations (Technology Focus)
   - Agent 2: Architecture + Structure (Organization Focus) — includes brownfield pattern detection
   - Agent 3: Conventions + Testing (Quality Focus) — includes brownfield style rules
   - Agent 4: Concerns (Issues Focus)
   - Agent 5: Reference Graph (Dependency Focus) — hub files, entry points, clusters
4. Collect and aggregate agent findings
5. Write 8 codebase documents from templates (7 original + GRAPH.md)
6. Verify and commit
7. Post-map routing: offer /paul:init (if no .paul/) or continue planning (if .paul/ exists)
</process>

<success_criteria>
- [ ] .paul/codebase/ directory created
- [ ] All 8 documents populated with findings (7 original + GRAPH.md)
- [ ] GRAPH.md contains hub files, entry points, reference edges, clusters
- [ ] Documents include actual file paths (actionable)
- [ ] Codebase map committed
- [ ] Post-map routing offered (init if .paul/ missing, planning if .paul/ exists)
- [ ] User informed of next steps
</success_criteria>
