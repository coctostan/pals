<overview>
UI/UX pattern detection and design heuristic validation for LUKE. Covers component patterns, layout consistency, design system adherence, responsive design, and UX anti-patterns.
</overview>

<component_patterns>

## Component Design Patterns

| Pattern | Good | Smell |
|---------|------|-------|
| Single Responsibility | Component does one thing, clear name | Component handles form + validation + API + display |
| Composition over Props | Slots/children/render props for flexibility | 20+ props controlling behavior variants |
| Controlled vs Uncontrolled | Explicit state management choice | Mixed controlled/uncontrolled in same form |
| Container/Presentational | Logic separated from display | API calls inside render components |
| Consistent Prop Naming | `onX` for events, `isX` for booleans | `handleX` in child, `doX` in parent, mixed conventions |
| Error Boundaries | Graceful error UI at component boundaries | White screen on error, uncaught exceptions |

### Detection

```bash
# Find oversized components (>200 lines)
find src/ -name "*.tsx" -o -name "*.jsx" -o -name "*.vue" | xargs wc -l | sort -rn | head -20

# Find components with many props (>10)
grep -c "props\.\|Props {" --include="*.tsx" --include="*.jsx" src/

# Find mixed state patterns
grep -rn "useState\|useRef\|this.state" --include="*.tsx" --include="*.jsx" src/
```

</component_patterns>

<layout_consistency>

## Layout & Design Consistency

| Area | What to Check | Detection |
|------|--------------|-----------|
| Spacing | Consistent margin/padding values | Grep for hardcoded px values vs design tokens |
| Colors | Using design system colors vs hardcoded hex | Grep for `#[0-9a-fA-F]{3,8}` in style files |
| Typography | Consistent font sizes and weights | Check for raw `font-size` vs typography tokens |
| Breakpoints | Standard responsive breakpoints | Check media queries for consistent values |
| Z-index | Managed z-index scale | Grep for arbitrary z-index values (>100) |
| Border radius | Consistent rounding | Check for varied `border-radius` values |

### Design Token Detection

```bash
# Find hardcoded colors (should use design tokens)
grep -rn "#[0-9a-fA-F]\{3,8\}\|rgb(\|rgba(" --include="*.css" --include="*.scss" --include="*.tsx" src/

# Find hardcoded spacing (should use theme/tokens)
grep -rn "margin:.*[0-9]px\|padding:.*[0-9]px" --include="*.css" --include="*.scss" --include="*.tsx" src/

# Find inline styles (prefer CSS classes/modules)
grep -rn "style={{" --include="*.tsx" --include="*.jsx" src/
```

</layout_consistency>

<ux_heuristics>

## UX Heuristics (Nielsen's 10 + Modern)

| Heuristic | What to Check | Code Signal |
|-----------|--------------|-------------|
| Visibility of Status | Loading states, progress indicators | Check for loading/spinner/skeleton components |
| User Control | Undo, cancel, back navigation | Check for cancel handlers, undo patterns |
| Consistency | Same patterns for same actions | Compare button/form/modal patterns across pages |
| Error Prevention | Confirmation dialogs, input constraints | Check for confirm dialogs on destructive actions |
| Recognition over Recall | Labels, tooltips, placeholder text | Check form fields for labels and helpers |
| Flexibility | Keyboard shortcuts, customization | Check for keyboard event handlers |
| Aesthetic & Minimal | Clean layouts, no clutter | Check component count per page |
| Error Recovery | Helpful error messages, retry options | Check error states for user guidance |
| Feedback | Toast/notification on actions | Check for success/error notifications |
| Mobile-first | Touch targets, responsive layout | Check for min-height/min-width on interactive elements |

</ux_heuristics>

<responsive_patterns>

## Responsive Design

| Pattern | Good | Smell |
|---------|------|-------|
| Mobile-first | `min-width` media queries | `max-width` only, desktop-first |
| Flexible grids | CSS Grid, Flexbox, relative units | Fixed-width layouts, absolute positioning |
| Touch targets | ≥44px interactive elements | Small buttons, tiny links on mobile |
| Viewport units | `vh`, `vw`, `%` for layout | Fixed `px` heights for full-screen layouts |
| Image optimization | Responsive images, lazy loading, srcset | Single large image for all sizes |
| Typography scaling | `rem`/`em` based, fluid typography | Fixed `px` font sizes |

</responsive_patterns>

<ux_antipatterns>

## UX Anti-Patterns

- **The Modal Avalanche:** Modal opens modal opens modal — use progressive disclosure or wizard instead
- **The Invisible Action:** Important actions hidden in overflow menus — primary actions should be visible
- **The Silent Failure:** Action completes with no feedback — always confirm success or explain failure
- **The Infinite Scroll Trap:** No way to reach footer content — provide "load more" or pagination alternative
- **The Disabled Mystery:** Button disabled with no explanation — use tooltip or helper text
- **The Layout Shift:** Content jumping as images/ads load — use skeleton screens, fixed dimensions
- **The Dark Pattern:** Misleading UI that tricks users — opt-outs should be as easy as opt-ins

</ux_antipatterns>
