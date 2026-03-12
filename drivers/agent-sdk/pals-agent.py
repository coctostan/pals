#!/usr/bin/env python3
"""
PALS Agent SDK Driver — Proof-of-Concept Stub

Runs PALS kernel workflows headless using the Anthropic Agent SDK.
Reads a workflow .md file and passes it as a system prompt to the
claude-agent-sdk query() function, which executes the same agent
loop that powers Claude Code.

Status: Proof-of-concept. Not production-ready.

Usage:
    python pals-agent.py <workflow.md> [--project-dir PATH] [--prompt TEXT]
    echo "Plan phase 2" | python pals-agent.py ~/.pals/workflows/plan-phase.md

Requirements:
    pip install claude-agent-sdk
    export ANTHROPIC_API_KEY=sk-ant-...
"""

import argparse
import asyncio
import os
import sys


def parse_args():
    parser = argparse.ArgumentParser(
        description="Run a PALS workflow via the Anthropic Agent SDK",
        epilog="Example: python pals-agent.py ~/.pals/workflows/plan-phase.md --project-dir /my/project",
    )
    parser.add_argument(
        "workflow",
        help="Path to a PALS workflow .md file (e.g., ~/.pals/workflows/plan-phase.md)",
    )
    parser.add_argument(
        "--project-dir",
        default=os.getcwd(),
        help="Project directory containing .paul/ state (default: current directory)",
    )
    parser.add_argument(
        "--prompt",
        default=None,
        help="Task prompt to send to the agent (default: read from stdin if piped)",
    )
    parser.add_argument(
        "--permission-mode",
        default="acceptEdits",
        choices=["acceptEdits", "dontAsk", "default"],
        help="Permission mode for tool execution (default: acceptEdits)",
    )
    return parser.parse_args()


def read_workflow(workflow_path):
    """Read and return the workflow markdown content."""
    abs_path = os.path.abspath(os.path.expanduser(workflow_path))
    if not os.path.isfile(abs_path):
        print(f"Error: Workflow file not found: {abs_path}", file=sys.stderr)
        sys.exit(1)
    with open(abs_path, "r") as f:
        return f.read()


def get_prompt(args):
    """Get the task prompt from args, stdin, or default."""
    if args.prompt:
        return args.prompt
    if not sys.stdin.isatty():
        return sys.stdin.read().strip()
    # Default prompt based on workflow name
    workflow_name = os.path.splitext(os.path.basename(args.workflow))[0]
    return f"Execute the {workflow_name} workflow for this project."


async def run_workflow(workflow_content, prompt, project_dir, permission_mode):
    """
    Run a PALS workflow using the Agent SDK query() function.

    The workflow markdown is injected as the system prompt. The agent
    receives the same built-in tools as Claude Code (Read, Write, Edit,
    Bash, Glob, Grep) and follows the workflow instructions autonomously.
    """
    # Import here so missing package gives a clear error
    try:
        from claude_agent_sdk import ClaudeAgentOptions, query
    except ImportError:
        print(
            "Error: claude-agent-sdk not installed.\n"
            "Run: pip install claude-agent-sdk",
            file=sys.stderr,
        )
        sys.exit(1)

    # Verify API key is set
    if not os.environ.get("ANTHROPIC_API_KEY"):
        print(
            "Error: ANTHROPIC_API_KEY environment variable not set.\n"
            "Export your API key: export ANTHROPIC_API_KEY=sk-ant-...",
            file=sys.stderr,
        )
        sys.exit(1)

    # Build the system prompt: workflow markdown + project context
    system_prompt = (
        f"You are executing a PALS workflow. Follow the instructions below exactly.\n\n"
        f"Project directory: {os.path.abspath(project_dir)}\n"
        f"State directory: {os.path.join(os.path.abspath(project_dir), '.paul')}\n\n"
        f"--- WORKFLOW ---\n\n"
        f"{workflow_content}"
    )

    options = ClaudeAgentOptions(
        allowed_tools=["Read", "Write", "Edit", "Bash", "Glob", "Grep"],
        permission_mode=permission_mode,
        system_prompt=system_prompt,
    )

    # TODO: Hook dispatch — kernel lifecycle hooks (pre-plan, post-apply, etc.)
    # are conceptual markers within the workflow, not Agent SDK hook events.
    # Future implementation should:
    # 1. Parse workflow for lifecycle markers
    # 2. Load modules.yaml for registered handlers
    # 3. Inject module references at the appropriate points
    # For now, module references must be manually included in the workflow.

    print(f"Running workflow: {os.path.basename(args.workflow)}")
    print(f"Project: {os.path.abspath(project_dir)}")
    print(f"Permission mode: {permission_mode}")
    print("---")

    async for message in query(prompt=prompt, options=options):
        # Stream text output to stdout
        if hasattr(message, "content") and isinstance(message.content, str):
            print(message.content, end="", flush=True)
        elif hasattr(message, "result"):
            print(f"\n--- Result ---\n{message.result}")


if __name__ == "__main__":
    args = parse_args()

    workflow_content = read_workflow(args.workflow)
    prompt = get_prompt(args)
    project_dir = os.path.abspath(args.project_dir)

    # Validate project directory
    if not os.path.isdir(project_dir):
        print(f"Error: Project directory not found: {project_dir}", file=sys.stderr)
        sys.exit(1)

    paul_dir = os.path.join(project_dir, ".paul")
    if not os.path.isdir(paul_dir):
        print(
            f"Warning: No .paul/ directory found in {project_dir}. "
            f"Run /paul:init first or specify --project-dir.",
            file=sys.stderr,
        )

    asyncio.run(run_workflow(workflow_content, prompt, project_dir, args.permission_mode))
