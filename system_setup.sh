#!/bin/bash
# ============================================
# macOS System Settings
# ============================================

echo "⚙️ Configuring macOS settings..."

# ============================================
# Default Browser (수동 인터랙션 필요)
# - macOS 시스템 대화상자가 뜨면 Tab+Space로 확인
# - 스크립트는 멈추지 않고 계속 진행됨
# ============================================
echo "🌐 Setting Chrome as default browser..."
defaultbrowser chrome
echo "✅ Chrome set as default"

# ============================================
# Keyboard Shortcuts (키보드 단축키 설정)
# - Cmd+Space = 입력 소스 변경
# - Ctrl+Space = Spotlight
# ============================================
echo "⌨️ Setting keyboard shortcuts..."

# Modifier keys:
#   262144 = Ctrl
#   1048576 = Cmd
# Key codes:
#   49 = Space
#   32 = Space (ASCII)

# Spotlight 검색: Ctrl+Space (key 64)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 \
    "<dict>
        <key>enabled</key><true/>
        <key>value</key>
        <dict>
            <key>type</key><string>standard</string>
            <key>parameters</key>
            <array>
                <integer>32</integer>
                <integer>49</integer>
                <integer>262144</integer>
            </array>
        </dict>
    </dict>"

# 입력 소스 변경: Cmd+Space (key 60)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 \
    "<dict>
        <key>enabled</key><true/>
        <key>value</key>
        <dict>
            <key>type</key><string>standard</string>
            <key>parameters</key>
            <array>
                <integer>32</integer>
                <integer>49</integer>
                <integer>1048576</integer>
            </array>
        </dict>
    </dict>"

# 변경사항 즉시 적용
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

echo "✅ Keyboard shortcuts ready"

# ============================================
# Dock Settings (Dock 설정)
# - Finder, Calendar 만 남기고 나머지 제거
# - Auto-hide 활성화
# ============================================
echo "🖥️ Configuring Dock..."

# Dock에서 모든 앱 제거 (Finder는 시스템에서 자동으로 유지됨)
defaults write com.apple.dock persistent-apps -array

# Calendar 추가
defaults write com.apple.dock persistent-apps -array-add \
    "<dict>
        <key>tile-data</key>
        <dict>
            <key>file-data</key>
            <dict>
                <key>_CFURLString</key><string>/System/Applications/Calendar.app</string>
                <key>_CFURLStringType</key><integer>0</integer>
            </dict>
        </dict>
    </dict>"

# Auto-hide Dock 활성화
defaults write com.apple.dock autohide -bool true

# Auto-hide 딜레이 제거 (즉시 나타남)
defaults write com.apple.dock autohide-delay -float 0

# Auto-hide 애니메이션 속도 (빠르게)
defaults write com.apple.dock autohide-time-modifier -float 0.3

# Dock 재시작하여 변경사항 적용
killall Dock

echo "✅ Dock configured"

echo "✅ macOS settings ready"
