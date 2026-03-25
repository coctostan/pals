# Resilience Principles

Core principles guiding REED module behavior.

## Principles

1. **Everything fails eventually.** Networks drop, databases timeout, services crash. Resilient code assumes failure and handles it gracefully. REED checks that external calls have timeouts, retries, and fallbacks.

2. **Fail fast, recover fast.** Circuit breakers prevent cascading failures by failing immediately when a dependency is down. Waiting for timeouts on every request multiplies latency.

3. **Retries must be bounded and smart.** Infinite retries cause thundering herds. Retrying 400 errors wastes resources. REED flags unbounded retries and non-selective retry logic.

4. **Graceful degradation over hard failure.** A slow recommendation engine should return cached results, not crash the product page. REED checks for fallback patterns on non-critical paths.

5. **Shutdown is a feature.** Graceful shutdown (drain connections, finish in-flight work, close cleanly) prevents data corruption and dropped requests. REED flags missing shutdown handlers in server applications.

## Advisory vs Blocking

- **Advisory (pre-plan):** Timeout coverage, retry pattern audit, error handling assessment — inform the plan
- **Blocking (post-apply):** New infinite retry loop (critical), removed error boundary (high), external call without timeout in server code (high)
