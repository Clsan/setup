#!/bin/bash
# ============================================
# Common Helper Functions & Initial Setup
# ============================================

set -e

# ============================================
# sudo 세션 미리 활성화
# ============================================
echo "🔐 sudo 비밀번호 입력 (이후 자동 진행됨)..."
sudo -v
# sudo 타임아웃 방지 — 부모(스크립트) 프로세스가 끝나면 같이 종료
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ============================================
# Sleep 방지 (caffeinate)
# ============================================
caffeinate -disu &
CAFFEINATE_PID=$!
trap 'kill $CAFFEINATE_PID 2>/dev/null' EXIT

# ============================================
# Helper Functions
# ============================================
append_block_if_missing() {
    local file="$1"
    local marker="$2"

    mkdir -p "$(dirname "$file")"
    touch "$file"

    if grep -qF "$marker" "$file"; then
        return 0
    fi

    if [[ -s "$file" ]]; then
        printf "\n" >> "$file"
    fi
    cat >> "$file"
}

append_line_if_missing() {
    local file="$1"
    local line="$2"

    append_block_if_missing "$file" "$line" <<EOF
$line
EOF
}

brew_install() {
    brew list "$1" &>/dev/null || brew install "$1"
}

brew_install_cask() {
    local cask="$1"

    if brew list --cask "$cask" &>/dev/null; then
        echo "  ↳ Cask $cask already installed"
        return 0
    fi

    echo "  ↳ Installing cask $cask"
    brew install --cask "$cask" || {
        echo "⚠️ Cask $cask install failed. Updating Homebrew and retrying..."
        brew update
        brew install --cask "$cask"
    }
}

# 다운받아 실행한 .sh 파일들을 끝나면 정리
# git 체크아웃에서 돌릴 때는 작업 트리를 건드리면 안 되므로 스킵
cleanup_downloads() {
    local dir="$1"
    if git -C "$dir" rev-parse --is-inside-work-tree &>/dev/null; then
        return 0
    fi
    echo "🧹 Cleaning up downloaded scripts..."
    rm -f "$dir"/{common,system_setup,interactive_setup,setup,work_setup,nvim_setup}.sh
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
append_line_if_missing "$HOME/.zshrc" 'eval "$(/opt/homebrew/bin/brew shellenv)"'
echo "✅ Homebrew ready"
