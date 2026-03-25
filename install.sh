#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES_DIR"

# 의존성 체크
for cmd in stow jq; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Error: $cmd is required. See README.md for installation."; exit 1; }
done
command -v bun >/dev/null 2>&1 || echo "Warning: bun is not installed. ccstatusline will not work until bun is available."

OS="$(uname)"

# Stow packages (restow로 idempotent 동작)
PACKAGES="tmux nvim ccstatusline"
if [ "$OS" = "Darwin" ]; then
  PACKAGES="$PACKAGES hammerspoon"
fi

for pkg in $PACKAGES; do
  echo "Stowing $pkg..."
  stow -R -v --target="$HOME" "$pkg"
done

# Claude Code settings.json merge
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
OVERLAY="$DOTFILES_DIR/ccstatusline/claude-statusline.json"

mkdir -p "$HOME/.claude"
[ -f "$CLAUDE_SETTINGS" ] || echo '{}' > "$CLAUDE_SETTINGS"
cp "$CLAUDE_SETTINGS" "$CLAUDE_SETTINGS.bak"

jq --slurpfile overlay "$OVERLAY" '
  (.hooks // {}) |= with_entries(
    .value |= map(select(._tag != "ccstatusline-managed"))
  )
  | .statusLine = $overlay[0].statusLine
  | .hooks = (
      (.hooks // {}) as $base |
      ($overlay[0].hooks // {}) as $new |
      ($base | keys + ($new | keys) | unique) as $all_keys |
      reduce $all_keys[] as $k ({}; .[$k] = (($base[$k] // []) + ($new[$k] // [])))
    )
' "$CLAUDE_SETTINGS" > "$CLAUDE_SETTINGS.tmp"

# merge 결과 검증 후 적용
jq empty "$CLAUDE_SETTINGS.tmp" 2>/dev/null || { echo "Error: settings.json merge produced invalid JSON. Backup at $CLAUDE_SETTINGS.bak"; exit 1; }
mv "$CLAUDE_SETTINGS.tmp" "$CLAUDE_SETTINGS"

echo "Done."
