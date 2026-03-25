<overview>
Accessibility pattern detection and WCAG compliance checking for ARIA. Covers semantic HTML, ARIA attributes, keyboard navigation, color contrast, screen reader compatibility, and focus management.
</overview>

<semantic_html>

## Semantic HTML

| Element | Use For | Common Mistake |
|---------|---------|---------------|
| `<button>` | Clickable actions | `<div onClick>` or `<span onClick>` without role |
| `<a>` | Navigation links | `<div>` with click handler for navigation |
| `<nav>` | Navigation sections | `<div class="nav">` |
| `<main>` | Primary content | No landmark, all content in `<div>` |
| `<header>/<footer>` | Page/section headers | `<div class="header">` |
| `<form>` | Form containers | Inputs outside form elements |
| `<label>` | Input labels | Placeholder-only inputs, no `<label>` |
| `<h1>`-`<h6>` | Heading hierarchy | Skipping levels (h1 → h3), `<div class="title">` |

### Detection

```bash
# Find non-semantic click handlers (div/span with onClick)
grep -rn "<div.*onClick\|<span.*onClick" --include="*.tsx" --include="*.jsx" src/

# Find inputs without labels
grep -rn "<input\|<select\|<textarea" --include="*.tsx" --include="*.jsx" src/ | grep -v "aria-label\|aria-labelledby\|<label"

# Find images without alt text
grep -rn "<img" --include="*.tsx" --include="*.jsx" src/ | grep -v "alt="
```

</semantic_html>

<aria_attributes>

## ARIA Attributes

| Attribute | Purpose | When Required |
|-----------|---------|---------------|
| `aria-label` | Text label for elements without visible text | Icon buttons, image links |
| `aria-labelledby` | Reference to visible label element | Complex widgets, dialog titles |
| `aria-describedby` | Additional description | Form field help text, error messages |
| `aria-expanded` | Toggle state | Dropdowns, accordions, collapsible sections |
| `aria-hidden` | Hide from assistive tech | Decorative icons, duplicate content |
| `aria-live` | Dynamic content updates | Notifications, live search results, chat |
| `role` | Widget role when semantic HTML isn't used | Custom components mimicking native behavior |
| `aria-required` | Required field indicator | Form fields without HTML `required` |
| `aria-invalid` | Validation state | Form fields with errors |

</aria_attributes>

<keyboard_navigation>

## Keyboard Navigation

| Requirement | Check | Detection |
|-------------|-------|-----------|
| All interactive elements focusable | Tab reaches every button/link/input | Check for `tabIndex`, custom focus management |
| Logical tab order | Focus follows visual order | Check for positive `tabIndex` values (anti-pattern) |
| Visible focus indicator | Focus ring on keyboard navigation | Check for `outline: none` without replacement |
| Escape closes modals/popups | Keyboard dismiss for overlays | Check modal/dialog for Escape handler |
| Enter/Space activates buttons | Custom elements respond to keyboard | Check `onKeyDown`/`onKeyPress` handlers |
| Arrow keys for lists/menus | Composite widget navigation | Check `role="listbox"`, `role="menu"` keyboard handling |
| Skip navigation link | Jump to main content | Check for skip-nav link as first focusable element |

### Detection

```bash
# Find focus ring removal (anti-pattern)
grep -rn "outline.*none\|outline.*0\|:focus.*outline" --include="*.css" --include="*.scss" --include="*.tsx" src/

# Find custom clickable elements without keyboard handlers
grep -rn "onClick" --include="*.tsx" --include="*.jsx" src/ | grep -v "onKeyDown\|onKeyPress\|button\|<a "

# Find positive tabIndex (anti-pattern)
grep -rn 'tabIndex=["{][1-9]' --include="*.tsx" --include="*.jsx" src/
```

</keyboard_navigation>

<color_contrast>

## Color & Visual Accessibility

| Standard | Ratio | Use For |
|----------|-------|---------|
| WCAG AA Normal Text | 4.5:1 | Body text, labels |
| WCAG AA Large Text | 3:1 | Headings ≥18pt or bold ≥14pt |
| WCAG AAA Normal Text | 7:1 | Enhanced accessibility targets |
| Non-text Contrast | 3:1 | Icons, borders, form controls |

| Concern | Check |
|---------|-------|
| Color-only information | Status indicated only by color without text/icon alternative |
| Insufficient contrast | Light gray text on white, low-contrast placeholder text |
| Motion sensitivity | Animations without `prefers-reduced-motion` check |
| Text over images | Text on variable backgrounds without overlay |

</color_contrast>

<wcag_checklist>

## WCAG 2.1 Quick Checklist

| Principle | Guideline | What ARIA Checks |
|-----------|-----------|-----------------|
| Perceivable | Text alternatives | `alt` on images, `aria-label` on icon buttons |
| Perceivable | Adaptable | Semantic HTML, heading hierarchy |
| Perceivable | Distinguishable | Color contrast, text sizing |
| Operable | Keyboard accessible | All interactive elements keyboard-reachable |
| Operable | Enough time | No auto-advancing without pause control |
| Operable | Seizures | No flashing content |
| Operable | Navigable | Skip links, focus management, page titles |
| Understandable | Readable | Language attribute, clear labels |
| Understandable | Predictable | Consistent navigation, no surprise behavior |
| Understandable | Input assistance | Error identification, labels, suggestions |
| Robust | Compatible | Valid HTML, ARIA roles match behavior |

</wcag_checklist>
