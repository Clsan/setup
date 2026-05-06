#!/bin/bash
echo "💼 Work Mac Setup Starting..."

# ============================================
# Personal Setup (includes common.sh)
# - source 로 불러서 setup.sh 안의 인터랙티브 단계는 자동으로 스킵됨
#   (BASH_SOURCE 체크로 직접 실행일 때만 동작)
# ============================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/setup.sh"

# ============================================
# Claude Code
# ============================================
echo "🤖 Installing Claude Code..."
brew_install_cask claude
echo "✅ Claude Code ready"

# ============================================
# Okta Verify
# ============================================
echo "🔐 Installing Okta Verify..."
brew_install_cask okta-verify
echo "✅ Okta Verify ready"

# ============================================
# Interactive Section (사람 필요한 단계 한 번에)
# ============================================
if [[ -z "$SETUP_NONINTERACTIVE" ]]; then
    source "$SCRIPT_DIR/interactive_setup.sh"
else
    echo "  ↳ SETUP_NONINTERACTIVE — interactive 단계 스킵"
fi

# ============================================
# Done!
# ============================================
echo ""
echo "============================================"
echo "🎉 Work Setup Complete!"
echo "- TODO: Install exosphere"
echo "============================================"
echo ""

cleanup_downloads "$SCRIPT_DIR"
