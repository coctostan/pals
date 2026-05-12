<overview>
Advisory resilience pattern reference for in-scope retry/backoff, timeout, error-boundary, shutdown/degradation, circuit-breaker/fallback, and cascading-failure signals. Findings are evidence, not proof of coverage or fault tolerance.
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

### Evidence Checklist

Use retry patterns only for in-scope source/text paths; omit checks without changed-code evidence.

| Check | Evidence |
|-------|----------|
| Retry/backoff marker | changed retry/backoff/max-retry path + `{file}:{line}` |
| Infinite retry risk | changed loop/retry path lacks visible max attempts or break condition |
| Immediate retry | changed retry path has no visible delay/backoff |
| Retry amplification | changed per-request/per-item retry may multiply downstream calls |

Report `WARN` only with cited code evidence and recovery owner; do not infer retry behavior from unrelated files.

</retry_patterns>

<circuit_breaker>

## Circuit Breaker Pattern

| State | Behavior | Transition |
|-------|----------|------------|
| Closed | Requests pass through normally | → Open (after N failures in window) |
| Open | Requests fail immediately (fast fail) | → Half-Open (after timeout period) |
| Half-Open | Limited requests pass through to test | → Closed (success) or → Open (failure) |

| Concern | Evidence |
|---------|----------|
| Circuit-breaker gap | changed external-service path lacks visible failure isolation |
| Timeout gap | changed HTTP/DB/cache call lacks visible timeout/abort handling |
| Cascading-failure risk | changed call chain adds dependency without visible isolation |
| Fallback gap | changed dependency path lacks visible degraded response |

Report `WARN` only with in-scope changed-code or provided-doc evidence and recovery owner; do not infer service topology from unrelated files.

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

### Evidence Checklist

Use error/resilience patterns only for in-scope source/text paths; omit checks without changed-code evidence.

| Check | Evidence |
|-------|----------|
| Generic error | changed throw path loses useful context |
| Swallowed error | changed catch path drops or hides error evidence |
| Error boundary | changed UI boundary path lacks visible fallback/error boundary |
| Global handler | changed process lifecycle path edits crash/shutdown handling |
| Timeout gap | changed external-call path lacks visible timeout/abort handling |
| User-facing error leak | changed response/UI path exposes stack/internal detail |

Report `WARN` only with cited code evidence and recovery owner; do not infer missing boundaries, handlers, or timeouts from unrelated files.

</error_handling_patterns>

<resilience_metrics>

## Resilience Signals

Use these as advisory WARN triggers only with in-scope evidence; do not score resilience health or infer coverage. Each WARN cites `{file}:{line}` or the triggering row.

| Signal | WARN trigger |
|--------|--------------|
| Timeout gap | changed external call lacks visible timeout/abort handling |
| Error-boundary gap | changed UI boundary path lacks visible fallback/error boundary |
| Empty catch block | changed catch block has no visible handling |
| Infinite retry risk | changed loop/retry path lacks visible max attempts or break condition |
| Shutdown gap | changed process lifecycle path lacks visible shutdown/degradation handling |
| Generic error | changed throw path loses useful context |
| Retry gap | changed dependency call with provided retry requirement lacks visible retry/backoff |

</resilience_metrics>
