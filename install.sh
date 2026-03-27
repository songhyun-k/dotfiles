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

# Oh My Zsh 설치
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Powerlevel10k 테마 설치
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
  echo "Installing Powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# Stow packages (restow로 idempotent 동작)
PACKAGES="tmux nvim ccstatusline zsh yazi"
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
  # Ensure .hooks is an object before processing
  .hooks = (.hooks // {})
  # Remove previously managed entries
  | .hooks |= with_entries(
      if (.value | type) == "array"
      then .value |= map(select(._tag != "ccstatusline-managed"))
      else .
      end
    )
  | .statusLine = $overlay[0].statusLine
  | ($overlay[0].hooks // {}) as $new
  | reduce ($new | keys[]) as $k (.;
      .hooks[$k] = ((.hooks[$k] // []) + $new[$k])
    )
' "$CLAUDE_SETTINGS" > "$CLAUDE_SETTINGS.tmp"

# merge 결과 검증 후 적용
jq empty "$CLAUDE_SETTINGS.tmp" 2>/dev/null || { echo "Error: settings.json merge produced invalid JSON. Backup at $CLAUDE_SETTINGS.bak"; exit 1; }
mv "$CLAUDE_SETTINGS.tmp" "$CLAUDE_SETTINGS"

echo "Done."
