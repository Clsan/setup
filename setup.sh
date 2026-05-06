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
add_to_zshrc 'eval "$(starship init zsh)"'
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
# GitHub Auth + SSH Key (자동화)
# - SSH 키 자동 생성
# - 브라우저로 한 번 로그인하면 GitHub에 키 등록까지 자동
# ============================================
echo "🐙 Setting up GitHub authentication..."
SSH_KEY="$HOME/.ssh/id_ed25519"
if [[ ! -f "$SSH_KEY" ]]; then
    echo "🔑 SSH 키 생성..."
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    ssh-keygen -t ed25519 -f "$SSH_KEY" -N "" -C "$(whoami)@$(hostname)"
fi

# github.com host key를 known_hosts에 미리 등록 (첫 push 프롬프트 방지)
if ! ssh-keygen -F github.com -f "$HOME/.ssh/known_hosts" &>/dev/null; then
    ssh-keyscan -t ed25519,rsa github.com >> "$HOME/.ssh/known_hosts" 2>/dev/null
fi

set +e
if ! gh auth status &>/dev/null; then
    echo "🌐 GitHub 로그인 — 브라우저가 열립니다. 한 번만 로그인하면 됩니다."
    gh auth login --git-protocol ssh --web --hostname github.com --scopes admin:public_key
fi

LOCAL_PUB=$(awk '{print $2}' "$SSH_KEY.pub")
if ! gh ssh-key list 2>/dev/null | grep -qF "$LOCAL_PUB"; then
    echo "🔑 GitHub에 SSH 키 등록..."
    gh ssh-key add "$SSH_KEY.pub" --title "$(hostname)-$(date +%Y%m%d)"
fi
set -e
echo "✅ GitHub ready"

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
# Vim Settings
# ============================================
echo "📝 Setting up Vim..."
mkdir -p ~/.vim/colors
curl -fsSL https://raw.githubusercontent.com/Clsan/setup/master/.vimrc -o ~/.vimrc
curl -fsSL https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim -o ~/.vim/colors/gruvbox.vim
echo "✅ Vim ready"

# ============================================
# mise (Runtime Version Manager)
# ============================================
echo "🔄 Checking mise..."
brew_install mise
add_to_zshrc 'eval "$(mise activate zsh)"'
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

add_to_zshrc 'export PYENV_ROOT="$HOME/.pyenv"'
add_to_zshrc '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"'
add_to_zshrc 'eval "$(pyenv init -)"'

echo "✅ Python tools ready"

# ============================================
# Colima (Docker runtime)
# ============================================
echo "🐳 Checking Colima..."
if colima status 2>&1 | grep -q "not running\|not exist"; then
    echo "Starting Colima..."
    colima start
fi
echo "✅ Colima ready"

# ============================================
# macOS System Settings
# ============================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/system_setup.sh"

# ============================================
# Done!
# ============================================
echo ""
echo "============================================"
echo "🎉 Setup Complete!"
echo "============================================"
echo ""
echo "새 터미널을 열거나: source ~/.zshrc"
echo "설치된 런타임 확인: mise list"
echo ""
