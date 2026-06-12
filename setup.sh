#!/bin/bash
echo "🚀 Personal Mac Setup Starting..."

# ============================================
# Common Setup (Xcode CLT, Homebrew, Helpers)
# ============================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# ============================================
# Starship Prompt
# ============================================
echo "🚀 Checking Starship..."
brew_install starship
append_line_if_missing "$HOME/.zshrc" 'eval "$(starship init zsh)"'
echo "✅ Starship ready"

# ============================================
# CLI Tools
# ============================================
echo "🔧 Installing CLI tools..."
brew_install tree
brew_install vegeta
brew_install awscli
brew_install defaultbrowser
brew_install docker
brew_install docker-compose
brew_install colima
brew_install gh
echo "✅ CLI tools ready"

# ============================================
# SSH Key (비대면 준비 — 인증/등록은 마지막 interactive 단계에서)
# ============================================
echo "🔑 Preparing SSH key..."
SSH_KEY="$HOME/.ssh/id_ed25519"
if [[ ! -f "$SSH_KEY" ]]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    ssh-keygen -t ed25519 -f "$SSH_KEY" -N "" -C "$(whoami)@$(hostname)"
fi
# github.com host key 사전 등록 (첫 push 프롬프트 방지)
if ! ssh-keygen -F github.com -f "$HOME/.ssh/known_hosts" &>/dev/null; then
    ssh-keyscan -t ed25519,rsa github.com >> "$HOME/.ssh/known_hosts" 2>/dev/null
fi
echo "✅ SSH key ready"

# ============================================
# GUI Applications
# ============================================
echo "🖥️ Installing applications..."
brew_install_cask rectangle
brew_install_cask telegram
brew_install_cask visual-studio-code
brew_install_cask google-chrome
brew_install_cask postman
echo "✅ Applications ready"

# ============================================
# Rectangle
# - launchOnLogin 만 미리 설정 (환영 다이얼로그에 없어서 까먹기 쉬움)
# - 단축키 프리셋, 타일링 끄기, Accessibility 는 첫 실행 UI 에서 안내
# ============================================
echo "📐 Launching Rectangle..."
defaults write com.knollsoft.Rectangle launchOnLogin -bool true
open -a Rectangle
echo "✅ Rectangle launched"

# ============================================
# Vim Settings
# ============================================
echo "📝 Setting up Vim..."
mkdir -p ~/.vim/colors
curl -fsSL https://raw.githubusercontent.com/Clsan/setup/master/.vimrc -o ~/.vimrc
curl -fsSL https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim -o ~/.vim/colors/gruvbox.vim
echo "✅ Vim ready"

# ============================================
# Neovim + LazyVim + avante.nvim
# ============================================
source "$SCRIPT_DIR/nvim_setup.sh"

# ============================================
# mise (Runtime Version Manager)
# ============================================
echo "🔄 Checking mise..."
brew_install mise
append_line_if_missing "$HOME/.zshrc" 'eval "$(mise activate zsh)"'
eval "$(mise activate bash)"

echo "🐹 Setting up Go..."
mise use --global go@1.24

echo "📦 Setting up Node.js..."
mise use --global node@lts

echo "☕ Setting up Java..."
mise use --global java@corretto-8
mise use --global java@corretto-17

echo "🏗️ Setting up Gradle..."
mise use --global gradle@8.7

echo "✅ mise and runtimes ready"

# ============================================
# Python (pyenv + uv)
# ============================================
echo "🐍 Setting up Python..."
brew_install pyenv
brew_install uv

append_line_if_missing "$HOME/.zshrc" 'export PYENV_ROOT="$HOME/.pyenv"'
append_line_if_missing "$HOME/.zshrc" '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"'
append_line_if_missing "$HOME/.zshrc" 'eval "$(pyenv init -)"'

echo "✅ Python tools ready"

# ============================================
# Colima (Docker runtime)
# - SETUP_NONINTERACTIVE: CI 에선 nested-virt 시작이 오래 걸리고 검증 가치도 낮아 스킵
# ============================================
echo "🐳 Checking Colima..."
if [[ -n "$SETUP_NONINTERACTIVE" ]]; then
    echo "  ↳ SETUP_NONINTERACTIVE — colima start 스킵"
elif colima status 2>&1 | grep -q "not running\|not exist"; then
    echo "Starting Colima..."
    # set -e 하에서 colima start 실패가 setup 전체를 죽이지 않도록 격리
    if ! colima start; then
        echo "⚠️ Colima 시작 실패 — 나중에 'colima start' 수동 실행"
    fi
fi
echo "✅ Colima ready"

# ============================================
# macOS System Settings (비대면)
# ============================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/system_setup.sh"

# ============================================
# Interactive Section (사람 필요)
# - 직접 실행 (./setup.sh) 일 때만 진행
# - source 로 불려왔으면 (work_setup.sh 등) 호출자가 자기 끝에서 처리
# ============================================
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ -z "$SETUP_NONINTERACTIVE" ]]; then
        source "$SCRIPT_DIR/interactive_setup.sh"
    else
        echo "  ↳ SETUP_NONINTERACTIVE — interactive 단계 스킵"
    fi

    echo ""
    echo "============================================"
    echo "🎉 Setup Complete!"
    echo "============================================"
    echo ""
    echo "새 터미널을 열거나: source ~/.zshrc"
    echo "설치된 런타임 확인: mise list"
    echo ""

    cleanup_downloads "$SCRIPT_DIR"
fi
