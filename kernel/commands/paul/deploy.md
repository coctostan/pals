---
name: pals:deploy
description: Audit, generate, and verify CI/CD pipelines and deployments
argument-hint: "[audit|generate|verify]"
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep]
---

<objective>
Audit existing CI/CD pipelines, generate new pipeline configurations, or run post-deploy
verification checks for the current project.

**When to use:** To check pipeline health, create CI/CD from scratch, or verify a deployment.

**DAVE integration:** Uses DAVE's pipeline-generation.md and deploy-verification.md references.
</objective>

<execution_context>
@~/.pals/modules/dave/references/pipeline-generation.md
@~/.pals/modules/dave/references/deploy-verification.md
</execution_context>

<context>
Mode: $ARGUMENTS (optional — "audit", "generate", "verify")

Project working directory.
</context>

<process>

<step name="determine_mode">
**Determine operating mode from arguments.**

1. If $ARGUMENTS is empty or not provided:
   - Mode: **dashboard**
2. If $ARGUMENTS is "audit":
   - Mode: **audit**
3. If $ARGUMENTS is "generate":
   - Mode: **generate**
4. If $ARGUMENTS is "verify":
   - Mode: **verify**
5. Otherwise:
   - Treat as search/query within deploy context
</step>

<step name="detect_project">
**Detect project structure and existing CI/CD.**

1. Scan for CI/CD configuration files:
   - `.github/workflows/*.yml` or `.github/workflows/*.yaml` (GitHub Actions)
   - `.gitlab-ci.yml` (GitLab CI)
   - `.circleci/config.yml` (CircleCI)
   - `Jenkinsfile` (Jenkins)

2. Scan for language/framework indicators:
   - Use detection heuristics from @~/.pals/modules/dave/references/pipeline-generation.md
   - Record: language, package manager, framework, build tool

3. Store detection results for use in subsequent steps.
</step>

<step name="mode_dashboard">
**Mode: Dashboard (no arguments)**

1. If no CI/CD configs found:
   ```
   ════════════════════════════════════════
   DAVE — Deployment Dashboard
   ════════════════════════════════════════

   Pipelines: None detected

   DAVE helps you build and maintain CI/CD pipelines:
   - Audit existing pipeline configurations
   - Generate new pipelines from project structure
   - Verify deployments with smoke tests

   Detected Project:
     Language: [detected or "unknown"]
     Framework: [detected or "none"]
     Package Manager: [detected or "none"]

   ────────────────────────────────────────
   Get started:
     /paul:deploy generate   — Create a pipeline config
     /paul:deploy audit      — Validate existing configs
     /paul:deploy verify     — Post-deploy verification
   ────────────────────────────────────────
   ```

2. If CI/CD configs found:
   ```
   ════════════════════════════════════════
   DAVE — Deployment Dashboard
   ════════════════════════════════════════

   Detected Pipelines:
     [platform] — [config path]
     Workflows: [list of workflow names]

   Project:
     Language: [detected]
     Framework: [detected or "none"]
     Package Manager: [detected]

   ────────────────────────────────────────
   Usage:
     /paul:deploy audit      — Validate pipeline configs
     /paul:deploy generate   — Generate new/additional pipeline
     /paul:deploy verify     — Post-deploy verification
   ────────────────────────────────────────
   ```
</step>

<step name="mode_audit">
**Mode: Audit (argument is "audit")**

1. For each detected CI/CD config file:
   - Read the file
   - Check for common issues:

   **Structure checks:**
   - [ ] Trigger events defined (on push/PR/tag)
   - [ ] Branch filtering configured
   - [ ] Jobs have clear names
   - [ ] Steps are ordered correctly (lint before test before build)

   **Security checks:**
   - [ ] Actions/images pinned to versions (not `latest`)
   - [ ] No hardcoded secrets
   - [ ] Permissions scoped appropriately
   - [ ] Branch protection implied by workflow triggers

   **Performance checks:**
   - [ ] Dependency caching configured
   - [ ] Parallel stages where possible
   - [ ] Artifacts configured for build outputs
   - [ ] Timeouts set to prevent runaway jobs

   **Best practice checks:**
   - [ ] Separate lint/test/build stages
   - [ ] Matrix testing if multi-version support
   - [ ] Fail-fast enabled for matrix builds

2. Display results:
   ```
   ════════════════════════════════════════
   DAVE — Pipeline Audit
   ════════════════════════════════════════

   [config path]:
     Structure:  [N/M checks passed]
     Security:   [N/M checks passed]
     Performance:[N/M checks passed]
     Best Practices: [N/M checks passed]

     Issues:
       [severity] [description]
       [severity] [description]

     Suggestions:
       [suggestion]
       [suggestion]
   ────────────────────────────────────────
   ```

3. If no CI/CD configs found:
   - Display helpful message suggesting `/paul:deploy generate`
</step>

<step name="mode_generate">
**Mode: Generate (argument is "generate")**

1. Using detected project structure from detect_project step:
   - Determine language, package manager, framework
   - Select appropriate template from @~/.pals/modules/dave/references/pipeline-generation.md

2. Ask user to confirm:
   ```
   DAVE detected:
     Language: [language]
     Package Manager: [pm]
     Framework: [framework or "none"]
     Target Platform: [GitHub Actions / GitLab CI]

   Pipeline will include:
     - Lint stage
     - Test stage
     - Build stage

   Generate this pipeline? (yes/no)
   ```

3. On confirmation:
   - Fill template with project-specific commands
   - Detect lint/test/build commands from project config (package.json scripts, pyproject.toml, etc.)
   - Write pipeline config to correct location
   - Display generated file path and contents summary

4. If project structure unclear:
   - Ask user for language/framework/platform preferences
   - Then generate accordingly
</step>

<step name="mode_verify">
**Mode: Verify (argument is "verify")**

1. Ask for deployment context:
   ```
   What are you verifying?

   [1] Local build (verify build succeeds)
   [2] Staging deployment (smoke tests)
   [3] Production deployment (full verification)
   [4] Custom URL (specify endpoint)
   ```

2. Based on selection, use checklists from
   @~/.pals/modules/dave/references/deploy-verification.md:

   - **Local build:** Run build command, check for errors
   - **Staging:** Health check + smoke test checklist
   - **Production:** Full verification checklist with rollback criteria
   - **Custom:** Health check against provided URL

3. Display results:
   ```
   ════════════════════════════════════════
   DAVE — Deploy Verification
   ════════════════════════════════════════

   Environment: [env]
   Target: [url or "local"]

   Checks:
     [✓/✗] Health endpoint responds
     [✓/✗] Response time within baseline
     [✓/✗] No error spike detected
     [✓/✗] Critical path functional

   Result: [PASS / FAIL — action needed]
   ────────────────────────────────────────
   ```
</step>

</process>

<output>
- Dashboard: CI/CD overview with detected pipelines and project info
- Audit: validation report with issues and suggestions
- Generate: new pipeline configuration file written to project
- Verify: post-deploy verification results with pass/fail status
</output>
