#!/bin/bash
echo "💼 Work Mac Setup Starting..."

# ============================================
# Personal Setup (includes common.sh)
# - INTERACTIVE_DEFERRED=1 로 인터랙티브 단계는 이 스크립트 끝까지 미룸
# ============================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INTERACTIVE_DEFERRED=1 source "$SCRIPT_DIR/setup.sh"

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
source "$SCRIPT_DIR/interactive_setup.sh"

# ============================================
# Done!
# ============================================
echo ""
echo "============================================"
echo "🎉 Work Setup Complete!"
echo "- TODO: Install exosphere"
echo "============================================"
echo ""
