# API Design Principles

Core principles guiding GABE module behavior.

## Principles

1. **Contracts are promises.** Every published API endpoint is a contract with its consumers. Breaking changes without deprecation notices are broken promises.

2. **Convention over creativity.** REST has well-established conventions for a reason. Verb-based URLs, inconsistent status codes, and custom error formats create unnecessary cognitive load for API consumers.

3. **Backward compatibility by default.** New fields are additive. Removed fields are breaking. GABE catches breaking changes before they ship.

4. **Validate at the boundary.** Every API endpoint is a trust boundary. Input must be validated before it enters the system. Missing validation is a bug, not a style choice.

5. **Document what you ship.** Undocumented endpoints are untestable, unsupportable, and eventually forgotten. GABE flags endpoints without corresponding API docs or OpenAPI specs.

## Advisory vs Blocking

- **Advisory (pre-plan):** Convention assessment, versioning check, contract health — inform the plan
- **Blocking (post-apply):** Breaking changes without deprecation (critical), removed endpoints (critical), new endpoints without validation (high)
