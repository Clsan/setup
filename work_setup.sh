#!/bin/bash
echo "💼 Work Mac Setup Starting..."

# ============================================
# Personal Setup (includes common.sh)
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
# Done!
# ============================================
echo ""
echo "============================================"
echo "🎉 Work Setup Complete!"
echo "- TODO: Install exosphere"
echo "============================================"
echo ""
