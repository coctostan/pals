#!/bin/bash
# PALS End-to-End Validation — Phase 6 Checkpoint 2
# Run this, then open a new Claude Code session in ~/tmp-pals-test

set -e

TEST_DIR="$HOME/tmp-pals-test"

echo "════════════════════════════════════════"
echo "PALS Lifecycle Validation"
echo "════════════════════════════════════════"
echo ""

# Create test project
if [ -d "$TEST_DIR" ]; then
  echo "Cleaning existing $TEST_DIR ..."
  rm -rf "$TEST_DIR"
fi

mkdir -p "$TEST_DIR"
cd "$TEST_DIR"
git init -q

echo "[ok] Test project created at $TEST_DIR"
echo ""
echo "════════════════════════════════════════"
echo "NEXT STEPS (manual in Claude Code):"
echo "════════════════════════════════════════"
echo ""
echo "  1. cd $TEST_DIR"
echo "  2. Start a new Claude Code session"
echo "  3. Run: /pals:init"
echo "  4. Verify: ls .paul/ shows STATE.md, PROJECT.md, ROADMAP.md"
echo "  5. Run: /pals:progress"
echo "  6. Check CARL rules appear in session context"
echo ""
echo "When done, clean up with:"
echo "  rm -rf $TEST_DIR"
echo ""
