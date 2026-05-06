#!/bin/bash
# ============================================
# Interactive Setup (사람 필요한 마지막 단계)
# - 비대면 단계는 모두 끝낸 뒤 마지막에 호출
# - 호출 위치: setup.sh / work_setup.sh 의 맨 끝
# ============================================

echo ""
echo "============================================"
echo "✋ 이제 사람이 필요한 마지막 단계"
echo "============================================"
echo ""

# 알림 + 터미널 벨 (다른 작업 중이면 돌아오라는 신호)
osascript -e 'display notification "Setup이 사람 손길을 기다립니다" with title "Mac Setup" sound name "Glass"' 2>/dev/null
printf '\a'

# ============================================
# Rectangle Accessibility 권한
# - Rectangle 은 setup.sh 에서 이미 실행되어 있음
# - macOS TCC는 SIP 때문에 사용자 클릭 없이 권한을 줄 수 없으므로
#   Privacy → Accessibility 패널을 열어 사용자가 토글 한 번 켜면 끝
# ============================================
echo "📐 Rectangle accessibility..."
echo "  ↳ Privacy → Accessibility 에서 Rectangle 토글을 켜주세요."
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"

# ============================================
# GitHub Auth + SSH Key
# - 브라우저에서 OTP 한 번 입력하면 끝
# ============================================
echo "🐙 GitHub authentication..."
set +e
if ! gh auth status &>/dev/null; then
    echo "  ↳ 브라우저가 열립니다. OTP를 복사해 GitHub에 입력하세요."
    gh auth login --git-protocol ssh --web --hostname github.com --scopes admin:public_key
fi

SSH_KEY="$HOME/.ssh/id_ed25519"
if [[ -f "$SSH_KEY.pub" ]]; then
    LOCAL_PUB=$(awk '{print $2}' "$SSH_KEY.pub")
    if ! gh ssh-key list 2>/dev/null | grep -qF "$LOCAL_PUB"; then
        echo "🔑 GitHub에 SSH 키 등록..."
        gh ssh-key add "$SSH_KEY.pub" --title "$(hostname)-$(date +%Y%m%d)"
    fi
fi
set -e
echo "✅ GitHub ready"
