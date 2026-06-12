#!/bin/bash
# ============================================
# Neovim + LazyVim + avante.nvim (비대면)
# - setup.sh 에서 source 로 호출 (common.sh 헬퍼가 이미 스코프에 있음)
# - 기존 .vimrc(클래식 Vim) 세팅과는 별개로 공존
# ============================================

NVIM_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🧠 Setting up Neovim + LazyVim..."

# ============================================
# Dependencies
# - C 컴파일러/make 는 Xcode CLT 가 이미 제공 (treesitter 컴파일용)
# ============================================
brew_install neovim
brew_install ripgrep   # Telescope live-grep
brew_install fd        # Telescope find files
brew_install lazygit   # LazyVim git UI 통합
brew_install_cask font-jetbrains-mono-nerd-font  # 아이콘 글리프

# ============================================
# LazyVim 부트스트랩
# - ~/.config/nvim 이 비어있을 때만 starter 클론 (기존 설정 보존)
# ============================================
NVIM_CONFIG="$HOME/.config/nvim"
if [[ ! -e "$NVIM_CONFIG/init.lua" ]]; then
    echo "  ↳ Cloning LazyVim starter..."
    mkdir -p "$(dirname "$NVIM_CONFIG")"
    git clone --depth 1 https://github.com/LazyVim/starter "$NVIM_CONFIG"
    rm -rf "$NVIM_CONFIG/.git"
else
    echo "  ↳ ~/.config/nvim 이미 존재 — starter 클론 스킵"
fi

# ============================================
# avante.nvim plugin spec 배치
# - git 체크아웃이면 저장소 파일 사용, 다운로드 모드면 raw GitHub 에서 curl
#   (PR CI 에서 아직 master 에 없는 파일을 404 로 받는 문제 방지)
# ============================================
AVANTE_DEST="$NVIM_CONFIG/lua/plugins/avante.lua"
AVANTE_SRC="$NVIM_SCRIPT_DIR/nvim/lua/plugins/avante.lua"
if [[ -f "$AVANTE_DEST" ]]; then
    # 로컬에서 프로바이더(예: 사내 게이트웨이)를 직접 설정해 둘 수 있으므로 덮어쓰지 않음
    echo "  ↳ avante.lua 이미 존재 — 배치 스킵 (로컬 설정 보존)"
else
    mkdir -p "$(dirname "$AVANTE_DEST")"
    if [[ -f "$AVANTE_SRC" ]]; then
        cp "$AVANTE_SRC" "$AVANTE_DEST"
        echo "  ↳ avante.lua 배치 (로컬)"
    else
        curl -fsSL https://raw.githubusercontent.com/Clsan/setup/master/nvim/lua/plugins/avante.lua -o "$AVANTE_DEST"
        echo "  ↳ avante.lua 배치 (curl)"
    fi
fi

echo "✅ Neovim + LazyVim + avante ready"
echo "  ↳ 첫 nvim 실행 시 LazyVim 이 플러그인을 자동 설치합니다 (avante 빌드 포함)"
echo "  ↳ avante 프로바이더/API 키는 미설정 — $AVANTE_DEST 참고"
