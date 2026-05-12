<overview>
Advisory observability pattern reference for in-scope logging, health/readiness, error handling, sensitive logs, and alert/error tracking. Findings are evidence, not proof of coverage or readiness.
</overview>

<logging_patterns>

## Logging Patterns

| Pattern | Good | Smell |
|---------|------|-------|
| Structured logging | `logger.info({ userId, action, duration })` | `console.log("user " + id + " did " + action)` |
| Log levels | DEBUG/INFO/WARN/ERROR used appropriately | Everything at `console.log` or all ERROR |
| Context propagation | Request ID, trace ID, correlation ID in logs | No request context, impossible to trace flows |
| Sensitive data filtering | PII redacted, tokens masked | Passwords, tokens, emails in plain text logs |
| Error context | Error logged with stack trace, request context | `catch(e) { console.log(e) }` |
| Performance logging | Request duration, DB query time logged | No timing data, blind to slow requests |

### Evidence Checklist

Use logging patterns only for in-scope source/text paths; omit checks without changed-code evidence.

| Check | Evidence |
|-------|----------|
| Console logging | changed logging call + `{file}:{line}` |
| Structured logging | visible logger marker plus request/error context |
| Sensitive log data | changed log includes secret/PII/token-like data |
| Error context | changed catch/error path logs or propagates context |
| Performance logging | changed timing/latency marker |

Report `WARN` only with cited code evidence and recovery owner.

</logging_patterns>

<health_checks>

## Health Check Patterns

| Type | Purpose | Implementation |
|------|---------|---------------|
| Liveness | "Is the process running?" | `GET /health` → 200 (always, if process alive) |
| Readiness | "Can it handle requests?" | `GET /health/ready` → check DB, cache, dependencies |
| Startup | "Has it finished initializing?" | `GET /health/startup` → check initialization complete |
| Deep | "Are all dependencies healthy?" | `GET /health/deep` → check each dependency with timeout |

| Concern | Evidence |
|---------|----------|
| Missing health/readiness route | current diff changes or removes an in-scope health/readiness path |
| Missing dependency check | changed readiness/deep success path lacks visible dependency check |
| Missing timeout handling | changed health dependency call lacks visible timeout/abort handling |
| Expensive health work | changed health path triggers expensive computation or external work |

Report health concerns only from changed code or provided docs; omit rows without in-scope evidence.

</health_checks>

<error_tracking>

## Error Tracking & Handling

| Pattern | Good | Smell |
|---------|------|-------|
| Global error handler | Uncaught exception handler, unhandled rejection handler | No global handler, process crashes silently |
| Error classification | Operational vs programmer errors distinguished | All errors treated the same |
| Error reporting | Errors sent to tracking service (Sentry, Datadog, etc.) | Errors only in local logs |
| Retry with backoff | Transient errors retried with exponential backoff | Immediate retry or no retry |
| Circuit breaker | Failed dependencies circuit-broken | Retry forever, cascading failures |
| Error response format | Consistent error shape, no stack traces in prod | Stack traces leaked to clients, inconsistent format |

### Evidence Checklist

Use error patterns only for in-scope source/text paths; omit checks without changed-code evidence.

| Check | Evidence |
|-------|----------|
| Empty catch | changed catch block has no visible handling |
| Swallowed error | changed catch/error path drops error without visible handling |
| Process handler | changed process lifecycle handler |
| Error reporting | changed reporting sink or local-only handling |
| Client error leak | changed response path exposes stack/internal details |

Report `WARN` only with cited code evidence and recovery owner.

</error_tracking>

<monitoring_readiness>

## Monitoring & Alerting Signals

Use these as advisory WARN triggers only with in-scope evidence; each WARN cites `{file}:{line}` or the triggering row.

| Signal | WARN trigger |
|--------|--------------|
| Console logging | changed production path adds console logging |
| Empty catch blocks | changed catch block has no visible handling |
| Health/readiness change | current diff changes or removes an in-scope health/readiness path |
| Sensitive data in logs | changed log includes secret/PII/token-like data |
| Structured logging gap | changed logging path lacks visible structure/context |
| Process error handling | changed process lifecycle path lacks visible recovery/reporting |

</monitoring_readiness>
