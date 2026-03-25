<overview>
Security pattern detection and vulnerability classification for SETH. Covers OWASP Top 10, code-level security concerns, and auth pattern validation.
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

### Detection Commands

```bash
# Find potential SQL injection (string concat in queries)
grep -rn "query.*\`\|query.*+\|execute.*+" --include="*.ts" --include="*.js" --include="*.py" src/

# Find dangerous eval/exec usage
grep -rn "eval(\|exec(\|execSync(\|Function(" --include="*.ts" --include="*.js" src/

# Find innerHTML/dangerouslySetInnerHTML
grep -rn "innerHTML\|dangerouslySetInnerHTML\|v-html" --include="*.tsx" --include="*.jsx" --include="*.vue" src/
```

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

| Pattern | Regex/Detection | Severity |
|---------|----------------|----------|
| AWS Keys | `AKIA[0-9A-Z]{16}` | Critical |
| Private Keys | `-----BEGIN (RSA\|EC\|OPENSSH) PRIVATE KEY-----` | Critical |
| Generic API Keys | `(api[_-]?key\|apikey)\s*[=:]\s*['"][a-zA-Z0-9]{16,}` | High |
| Generic Secrets | `(secret\|password\|token)\s*[=:]\s*['"][^'"]{8,}` | High |
| Connection Strings | `(mongodb\|postgres\|mysql\|redis):\/\/[^@]+@` | High |
| JWT Tokens | `eyJ[a-zA-Z0-9_-]+\.eyJ[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+` | Medium |
| IP Addresses (internal) | `(10\|172\.(1[6-9]\|2[0-9]\|3[01])\|192\.168)\.\d+\.\d+` | Low |

### Detection Command

```bash
# Comprehensive secret scan
grep -rn "AKIA\|BEGIN.*PRIVATE KEY\|api[_-]\?key.*=\|password.*=.*['\"]" \
  --include="*.ts" --include="*.js" --include="*.py" --include="*.yaml" --include="*.yml" \
  --include="*.json" --include="*.env" --include="*.toml" \
  --exclude-dir=node_modules --exclude-dir=.git src/ .
```

</secrets_detection>

<input_validation>

## Input Validation

| Category | What to Check | Tool/Method |
|----------|--------------|-------------|
| Schema Validation | API endpoints accepting unvalidated body/params | Check for Zod, Joi, Pydantic, class-validator usage |
| Type Coercion | `parseInt` without radix, `==` instead of `===` | ESLint rules: eqeqeq, radix |
| Bounds Checking | Array access without length check, numeric overflow | Manual review of index access patterns |
| Encoding | User input passed to HTML/SQL/shell without encoding | Check for parameterization, escaping, sanitization |
| Rate Limiting | Endpoints without rate limiting | Check for rate-limit middleware (express-rate-limit, etc.) |
| File Upload | Accepting files without type/size validation | Check for multer limits, magic byte validation |

</input_validation>

<owasp_top10>

## OWASP Top 10 Quick Reference

| # | Risk | What SETH Checks |
|---|------|-----------------|
| A01 | Broken Access Control | Missing auth middleware, direct object references |
| A02 | Cryptographic Failures | Weak hashing, hardcoded secrets, HTTP for sensitive data |
| A03 | Injection | SQL, command, XSS, template injection patterns |
| A04 | Insecure Design | Missing rate limiting, no input validation |
| A05 | Security Misconfiguration | Debug mode in prod, default credentials, verbose errors |
| A06 | Vulnerable Components | (Covered by DEAN module) |
| A07 | Auth Failures | Weak passwords, missing MFA hooks, session issues |
| A08 | Data Integrity Failures | Unsigned updates, unverified deserialization |
| A09 | Logging Failures | Sensitive data in logs, no audit trail |
| A10 | SSRF | Unvalidated URLs in server-side requests |

</owasp_top10>
