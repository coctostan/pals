<overview>
Advisory security pattern reference for in-scope secrets, auth/authz changes, validation/injection risks, and OWASP-aligned concerns. Findings are evidence, not proof of coverage or absence.
</overview>

<injection_risks>

## Injection Risks

| Type | Pattern to Detect | Safe Alternative |
|------|------------------|------------------|
| SQL Injection | String concat/template in SQL queries | Parameterized queries, prepared statements, ORM query builders |
| Command Injection | `exec()`, `spawn()`, `system()` with user input | Array-based args (`execFile`), allowlisted commands |
| XSS | `innerHTML`, `dangerouslySetInnerHTML`, `v-html`, unescaped template output | Framework auto-escaping, DOMPurify, CSP headers |
| LDAP Injection | String concat in LDAP queries | Escape special chars, parameterized LDAP filters |
| Template Injection | User input in server-side template strings | Sandboxed templates, logic-less templates (Mustache) |
| Path Traversal | User input in file paths without validation | `path.resolve()` + boundary check, allowlist directories |

### Evidence Checklist

Use the table above as pattern guidance only for in-scope source/text paths; omit checks without changed-code evidence.

| Check | Evidence |
|-------|----------|
| SQL injection risk | changed query construction + `{file}:{line}` |
| Command injection risk | changed execution sink + dynamic-input evidence |
| XSS risk | changed rendering sink + escaping or sanitizer context |
| Interpreter/query/path risk | changed external input flowing into interpreter, query, or path context |

Report `WARN` only with cited code evidence and recovery owner.

</injection_risks>

<auth_patterns>

## Authentication & Authorization

| Pattern | Good | Smell |
|---------|------|-------|
| Password Storage | bcrypt/scrypt/argon2 hashing | MD5, SHA1, plaintext, reversible encryption |
| Session Management | Signed cookies, JWT with short expiry, refresh tokens | Long-lived tokens, session ID in URL, no expiry |
| Authorization | Middleware/decorator guards, RBAC/ABAC | Inline permission checks, role checks in views |
| API Authentication | API keys in headers, OAuth 2.0, mTLS | Keys in URL params, basic auth over HTTP |
| CORS | Specific origin allowlist | `Access-Control-Allow-Origin: *` on authenticated endpoints |
| CSRF | Tokens on state-changing requests, SameSite cookies | No CSRF protection on POST/PUT/DELETE |

</auth_patterns>

<secrets_detection>

## Secrets & Sensitive Data

| Pattern | Marker |
|---------|--------|
| AWS key-like literal | `AKIA[0-9A-Z]{16}` |
| Private key-like block | `-----BEGIN (RSA\|EC\|OPENSSH) PRIVATE KEY-----` |
| Provider token-like literal | `github_pat_\|gh[pousr]_\|xox[baprs]-\|sk_live_\|sk_test_\|AIza[0-9A-Za-z_-]{35}` |
| API key-like assignment | `(api[_-]?key\|apikey)\s*[=:]\s*['"][a-zA-Z0-9]{16,}` |
| Secret/token/password-like assignment | `(secret\|password\|token)\s*[=:]\s*['"][^'"]{8,}` |
| Credentialed connection string | `(mongodb\|postgres\|mysql\|redis):\/\/[^@]+@` |
| JWT-like literal | `eyJ[a-zA-Z0-9_-]+\.eyJ[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+` |

Use markers only on in-scope source/text paths. Report matches as `WARN` with `{file}:{line}`, marker, and recovery owner. Do not search outside scope, claim comprehensive coverage, or infer secrets from unrelated files.

</secrets_detection>

<input_validation>

## Input Validation

| Category | In-scope evidence | Marker examples |
|----------|-------------------|-----------------|
| Schema validation | changed endpoint/body/params handling | Zod, Joi, Pydantic, class-validator, custom validator |
| Authorization | changed access-control boundary | role/permission check, policy guard, ownership check |
| Type coercion | changed coercion/comparison logic | `parseInt` radix, strict equality, enum normalization |
| Bounds checking | changed index/range handling | length checks, numeric limits, guard clauses |
| Encoding | changed user input flowing to HTML/SQL/shell | parameterization, escaping, sanitization |
| CSRF/origin control | changed state-changing web route | CSRF token, same-site cookie, origin/referrer check |
| Deserialization/parsing | changed parser or decoded payload handling | safe parser, schema guard, allowed type list |
| Rate limiting | changed route/middleware boundary | rate-limit middleware or documented control |
| File upload | changed file upload path | file size/type limits, magic-byte validation |

Treat markers as evidence, not proof of coverage. Omit rows without in-scope changed-code or provided-doc evidence.

</input_validation>

<owasp_top10>

## OWASP Top 10 Quick Reference

Use OWASP labels only for in-scope evidence; omit rows without changed-code, changed-config, dependency-metadata, or provided-doc support.

| # | Risk | Evidence |
|---|------|----------|
| A01 | Broken Access Control | changed auth/authz boundary, ownership check, policy guard |
| A02 | Cryptographic Failures | changed secret handling, weak crypto marker, sensitive transport issue |
| A03 | Injection | changed SQL/command/template/rendering sink |
| A04 | Insecure Design | changed rate-limit, validation, or abuse-control boundary |
| A05 | Security Misconfiguration | changed debug/default/verbose-error config |
| A06 | Vulnerable Components | DEAN owns dependency audit; cite only changed dependency metadata |
| A07 | Auth Failures | changed session, credential, MFA, or login-flow evidence |
| A08 | Data Integrity Failures | changed signature, verification, or deserialization boundary |
| A09 | Logging Failures | changed sensitive logging or audit-event boundary |
| A10 | SSRF | changed server-side URL fetch or URL validation path |

</owasp_top10>
