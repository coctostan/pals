# PALS

**Project Automation & Lifecycle System for Claude Code**

PALS is an end-to-end development framework that manages the full plan-apply-unify lifecycle inside Claude Code. It combines four subsystems — PAUL (project lifecycle), CARL (context rules), TODD (TDD enforcement), and WALT (quality gating) — into a single installable package.

## Install

```bash
git clone <repo-url> pals
cd pals
./install.sh
```

Then start a new Claude Code session.

## Quick Start

| Command | What it does |
|---------|-------------|
| `/pals:init` | Initialize PALS in your project |
| `/pals:plan` | Create an executable plan for your next task |
| `/pals:apply` | Execute an approved plan |
| `/pals:unify` | Reconcile results and close the loop |
| `/pals:progress` | See current status and suggested next action |
| `/pals:help` | Show all available commands |

## Components

- **PAUL** — Project lifecycle management. Plans, executes, and tracks work through the plan-apply-unify loop.
- **CARL** — Context-aware rule loading. Injects domain-specific rules into every Claude session via hooks.
- **TODD** — Test-driven development enforcement. Ensures RED-GREEN-REFACTOR discipline when plans use TDD.
- **WALT** — Quality gating. Runs tests, lint, and type checks before and after each apply phase.

## Uninstall

```bash
cd pals
./uninstall.sh
```

This removes all PALS files from `~/.pals/` and `~/.claude/` without affecting other Claude Code configuration.
