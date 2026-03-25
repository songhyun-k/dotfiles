# dotfiles

tmux, nvim (LazyVim), Claude Code statusline (ccstatusline), Hammerspoon 설정을 GNU Stow로 관리.

## 의존성

### 공통 (macOS + Linux)

| 도구 | 용도 | 설치 |
|------|------|------|
| GNU Stow | 심볼릭 링크 관리 | `brew install stow` / `apt install stow` |
| tmux ≥ 3.2 | 터미널 멀티플렉서 (OSC52 지원 필요) | `brew install tmux` / `apt install tmux` |
| Neovim ≥ 0.10 | 에디터 (LazyVim + OSC52) | `brew install neovim` / 공식 릴리즈 |
| Node.js | LazyVim extras 일부 의존 | `brew install node` / `apt install nodejs` |
| Bun | ccstatusline 실행 | `curl -fsSL https://bun.sh/install \| bash` |
| jq | install.sh JSON merge | `brew install jq` / `apt install jq` |

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

## 참고

### 첫 마이그레이션

기존 설정 파일이 실제 파일(심볼릭 링크가 아닌)로 존재하면 `stow`가 실패한다. 기존 파일을 삭제한 후 `install.sh`를 실행하거나, `stow --adopt`로 기존 파일을 stow 패키지로 흡수할 수 있다.

### Linux 서버에서 terminfo

리모트 서버에 `xterm-ghostty` terminfo가 없을 수 있다. tmux.conf에 fallback이 포함되어 있으나, 필요 시 Ghostty의 terminfo를 직접 설치할 수도 있다.
