<overview>
Resilience pattern detection and error handling validation for REED. Covers retry patterns, circuit breakers, graceful degradation, timeout handling, and fault tolerance.
</overview>

<retry_patterns>

## Retry Patterns

| Pattern | Good | Smell |
|---------|------|-------|
| Exponential backoff | `delay = baseDelay * 2^attempt` | Fixed delay retry, immediate retry |
| Max retries | Retry limit (3-5 typical) | Infinite retry loops |
| Jitter | Random offset to prevent thundering herd | All retries at exact same intervals |
| Idempotency | Safe to retry (GET, PUT with same data) | Retrying non-idempotent POST without guard |
| Retry budget | Global retry rate limit | Each caller retries independently, multiplying load |
| Selective retry | Only retry transient errors (5xx, timeout) | Retry 4xx errors (won't help) |

### Detection

```bash
# Find retry patterns
grep -rn "retry\|Retry\|backoff\|maxRetries\|retryCount" --include="*.ts" --include="*.js" --include="*.py" src/

# Find infinite loops that might be retry loops
grep -rn "while.*true\|for.*;;)" --include="*.ts" --include="*.js" src/
```

</retry_patterns>

<circuit_breaker>

## Circuit Breaker Pattern

| State | Behavior | Transition |
|-------|----------|------------|
| Closed | Requests pass through normally | → Open (after N failures in window) |
| Open | Requests fail immediately (fast fail) | → Half-Open (after timeout period) |
| Half-Open | Limited requests pass through to test | → Closed (success) or → Open (failure) |

| Concern | Check |
|---------|-------|
| Missing circuit breaker | External service calls without failure isolation |
| No timeout | HTTP/DB calls without timeout configuration |
| Cascading failure risk | Service A → B → C, no isolation between |
| Missing fallback | No degraded response when dependency fails |

</circuit_breaker>

<graceful_degradation>

## Graceful Degradation

| Pattern | Good | Smell |
|---------|------|-------|
| Fallback responses | Cache, default, or partial response on failure | Hard failure, 500 error |
| Feature flags | Non-critical features can be disabled | All-or-nothing deployment |
| Bulkhead isolation | Thread/connection pools per dependency | Shared pool, one slow dep blocks all |
| Timeouts everywhere | HTTP, DB, cache calls have timeouts | Default/infinite timeouts |
| Graceful shutdown | Drain connections, finish in-flight requests | Kill -9, dropped connections |
| Load shedding | Reject excess load with 503 | Accept all load, crash under pressure |

</graceful_degradation>

<error_handling_patterns>

## Error Handling Patterns

| Pattern | Good | Smell |
|---------|------|-------|
| Error hierarchy | Custom error classes with context | Generic `Error` or string throws |
| Operational vs Programmer | Distinguish expected vs unexpected errors | All errors handled the same way |
| Error boundaries (React) | `ErrorBoundary` wrapping feature sections | No boundaries, white screen on error |
| Global handler | Process-level uncaught exception handler | No handler, silent crashes |
| Error propagation | Errors wrapped with context as they bubble up | Error swallowed, generic re-throw |
| User-facing errors | Friendly messages, actionable guidance | Stack traces, technical jargon, "Something went wrong" |

### Detection

```bash
# Find throw statements (check for custom vs generic errors)
grep -rn "throw new Error\|throw new " --include="*.ts" --include="*.js" src/

# Find catch blocks (check for proper handling)
grep -rn "catch\s*(" --include="*.ts" --include="*.js" src/

# Find timeout configuration
grep -rn "timeout\|Timeout\|TIMEOUT" --include="*.ts" --include="*.js" src/
```

</error_handling_patterns>

<resilience_metrics>

## Resilience Health

| Metric | Healthy | Warning | Critical |
|--------|---------|---------|----------|
| External calls without timeout | 0 | 1-2 | >2 |
| Missing error boundaries (React) | 0 | 1 | >1 |
| Empty catch blocks | 0 | 1-2 | >2 |
| Infinite retry patterns | 0 | 0 | >0 |
| No graceful shutdown handler | 0 | 0 | 1 (server app) |
| Generic Error throws | <30% | 30-60% | >60% |
| External calls without retry | OK (simple apps) | Warning (microservices) | Critical (distributed) |

</resilience_metrics>
