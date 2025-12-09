#!/bin/bash
set -e

echo "🚀 Mac Setup Script Starting..."

# ============================================
# sudo 세션 미리 활성화
# ============================================
echo "🔐 sudo 비밀번호 입력 (이후 자동 진행됨)..."
sudo -v
# sudo 타임아웃 방지
while true; do sudo -n true; sleep 60; kill -0 "$" || exit; done 2>/dev/null &

# ============================================
# Sleep 방지 (caffeinate)
# - 스크립트 실행 중 Mac이 잠들지 않도록 함
# - 스크립트 종료 시 자동으로 해제됨
# ============================================
caffeinate -disu &
CAFFEINATE_PID=$!
trap "kill $CAFFEINATE_PID 2>/dev/null" EXIT

# ============================================
# Helper Functions
# ============================================
add_to_zshrc() {
    grep -qF "$1" ~/.zshrc 2>/dev/null || echo "$1" >> ~/.zshrc
}

brew_install() {
    brew list "$1" &>/dev/null || brew install "$1"
}

brew_install_cask() {
    brew list --cask "$1" &>/dev/null || brew install --cask "$1"
}

# ============================================
# Xcode Command Line Tools
# ============================================
echo "📦 Checking Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode CLT..."
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    LABEL=$(softwareupdate -l 2>&1 | grep -E '^\s+\*.*Command Line|Label:.*Command Line' | head -n 1 | sed 's/^[^C]*//' | sed 's/.*Label: *//')
    if [[ -n "$LABEL" ]]; then
        softwareupdate -i "$LABEL" --verbose
    else
        echo "⚠️ Command Line Tools를 찾을 수 없음. 수동 설치 필요: xcode-select --install"
        exit 1
    fi
    rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
fi
echo "✅ Xcode CLT ready"

# ============================================
# Homebrew
# ============================================
echo "🍺 Checking Homebrew..."
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
add_to_zshrc 'eval "$(/opt/homebrew/bin/brew shellenv)"'
echo "✅ Homebrew ready"

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
brew_install colima
brew_install docker-compose
echo "✅ CLI tools ready"

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
mise use --global go@1.21

echo "📦 Setting up Node.js..."
mise use --global node@lts

echo "☕ Setting up Java..."
mise use --global java@corretto-17
mise use --global java@corretto-8

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
# Default Browser (수동 인터랙션 필요)
# - macOS 시스템 대화상자가 뜰 수 있음
# - 원하면 주석 해제 후 실행, 또는 Chrome에서 직접 설정
# ============================================
# echo "🌐 Setting Chrome as default browser..."
# defaultbrowser chrome
# echo "✅ Chrome set as default"

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
