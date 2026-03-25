# Observability Principles

Core principles guiding OMAR module behavior.

## Principles

1. **You can't fix what you can't see.** Production issues without logs, metrics, or traces are black boxes. OMAR ensures code is observable before it ships.

2. **Structured logging is not optional.** `console.log` is for debugging, not production. Structured logs (JSON, key-value) are searchable, filterable, and alertable. OMAR flags unstructured logging in production code.

3. **Every error needs context.** A stack trace alone doesn't explain what the user was doing, what data was involved, or how to reproduce. OMAR checks that errors include request context and meaningful messages.

4. **Health checks are contracts.** Orchestrators (Kubernetes, load balancers) rely on health endpoints. A missing or broken health check means silent failures and zombie processes.

5. **Never log secrets.** Passwords, tokens, API keys, and PII must never appear in logs. OMAR flags sensitive data patterns in logging statements.

## Advisory vs Blocking

- **Advisory (pre-plan):** Logging assessment, health check inventory, error handling audit — inform the plan
- **Blocking (post-apply):** Sensitive data in logs (critical), new empty catch blocks (high), removed health endpoints (high)
