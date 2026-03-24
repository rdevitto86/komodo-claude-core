#!/usr/bin/env bash
# setup.sh — Bootstrap komodo-claude symlinks into ~/.claude
# Run once after cloning: bash setup.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "komodo-claude: setting up symlinks from $REPO_DIR/claude → $CLAUDE_DIR"

# Ensure ~/.claude exists
mkdir -p "$CLAUDE_DIR"

# settings.json
if [ -L "$CLAUDE_DIR/settings.json" ]; then
  echo "  settings.json — already a symlink, skipping"
elif [ -f "$CLAUDE_DIR/settings.json" ]; then
  echo "  settings.json — backing up existing file to settings.json.bak"
  mv "$CLAUDE_DIR/settings.json" "$CLAUDE_DIR/settings.json.bak"
  ln -s "$REPO_DIR/claude/settings.json" "$CLAUDE_DIR/settings.json"
  echo "  settings.json — linked"
else
  ln -s "$REPO_DIR/claude/settings.json" "$CLAUDE_DIR/settings.json"
  echo "  settings.json — linked"
fi

# skills/
if [ -L "$CLAUDE_DIR/skills" ]; then
  echo "  skills/ — already a symlink, skipping"
elif [ -d "$CLAUDE_DIR/skills" ]; then
  echo "  skills/ — backing up existing directory to skills.bak"
  mv "$CLAUDE_DIR/skills" "$CLAUDE_DIR/skills.bak"
  ln -s "$REPO_DIR/claude/skills" "$CLAUDE_DIR/skills"
  echo "  skills/ — linked"
else
  ln -s "$REPO_DIR/claude/skills" "$CLAUDE_DIR/skills"
  echo "  skills/ — linked"
fi

echo ""
echo "Done. Restart Claude Code to pick up the new settings."
