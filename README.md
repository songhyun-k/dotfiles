# dotfiles

tmux, Neovim (LazyVim), Claude Code statusline, Hammerspoon 설정을 [GNU Stow](https://www.gnu.org/software/stow/)로 관리.

## 설치

```bash
git clone git@github.com:songhyun-k/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

### 설치 후

- **tmux**: 실행 후 `prefix + I`로 TPM 플러그인 설치
- **nvim**: 첫 실행 시 플러그인 자동 설치 (lazy.nvim + Mason)
- **Hammerspoon** (macOS): 실행 후 접근성(Accessibility) 권한 허용

## 의존성

### 필수

| 도구 | 용도 | macOS | Linux |
|------|------|-------|-------|
| git ≥ 2.19 | TPM/lazy.nvim bootstrap | `brew install git` | `apt install git` |
| tmux ≥ 3.2 | 터미널 멀티플렉서 (OSC52) | `brew install tmux` | `apt install tmux` |
| Neovim ≥ 0.11.2 | 에디터 (LazyVim) | `brew install neovim` | 공식 릴리즈 |
| GNU Stow | 심볼릭 링크 관리 | `brew install stow` | `apt install stow` |
| jq | install.sh JSON merge | `brew install jq` | `apt install jq` |
| Node.js | LSP, 포매터, 린터 | `brew install node` | `apt install nodejs` |
| Bun | ccstatusline | `brew install oven-sh/bun/bun` | `curl -fsSL https://bun.sh/install \| bash` |
| ripgrep | 검색 (fzf, snacks_picker) | `brew install ripgrep` | `apt install ripgrep` |
| fd | 파일 탐색 (fzf, snacks_picker) | `brew install fd` | `apt install fd-find` |
| fzf | fuzzy finder | `brew install fzf` | `apt install fzf` |
| curl | blink.cmp 자동완성 | 기본 설치 | `apt install curl` |
| C compiler | treesitter 파서 컴파일 | `xcode-select --install` | `apt install build-essential` |
| [Nerd Font](https://www.nerdfonts.com/) v3+ | tmux/nvim 아이콘 | `brew install --cask font-hack-nerd-font` | 공식 릴리즈 |

### 권장

| 도구 | 용도 | 설치 |
|------|------|------|
| lazygit | Git TUI (`<leader>gg`) | `brew install lazygit` |
| bat | fzf 프리뷰 하이라이팅 | `brew install bat` |
| yazi | 파일 탐색기 (`prefix + Tab`) | `brew install yazi` |

### 언어 런타임

LazyVim extras에 따라 필요. LSP/린터는 Mason이 설치하지만 런타임은 직접 설치.

| 도구 | extras | 설치 |
|------|--------|------|
| python3 | lang.python | `brew install python` / `apt install python3` |
| ruby | lang.ruby | `brew install ruby` / `apt install ruby` |
| typescript | lang.typescript, angular, svelte | `npm install -g typescript` |
| prettier | formatting.prettier | `npm install -g prettier` |

### macOS 전용

| 도구 | 용도 | 설치 |
|------|------|------|
| Hammerspoon | Ctrl+b 입력 시 IME → ABC 전환 | `brew install --cask hammerspoon` |
| im-select | tmux 상태바 IME 표시 | `brew install im-select` |

## 참고

### 첫 마이그레이션

기존 설정 파일이 심볼릭 링크가 아닌 실제 파일로 존재하면 `stow`가 충돌한다. 기존 파일을 삭제 후 `install.sh`를 실행하거나, `stow --adopt`로 기존 파일을 패키지에 흡수할 수 있다.

### Linux 서버 terminfo

리모트 서버에 `xterm-ghostty` terminfo가 없을 수 있다. tmux.conf에 fallback(`xterm-256color:clipboard`)이 포함되어 있다.
