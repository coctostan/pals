# Deploy Verification

Post-deploy smoke tests, health checks, and rollback criteria.

## Health Checks

| Type | Purpose | Example |
|------|---------|---------|
| Basic | App responding | `GET /health` → 200 |
| Deep | App + dependencies healthy | `GET /health/deep` → 200 with dep status |
| Version | Correct version deployed | `GET /version` → `{"version": "1.2.3"}` |

```bash
# Health check with retries
for i in 1 2 3 4 5; do
  curl -sf --max-time 5 https://app.example.com/health && break
  echo "Attempt $i failed, retrying in 10s..." && sleep 10
done
```

## Critical Path Tests

| Flow | Test |
|------|------|
| Auth | Can a user log in? |
| Core API | Main endpoint returns expected data? |
| DB writes | Write and read back? |
| Integrations | Webhooks/callbacks functioning? |

## Rollback Criteria

### Automatic (no human decision)

| Signal | Threshold |
|--------|-----------|
| Health check failure | 3 consecutive |
| Error rate spike | >5% (vs <1% baseline) |
| Latency spike | p95 >3x baseline |
| Resource spike | >90% CPU/mem sustained 5min |

### Manual (investigate first)

Degraded performance within bounds, partial feature failure, user reports.

### Rollback Procedure (follow this order)
1. **Revert** — redeploy previous known-good version immediately
2. **Verify** — run same health checks against rolled-back version
3. **Notify** — alert team with reason for rollback
4. **Post-mortem** — investigate root cause before re-attempting deploy

## Verification by Environment

| Environment | Level | Automation |
|-------------|-------|------------|
| Development | Basic health | Fully automated |
| Staging | Health + smoke suite | Automated, notify on failure |
| Production | Health + smoke + canary | Automated checks, human approval for full rollout |

**Staging checklist:** Health 200, deep health, login flow, core API, no new errors, perf within ±20%.

**Production checklist:** Health 200, deep health, error rate stable, latency stable, smoke tests pass, dashboards nominal, notification sent.

## Canary Deployments

1. Deploy to 5-10% of traffic
2. Monitor error rates + latency vs baseline (15-30 min)
3. Healthy → increase to 50%, then 100%
4. Unhealthy → route all back to old version

## Notification Templates

**Started:** Environment, version, triggered by, changes.
**Succeeded:** Environment, version, duration, health status.
**Failed/Rolled back:** Environment, version, reason, rolled-back-to version, action needed.
