#!/usr/bin/env bash
# Hook: PostToolUse(Edit|Write)
# Runs the appropriate linter after Claude edits a file.
# Receives tool context on stdin as JSON.

set -euo pipefail

PAYLOAD=$(cat)
FILE=$(echo "$PAYLOAD" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

if [[ -z "$FILE" || ! -f "$FILE" ]]; then
  exit 0
fi

if [[ "$FILE" == *.go ]]; then
  PKG_DIR=$(dirname "$FILE")
  # Only run if golangci-lint is available
  if ! command -v golangci-lint &> /dev/null; then
    exit 0
  fi
  echo "→ lint: $PKG_DIR"
  golangci-lint run --fast "$PKG_DIR/..." 2>&1 | head -40 || true

elif [[ "$FILE" == *.ts || "$FILE" == *.tsx || "$FILE" == *.svelte ]]; then
  ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
  if [[ -z "$ROOT" ]]; then
    exit 0
  fi
  # Walk up from the file to find the nearest tsconfig.json
  DIR=$(dirname "$FILE")
  TSCONFIG=""
  while [[ "$DIR" != "$ROOT" && "$DIR" != "/" ]]; do
    if [[ -f "$DIR/tsconfig.json" ]]; then
      TSCONFIG="$DIR/tsconfig.json"
      break
    fi
    DIR=$(dirname "$DIR")
  done
  if [[ -z "$TSCONFIG" && -f "$ROOT/tsconfig.json" ]]; then
    TSCONFIG="$ROOT/tsconfig.json"
  fi
  if [[ -z "$TSCONFIG" ]]; then
    exit 0
  fi
  TSROOT=$(dirname "$TSCONFIG")
  echo "→ tsc: $TSROOT"
  cd "$TSROOT" && tsc --noEmit 2>&1 | head -40 || true
fi
