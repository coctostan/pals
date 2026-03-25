<overview>
Observability pattern detection and logging health validation for OMAR. Covers structured logging, error tracking, health checks, monitoring patterns, and alerting readiness.
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

### Detection

```bash
# Find console.log usage (should use structured logger)
grep -rn "console\.log\|console\.error\|console\.warn" --include="*.ts" --include="*.js" src/

# Find logging without context
grep -rn "logger\.\|log\.\|winston\|pino\|bunyan" --include="*.ts" --include="*.js" src/

# Find potential sensitive data in logs
grep -rn "console.*password\|log.*token\|log.*secret\|log.*apiKey" --include="*.ts" --include="*.js" src/
```

</logging_patterns>

<health_checks>

## Health Check Patterns

| Type | Purpose | Implementation |
|------|---------|---------------|
| Liveness | "Is the process running?" | `GET /health` → 200 (always, if process alive) |
| Readiness | "Can it handle requests?" | `GET /health/ready` → check DB, cache, dependencies |
| Startup | "Has it finished initializing?" | `GET /health/startup` → check initialization complete |
| Deep | "Are all dependencies healthy?" | `GET /health/deep` → check each dependency with timeout |

| Concern | Check |
|---------|-------|
| Missing health endpoint | No `/health` or `/healthz` route |
| No dependency checks | Health returns 200 without checking DB/cache |
| Timeout handling | Health check hangs if dependency is down |
| Health check does work | Health endpoint triggers computation (should be cheap) |

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

### Detection

```bash
# Find unhandled error patterns
grep -rn "catch.*{.*}" --include="*.ts" --include="*.js" src/ | grep -v "console\|log\|throw\|return"

# Find empty catch blocks
grep -rn "catch.*{[[:space:]]*}" --include="*.ts" --include="*.js" src/

# Find process crash handlers
grep -rn "uncaughtException\|unhandledRejection\|process.on" --include="*.ts" --include="*.js" src/
```

</error_tracking>

<monitoring_readiness>

## Monitoring & Alerting Readiness

| Metric | Healthy | Warning | Critical |
|--------|---------|---------|----------|
| console.log in production code | 0 | 1-5 | >5 |
| Empty catch blocks | 0 | 1-2 | >2 |
| Missing health endpoint | 0 | 0 | 1 (if server app) |
| Sensitive data in logs | 0 | 0 | >0 |
| No structured logger | N/A | 1 (small project) | 1 (any server app) |
| Missing error boundary (React) | 0 | 1 | >1 |
| No global error handler (server) | 0 | 0 | 1 |

</monitoring_readiness>
