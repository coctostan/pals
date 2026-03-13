# Deploy Principles

DAVE ensures projects have reliable, automated deployment pipelines that catch issues early and deploy safely.

## CI/CD Philosophy

### Core Tenets

1. **Automate everything.** Manual deployment steps are errors waiting to happen. Every step from commit to production should be scripted.
2. **Fail fast.** Run the cheapest checks first (lint, types) before expensive ones (integration tests, builds). A failing lint check should never wait behind a 10-minute test suite.
3. **Deploy small.** Smaller changes are easier to review, test, deploy, and roll back. Prefer frequent small deploys over infrequent large ones.
4. **Rollback fast.** Every deployment should be reversible within minutes. If you can't roll back quickly, you can't deploy safely.
5. **Immutable artifacts.** Build once, deploy everywhere. The same artifact that passed staging should go to production — never rebuild for prod.

## Pipeline Patterns

### Standard Stages

```
Commit → Lint → Test → Build → Deploy(staging) → Verify → Deploy(prod) → Verify
```

| Stage | Purpose | Typical Duration |
|-------|---------|-----------------|
| **Lint** | Code style, formatting, static analysis | 30s - 2min |
| **Test** | Unit tests, integration tests | 1min - 10min |
| **Build** | Compile, bundle, create artifacts | 1min - 5min |
| **Deploy** | Push artifacts to target environment | 30s - 5min |
| **Verify** | Smoke tests, health checks | 30s - 2min |

### Parallelization

Run independent stages concurrently:

```
         ┌─ Lint ──────┐
Commit ──┤             ├─ Build ─ Deploy ─ Verify
         └─ Test ──────┘
```

Lint and test have no dependency on each other — run in parallel.

### Branch Strategy

| Branch | Pipeline Behavior |
|--------|------------------|
| Feature branches | Lint + Test only (no deploy) |
| `main` / `develop` | Lint + Test + Build + Deploy to staging |
| Release tags | Full pipeline including production deploy |
| Pull requests | Lint + Test + Build (no deploy, verify build works) |

## Environment Strategy

| Environment | Deploy Trigger | Approval | Purpose |
|-------------|---------------|----------|---------|
| **Development** | Auto on push to dev branch | None | Developer testing |
| **Staging** | Auto on merge to main | None | Integration testing, QA |
| **Production** | Manual trigger or release tag | Required | Live users |

### Environment Parity

Staging should mirror production as closely as possible:
- Same runtime versions
- Same environment variable structure (different values)
- Same infrastructure topology (scaled down)
- Same monitoring and alerting

## Deployment Types

### Continuous Delivery (CD)
- Every commit to main is *deployable* but not automatically deployed to production
- Production deploy requires manual trigger (button push, tag creation)
- Best for: teams new to CI/CD, regulated environments, apps needing manual QA

### Continuous Deployment
- Every commit to main automatically deploys to production (after passing all checks)
- No manual gates between merge and production
- Best for: mature teams, high test coverage, feature-flagged releases

## Security

### Secrets Management
- Never hardcode secrets in pipeline configs
- Use platform-native secret stores (GitHub Secrets, GitLab CI/CD Variables)
- Rotate secrets on a schedule
- Scope secrets to environments (staging secrets separate from production)

### Pipeline Security
- Pin action/image versions to SHA hashes, not tags
- Use least-privilege service accounts for deployments
- Enable branch protection on main/production branches
- Require PR reviews before merge to deploy branches

## Observability

### Deploy Notifications
- Notify team on deploy start, success, and failure
- Include: who triggered, what changed (commit range), target environment
- Channels: Slack, email, or team chat integration

### Metrics to Track
- Deploy frequency (how often)
- Lead time (commit to production)
- Change failure rate (deploys causing incidents)
- Mean time to recovery (time to roll back or fix)
