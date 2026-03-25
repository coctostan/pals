<overview>
Architecture onboarding heuristics for ARCH. Helps new contributors (human or AI) quickly understand a project's structure, patterns, and conventions.
</overview>

<onboarding_scan>

## Project Structure Scan

Run these commands to build a structural picture:

```bash
# Directory tree (2 levels, dirs only)
find . -maxdepth 2 -type d -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/.paul/*'

# File count per top-level directory
for dir in $(ls -d src/*/  2>/dev/null || ls -d */ 2>/dev/null); do
  echo "$dir: $(find "$dir" -type f | wc -l | tr -d ' ') files"
done

# Entry points
ls -la src/index.* src/main.* src/app.* index.* main.* app.* 2>/dev/null

# Package/dependency indicators
ls package.json go.mod Cargo.toml requirements.txt pyproject.toml Gemfile pom.xml build.gradle 2>/dev/null
```

</onboarding_scan>

<pattern_recognition>

## Pattern Recognition Checklist

| Check | Command | What It Tells You |
|-------|---------|-------------------|
| Layer structure | `ls src/` | MVC, clean arch, feature-based, or flat |
| Test co-location | `find . -name '*.test.*' -o -name '*.spec.*' \| head -5` | Tests beside source or in separate `__tests__/` |
| Config pattern | `ls *.config.* .env* tsconfig.json` | Build tools, env management |
| API style | `grep -r 'app.get\|app.post\|@Get\|@Post\|def get\|func Handle' src/ \| head -5` | REST, GraphQL, RPC |
| State management | `grep -r 'useState\|createStore\|useReducer\|Redux\|Vuex\|Pinia' src/ \| head -3` | Frontend state approach |
| Data access | `grep -r 'prisma\|typeorm\|sequelize\|mongoose\|sqlx\|gorm\|ActiveRecord' src/ \| head -3` | ORM/data layer |
| Auth pattern | `grep -r 'jwt\|passport\|auth\|session\|OAuth' src/ \| head -3` | Authentication approach |

</pattern_recognition>

<onboarding_report>

## Onboarding Report Format

ARCH should produce a structural brief when encountering a new or unfamiliar project:

```markdown
## Architecture Brief

**Project type:** {web app | API | CLI | library | monorepo}
**Language:** {primary language}
**Pattern:** {MVC | Clean/Hexagonal | Feature-based | Flat | Custom}
**Entry point:** {main file}

### Layer Map
| Layer | Directory | Purpose |
|-------|-----------|---------|
| {layer} | {dir} | {what it does} |

### Key Conventions
- Test location: {co-located | separate}
- Config approach: {env files | config module | both}
- Import style: {relative | aliases | barrel exports}

### Boundaries to Enforce
- {rule 1}
- {rule 2}

### Risks
- {identified risk or smell}
```

</onboarding_report>

<brownfield_heuristics>

## Brownfield Project Heuristics

For existing projects without explicit architecture docs:

1. **Infer from structure:** Directory names and nesting reveal intent even without documentation
2. **Infer from imports:** The most-imported files are the architectural core
3. **Infer from age:** Oldest files often define the original pattern; newest files show current practice
4. **Infer from size:** Largest files are often where architecture broke down
5. **Infer from tests:** Test structure often mirrors the intended (not actual) architecture

</brownfield_heuristics>
