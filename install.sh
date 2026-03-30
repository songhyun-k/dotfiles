#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES_DIR"

# Check dependencies
for cmd in stow jq; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Error: $cmd is required. See README.md for installation."; exit 1; }
done
command -v bun >/dev/null 2>&1 || echo "Warning: bun is not installed. ccstatusline will not work until bun is available."

OS="$(uname)"

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Powerlevel10k theme
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
  echo "Installing Powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# Stow packages (restow for idempotent behavior)
PACKAGES="tmux nvim ccstatusline zsh yazi"
if [ "$OS" = "Darwin" ]; then
  PACKAGES="$PACKAGES hammerspoon"
fi

for pkg in $PACKAGES; do
  echo "Stowing $pkg..."
  stow -R -v --target="$HOME" "$pkg"
done

# Patch ~/.zshrc with managed block (idempotent)
ZSHRC="$HOME/.zshrc"
MANAGED_BEGIN="# >>> dotfiles-managed >>>"
MANAGED_END="# <<< dotfiles-managed <<<"
MANAGED_BLOCK="$MANAGED_BEGIN
ZSH_THEME=\"powerlevel10k/powerlevel10k\"
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
$MANAGED_END"

if [ -f "$ZSHRC" ]; then
  if grep -qF "$MANAGED_BEGIN" "$ZSHRC"; then
    # Replace existing managed block
    awk -v begin="$MANAGED_BEGIN" -v end="$MANAGED_END" -v block="$MANAGED_BLOCK" '
      $0 == begin { skip=1; printed=0 }
      skip && $0 == end { skip=0; if(!printed){print block; printed=1}; next }
      !skip { print }
    ' "$ZSHRC" > "$ZSHRC.tmp"
    mv "$ZSHRC.tmp" "$ZSHRC"
    echo "Updated dotfiles-managed block in $ZSHRC"
  else
    printf '\n%s\n' "$MANAGED_BLOCK" >> "$ZSHRC"
    echo "Added dotfiles-managed block to $ZSHRC"
  fi
else
  echo "Warning: $ZSHRC not found. Install Oh My Zsh first, then re-run."
fi

# Install tmux plugins via TPM
TPM_INSTALL="$HOME/.config/tmux/plugins/tpm/bin/install_plugins"
if [ -x "$TPM_INSTALL" ]; then
  echo "Installing tmux plugins..."
  "$TPM_INSTALL"
else
  echo "Warning: TPM not found. tmux plugins will be installed on first tmux launch."
fi

# Install yazi plugins
if command -v ya >/dev/null 2>&1; then
  echo "Installing yazi plugins..."
  ya pkg install
else
  echo "Warning: ya is not installed. Yazi plugins will not be installed."
fi

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

# Validate merge result before applying
jq empty "$CLAUDE_SETTINGS.tmp" 2>/dev/null || { echo "Error: settings.json merge produced invalid JSON. Backup at $CLAUDE_SETTINGS.bak"; exit 1; }
mv "$CLAUDE_SETTINGS.tmp" "$CLAUDE_SETTINGS"

echo "Done."
