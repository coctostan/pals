# Deploy Verification

Post-deploy smoke tests, health checks, and rollback criteria for safe deployments.

## Smoke Test Patterns

### HTTP Health Checks

The simplest and most universal verification — hit an endpoint, expect a healthy response.

| Check Type | What It Tests | Example |
|------------|--------------|---------|
| **Basic** | App is running and responding | `GET /health` → 200 |
| **Deep** | App + dependencies are healthy | `GET /health/deep` → 200 with dependency status |
| **Version** | Correct version is deployed | `GET /version` → `{"version": "1.2.3"}` |

### Basic Health Check

```bash
# Simple: is the app responding?
curl -sf https://app.example.com/health || echo "FAILED"

# With timeout and retries:
for i in 1 2 3 4 5; do
  if curl -sf --max-time 5 https://app.example.com/health; then
    echo "Health check passed"
    break
  fi
  echo "Attempt $i failed, retrying in 10s..."
  sleep 10
done
```

### Deep Health Check

Tests connectivity to all dependencies:

```json
{
  "status": "healthy",
  "checks": {
    "database": { "status": "healthy", "latency_ms": 12 },
    "cache": { "status": "healthy", "latency_ms": 2 },
    "external_api": { "status": "healthy", "latency_ms": 45 }
  }
}
```

Any dependency unhealthy → overall status unhealthy → investigate before proceeding.

### Critical Path Tests

Beyond health checks, verify core user flows work:

| Flow | Test |
|------|------|
| Authentication | Can a user log in? |
| Core API | Does the main endpoint return expected data? |
| Database writes | Can the app write and read back? |
| External integrations | Are webhooks/callbacks functioning? |

## Rollback Criteria

### Automatic Rollback Triggers

Roll back immediately (no human decision needed) when:

| Signal | Threshold | Action |
|--------|-----------|--------|
| Health check failure | 3 consecutive failures | Rollback |
| Error rate spike | >5% of requests erroring (vs <1% baseline) | Rollback |
| Latency spike | p95 latency >3x baseline | Rollback |
| CPU/Memory spike | >90% sustained for 5 minutes | Rollback |

### Manual Rollback Triggers

Investigate and decide when:

| Signal | Observation | Action |
|--------|------------|--------|
| Degraded performance | Latency increased but within bounds | Investigate |
| Partial feature failure | Non-critical feature broken | Assess impact |
| User reports | Complaints about specific flows | Verify and decide |

### Rollback Procedures

1. **Revert deployment** — redeploy previous known-good version
2. **Verify rollback** — run same health checks against rolled-back version
3. **Notify team** — alert that rollback occurred with reason
4. **Post-mortem** — investigate what went wrong before re-attempting

## Verification by Environment

| Environment | Verification Level | Automation |
|-------------|-------------------|------------|
| **Development** | Basic health check | Fully automated |
| **Staging** | Health check + smoke test suite | Automated, notify on failure |
| **Production** | Health check + smoke + canary metrics | Automated checks, human approval for full rollout |

### Staging Verification Checklist

```
Post-deploy to staging:
- [ ] Health endpoint returns 200
- [ ] Deep health check passes (all dependencies)
- [ ] Login flow works
- [ ] Core API returns expected data
- [ ] No new errors in error tracking
- [ ] Performance within baseline (±20%)
```

### Production Verification Checklist

```
Post-deploy to production:
- [ ] Health endpoint returns 200
- [ ] Deep health check passes
- [ ] Error rate stable (no spike)
- [ ] Latency stable (no spike)
- [ ] Critical path smoke tests pass
- [ ] Monitoring dashboards nominal
- [ ] Deploy notification sent to team
```

## Canary Deployments

For high-traffic production services:

1. Deploy new version to small percentage of traffic (5-10%)
2. Monitor error rates and latency for canary vs baseline
3. If healthy after observation period (15-30 min): increase to 50%, then 100%
4. If unhealthy: route all traffic back to old version

## Notification Templates

### Deploy Started
```
🚀 Deploy started
Environment: {env}
Version: {version}
Triggered by: {user}
Changes: {commit_range}
```

### Deploy Succeeded
```
✅ Deploy succeeded
Environment: {env}
Version: {version}
Duration: {duration}
Health: All checks passing
```

### Deploy Failed / Rolled Back
```
❌ Deploy failed — rolled back
Environment: {env}
Version: {version}
Reason: {failure_reason}
Rolled back to: {previous_version}
Action needed: Investigate before re-attempting
```
