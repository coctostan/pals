# Auto Context Cycling Research Findings

## Question
Can Claude Code's `/clear` be triggered programmatically to enable automatic context cycling?

## Approaches Investigated

| # | Approach | Feasibility | Notes |
|---|----------|-------------|-------|
| 1 | Hook return signals | Not feasible | Hooks can only inject context or block prompts — cannot trigger commands |
| 2 | Slash command injection | Not feasible | No mechanism to inject executable commands via hooks |
| 3 | External process/IPC | Not feasible | No socket, IPC, or API to send commands to a running session |
| 4 | Instruction-based auto-pause | Partially feasible | CARL could inject "run /paul:pause" at DEPLETED bracket — reduces 3→2 manual steps |
| 5 | Optimized manual cycle | Feasible | Polish existing flow, marginal improvement |

## Key Constraint
`/clear` is a built-in CLI command that resets conversation context. It:
- Cannot be triggered by hooks
- Cannot be triggered by external processes
- Creates a hard context boundary (everything before is lost)
- Requires at least one user action after it to trigger any hook

## Best Possible Outcome
With smart instruction injection: 3 manual steps → 2 manual steps.
- Auto-pause at DEPLETED (saves 1 step)
- User still manually: `/clear` then `/paul:resume`

## Decision
**Not worth implementing.** The marginal improvement (3→2 steps) doesn't justify the complexity. The fundamental constraint is on Claude Code's side. Revisit if Anthropic adds:
- Programmatic `/clear` or session reset
- Hook actions (not just context injection)
- IPC/socket interface for session control

## Sources
- Claude Code Hooks Reference (hooks can only inject additionalContext or block)
- Claude Code CLI Reference (no IPC/socket interface)
- Claude Code Agent SDK (cannot trigger built-in commands)

---
*Research completed: 2026-03-11*
