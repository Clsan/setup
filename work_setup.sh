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
# Codex + Work MCP servers
# ============================================
echo "🤖 Installing Codex and MCP tools..."
brew_install_cask codex
brew_install mcp-grafana

append_line_if_missing "$HOME/.zshrc" 'export GRAFANA_URL="${GRAFANA_URL:-}"'
append_line_if_missing "$HOME/.zshrc" 'export GRAFANA_SERVICE_ACCOUNT_TOKEN="${GRAFANA_SERVICE_ACCOUNT_TOKEN:-}"'

append_block_if_missing "$HOME/.codex/config.toml" "[mcp_servers.grafana]" <<'EOF'
[mcp_servers.grafana]
command = "/opt/homebrew/bin/mcp-grafana"
args = []
env_vars = [
  "GRAFANA_URL",
  "GRAFANA_SERVICE_ACCOUNT_TOKEN",
]
EOF
echo "  ↳ Codex MCP 'grafana' configured"

append_block_if_missing "$HOME/.codex/config.toml" "[mcp_servers.datadog]" <<'EOF'
[mcp_servers.datadog]
url = "https://mcp.datadoghq.com/api/unstable/mcp-server/mcp"
EOF
echo "  ↳ Codex MCP 'datadog' configured"

append_block_if_missing "$HOME/.codex/config.toml" "[mcp_servers.channel-teamchat]" <<'EOF'
[mcp_servers.channel-teamchat]
url = "https://cht-teamchat-mcp.dmz.channel.io/mcp"
EOF
echo "  ↳ Codex MCP 'channel-teamchat' configured"

echo "  ↳ Grafana reads GRAFANA_URL and GRAFANA_SERVICE_ACCOUNT_TOKEN when Codex starts"
if [[ -n "$SETUP_NONINTERACTIVE" ]]; then
    echo "  ↳ SETUP_NONINTERACTIVE — Codex MCP OAuth login 스킵"
elif command -v codex &>/dev/null; then
    codex mcp login datadog || echo "⚠️ Datadog MCP login skipped"
    codex mcp login channel-teamchat || echo "⚠️ Channel Teamchat MCP login skipped"
else
    echo "⚠️ codex command not found. Open Codex once, then retry MCP login manually."
fi
echo "✅ Codex ready"

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
