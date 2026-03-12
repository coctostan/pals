---
phase: 13-driver-architecture
topic: Driver extraction strategy and Agent SDK integration
depth: standard
confidence: HIGH
created: 2026-03-12
---

# Discovery: Driver Architecture & Agent SDK Stub

**Recommendation:** Extract Claude Code driver from install.sh, create Agent SDK driver stub using `claude-agent-sdk` package's `query()` API with workflow markdown as system prompts.

**Confidence:** HIGH — Agent SDK is GA (v0.1.48), API surface is well-documented, and DRIVER-SPEC.md already maps cleanly to the SDK's capabilities.

## Objective

What we needed to learn before planning:
- How does the Anthropic Agent SDK work and what's its API surface?
- How should we practically extract the Claude Code driver from install.sh?
- Can the kernel run headless (no slash commands)?
- What does a `drivers/` directory structure look like?

## Scope

**Include:**
- Agent SDK API surface and integration patterns
- Claude Code driver extraction from current install.sh
- Driver directory structure
- Headless kernel proof approach

**Exclude:**
- Full Agent SDK orchestrator implementation (stub only)
- Database-backed state backends
- Third-party driver implementations (Codex, OpenCode, etc.)

## Findings

### Option A: Agent SDK Driver via `query()` API

**Source:** Anthropic Agent SDK docs, PyPI (claude-agent-sdk v0.1.48)

**Summary:** The Agent SDK exposes a `query()` function that runs the full Claude Code agent loop programmatically. It has built-in tools (Read, Write, Edit, Bash, Glob, Grep) and supports system prompts, hooks, subagents, and sessions.

**Key API mapping to DRIVER-SPEC.md methods:**

| Driver Method | Agent SDK Implementation |
|---------------|------------------------|
| `workflow_invoke` | `query(prompt=task, options={system_prompt=workflow_md})` |
| `hook_register` | `options.hooks` callbacks (PreToolUse, PostToolUse, Stop, etc.) |
| `state_read/write` | Built-in Read/Write/Edit tools (filesystem, same as Claude Code) |
| `user_interact` | Consume message stream, pause for input or auto-approve |
| `command_register` | No-op — no slash command system; map to named entry points |

**Pros:**
- Same agent loop as Claude Code — workflows "just work" as system prompts
- Built-in file tools mean state_read/state_write is trivial (filesystem)
- Session resume via `session_id` for multi-turn state
- `setting_sources` can load CLAUDE.md and skills from filesystem
- Hooks API maps cleanly to kernel lifecycle hooks

**Cons:**
- Hook names differ (PreToolUse/PostToolUse vs pre-plan/post-apply) — need mapping layer
- No native slash command system — command_register is no-op
- Requires API key (not free like Claude Code CLI)

**For our use case:** Excellent fit. The stub driver would be a Python script that reads workflow markdown, calls `query()` with it as system prompt, and streams results.

### Option B: Raw Anthropic API + Custom Agent Loop

**Source:** Anthropic Messages API docs

**Summary:** Build a custom agent loop using the raw `anthropic` Python SDK. Implement tool handling, conversation management, and state ourselves.

**Pros:**
- Full control over every aspect
- No dependency on Agent SDK packaging

**Cons:**
- Massive implementation effort — reimplementing what Agent SDK already provides
- Must handle tool execution, multi-turn, error recovery ourselves
- Diverges from Claude Code behavior (different agent loop = different results)

**For our use case:** Overkill. The Agent SDK already provides the agent loop we need.

### Claude Code Driver Extraction Strategy

**Current state:** install.sh contains all Claude Code-specific logic inline:
- Copies commands to `~/.claude/commands/`
- Symlinks hooks to `~/.claude/hooks/`
- Registers hooks in `~/.claude/settings.json`
- Module manifests already have `platform.claude_code` sections

**Extraction approach:** Move Claude Code-specific install logic into `drivers/claude-code/`:
- `drivers/claude-code/driver.yaml` — capabilities manifest
- `drivers/claude-code/install.sh` — platform-specific setup (commands, hooks, settings.json)
- `drivers/claude-code/uninstall.sh` — platform-specific teardown
- Keep kernel install in root `install.sh` (or `install-kernel.sh`)
- Root install.sh becomes: install kernel + detect/run driver installer

**Key insight:** The Claude Code "driver" is not runtime code — it's install-time wiring. At runtime, the LLM itself IS the driver (it reads workflow markdown and follows it). The driver extraction is about separating install-time concerns.

### Headless Kernel Proof

**Approach:** The kernel already runs headless in theory — workflows are markdown files, state is filesystem. To prove it:
1. Write a simple Python script that reads a workflow .md file and passes it to `query()` as system_prompt
2. Point it at a test project with `.paul/` state
3. Run the plan/apply/unify loop without any Claude Code slash commands
4. Verify state files are created/updated correctly

This is the Agent SDK driver stub itself — the proof IS the implementation.

## Comparison

| Criteria | Agent SDK `query()` | Raw Anthropic API |
|----------|--------------------|--------------------|
| Implementation effort | Low (stub) | Very high |
| Workflow compatibility | Native (same agent loop) | Must reimplement |
| Built-in file tools | Yes | Must implement |
| Hook support | Yes (different names) | Must implement |
| Session state | Built-in resume | Must implement |
| Maturity | GA (v0.1.48) | GA but lower-level |

## Recommendation

**Choose: Agent SDK `query()` API**

**Rationale:**
The Agent SDK provides the exact same agent loop that powers Claude Code, exposed as a library. Workflows loaded as system prompts will behave identically. The built-in tools handle state_read/state_write without additional code. This is the path of least resistance for proving the kernel runs headless.

**Proposed `drivers/` structure:**
```
drivers/
  claude-code/
    driver.yaml          # Capabilities manifest
    install.sh           # Extract from current install.sh
    uninstall.sh         # Extract from current uninstall.sh
  agent-sdk/
    driver.yaml          # Capabilities manifest (command_register: false)
    pals-agent.py        # Stub orchestrator using query() API
    requirements.txt     # claude-agent-sdk
    README.md            # Setup and usage
```

**Caveats:**
- Agent SDK hook names (PreToolUse, PostToolUse) don't map 1:1 to kernel lifecycle hooks (pre-plan, post-apply). The kernel lifecycle hooks are conceptual markers within workflow execution, not tool-use events. The stub may need to use system prompt instructions rather than SDK hooks for lifecycle dispatch.
- The stub is a proof-of-concept, not production. Full orchestration (error recovery, multi-plan sessions, interactive approval) is future work.

## Open Questions

- How should module manifests declare driver-agnostic hook registrations vs platform-specific ones? Currently `platform.claude_code.hooks` is Claude Code-specific. — Impact: medium (affects manifest format, but can be additive)
- Should `install.sh` detect the driver and delegate, or should each driver have its own top-level installer? — Impact: low (implementation detail)

None of these block planning.

## Quality Report

**Sources consulted:**
- Anthropic Agent SDK documentation (2026, platform.claude.com)
- PyPI claude-agent-sdk v0.1.48 (2026-03-07)
- GitHub anthropics/claude-agent-sdk-python
- Existing DRIVER-SPEC.md (Phase 10, 2026-03-11)
- Existing ARCHITECTURE.md (Phase 10, 2026-03-11)
- Current install.sh, module.yaml manifests (Phase 12, 2026-03-12)

**Verification:**
- Agent SDK `query()` API: Verified via official docs and PyPI package listing
- Built-in tools (Read/Write/Edit/Bash): Verified via SDK documentation
- Session resume: Verified via SDK documentation
- Claude Code driver as install-time wiring: Verified by reading current install.sh

**Assumptions (not verified):**
- Agent SDK system_prompt can accept full workflow markdown (large prompts) without truncation — likely true given Claude's context window, but not tested
- `setting_sources` can load PALS workflows/commands — mentioned in docs but not tested with our specific structure

---
*Discovery completed: 2026-03-12*
*Confidence: HIGH*
*Ready for: /paul:plan 13*
