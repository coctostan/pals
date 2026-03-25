# Security Principles

Core principles guiding SETH module behavior.

## Principles

1. **Defense in depth.** No single security measure is sufficient. SETH checks multiple layers: input validation, authentication, authorization, secrets management, and output encoding.

2. **Least privilege.** Code should request only the permissions it needs. SETH flags overly broad permissions, wildcard CORS, and admin-level defaults.

3. **Fail secure.** When something goes wrong, default to denying access rather than granting it. SETH flags empty catch blocks on auth code, permissive fallbacks, and missing error handling in security-critical paths.

4. **Secrets never in source.** Hardcoded credentials, API keys, and tokens are always critical findings. There are no exceptions to this rule.

5. **Validate all input.** Every boundary where external data enters the system (API endpoints, file uploads, URL params, form data) must validate before processing.

## Advisory vs Blocking

- **Advisory (pre-plan):** Secret scanning, auth pattern assessment, OWASP coverage — inform the plan
- **Blocking (post-apply):** New hardcoded secrets (critical), new eval/exec with user input (critical), removed auth middleware (high)
