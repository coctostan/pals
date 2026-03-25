# UX Design Principles

Core principles guiding LUKE module behavior.

## Principles

1. **Users don't read, they scan.** Visual hierarchy, clear labels, and consistent patterns matter more than documentation. LUKE checks that UI components communicate their purpose through structure.

2. **Every interaction needs feedback.** Clicks, submissions, and state changes must produce visible results. LUKE flags actions without loading states, success confirmations, or error messages.

3. **Consistency reduces cognitive load.** Similar actions should look and behave the same way across the application. LUKE detects inconsistent component patterns, mixed naming conventions, and varied spacing.

4. **Design systems exist for a reason.** Hardcoded colors, spacing, and typography bypass the design system and create drift. LUKE flags raw values that should use design tokens.

5. **Components should be small and focused.** A 500-line component is a god component. LUKE flags oversized components and prop-heavy interfaces that signal responsibility creep.

## Advisory vs Blocking

- **Advisory (pre-plan):** Component assessment, design consistency check, UX heuristic coverage — inform the plan
- **Blocking (post-apply):** New god components >500 lines (high), removed error boundaries (high), new inline styles bypassing design system (medium — warn only)
