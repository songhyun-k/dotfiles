# dotfiles

tmux, nvim (LazyVim), Claude Code statusline (ccstatusline), Hammerspoon 설정을 GNU Stow로 관리.

## 의존성

### 필수 (macOS + Linux)

| 도구 | 용도 | 설치 |
|------|------|------|
| GNU Stow | 심볼릭 링크 관리 | `brew install stow` / `apt install stow` |
| git ≥ 2.19 | TPM bootstrap, lazy.nvim clone | `brew install git` / `apt install git` |
| tmux ≥ 3.2 | 터미널 멀티플렉서 (OSC52 지원 필요) | `brew install tmux` / `apt install tmux` |
| Neovim ≥ 0.11.2 | 에디터 (LazyVim 요구사항) | `brew install neovim` / 공식 릴리즈 |
| Node.js | LSP, 포매터, 린터 (Mason 경유) | `brew install node` / `apt install nodejs` |
| Bun | ccstatusline 실행 | `curl -fsSL https://bun.sh/install \| bash` |
| jq | install.sh JSON merge | `brew install jq` / `apt install jq` |
| ripgrep (`rg`) | fzf, snacks_picker 검색 | `brew install ripgrep` / `apt install ripgrep` |
| fd | fzf, snacks_picker 파일 탐색 | `brew install fd` / `apt install fd-find` |
| fzf | editor.fzf extra | `brew install fzf` / `apt install fzf` |
| curl | blink.cmp 자동완성 | `brew install curl` / 대부분 기본 설치 |
| C compiler | treesitter 파서 컴파일 | `xcode-select --install` / `apt install build-essential` |
| Nerd Font v3+ | tmux/nvim 아이콘 표시 | `brew install --cask font-hack-nerd-font` |

### 권장 (macOS + Linux)

| 도구 | 용도 | 설치 |
|------|------|------|
| lazygit | LazyVim git TUI (`<leader>gg`) | `brew install lazygit` / `apt install lazygit` |
| bat | fzf 프리뷰 하이라이팅 | `brew install bat` / `apt install bat` |
| yazi | tmux 파일 탐색기 (`prefix + Tab`) | `brew install yazi` / 공식 릴리즈 |

### 언어별 런타임 (LazyVim extras 의존)

활성화된 extras에 따라 필요. LSP/린터는 Mason이 자동 설치하지만 런타임은 직접 설치해야 함.

| 도구 | 관련 extras | 설치 |
|------|-------------|------|
| python3 | lang.python | `brew install python` / `apt install python3` |
| ruby | lang.ruby | `brew install ruby` / `apt install ruby` |
| typescript | lang.typescript, lang.angular, lang.svelte | `npm install -g typescript` |
| prettier | formatting.prettier | `npm install -g prettier` |

### macOS만

| 도구 | 용도 | 설치 |
|------|------|------|
| Hammerspoon | Ctrl+b IME 전환 | `brew install --cask hammerspoon` |
| im-select | tmux 상태바 IME 표시 | `brew install im-select` |

## 설치

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

## 설치 후 수동 작업

1. **Hammerspoon (macOS)**: Hammerspoon 실행 → 접근성(Accessibility) 권한 허용
2. **tmux 플러그인**: tmux 실행 후 `prefix + I`로 TPM 플러그인 설치
3. **nvim 플러그인**: `nvim` 첫 실행 시 lazy.nvim이 자동으로 모든 플러그인 설치. Mason이 LSP/포매터 자동 설치.

## 참고

### 첫 마이그레이션

기존 설정 파일이 실제 파일(심볼릭 링크가 아닌)로 존재하면 `stow`가 실패한다. 기존 파일을 삭제한 후 `install.sh`를 실행하거나, `stow --adopt`로 기존 파일을 stow 패키지로 흡수할 수 있다.

### Linux 서버에서 terminfo

리모트 서버에 `xterm-ghostty` terminfo가 없을 수 있다. tmux.conf에 fallback이 포함되어 있으나, 필요 시 Ghostty의 terminfo를 직접 설치할 수도 있다.
