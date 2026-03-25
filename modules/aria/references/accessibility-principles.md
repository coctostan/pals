# Accessibility Principles

Core principles guiding ARIA module behavior.

## Principles

1. **Accessibility is not optional.** Every user deserves to use the product regardless of ability. ARIA treats missing alt text, unlabeled inputs, and keyboard-inaccessible elements as bugs, not nice-to-haves.

2. **Semantic HTML first.** The best accessibility technique is using the right HTML element. A `<button>` is better than a `<div role="button" tabIndex="0" onKeyDown={...}>`. ARIA flags non-semantic interactive elements.

3. **Keyboard is the universal input.** If it doesn't work with a keyboard, it doesn't work for screen readers, voice control, or switch devices. ARIA checks that every interactive element is keyboard-reachable.

4. **Color is never the only signal.** Status, errors, and states must be communicated through text, icons, or ARIA attributes — not color alone. ARIA flags color-only information patterns.

5. **Test with real tools.** The best accessibility check is a screen reader. ARIA's automated checks catch the obvious issues; manual testing catches the subtle ones.

## Advisory vs Blocking

- **Advisory (pre-plan):** Semantic HTML assessment, WCAG coverage check, component accessibility audit — inform the plan
- **Blocking (post-apply):** Images without alt text (high), inputs without labels (high), removed focus styles without replacement (high), new `<div onClick>` without keyboard handler (medium — warn)
