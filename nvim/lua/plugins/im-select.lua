-- im-select.nvim — 자동 입력 소스 전환 (insert mode ↔ normal mode)
-- normal mode 진입 시 자동으로 영문 입력으로 전환하고,
-- insert mode 재진입 시 이전 입력 소스로 복원.
-- 한글, 일본어, 중국어 등 모든 입력 소스를 자동 감지하여 처리.
return {
  "keaising/im-select.nvim",
  event = "VeryLazy",
  opts = {
    -- macOS 기본 영문 입력 소스 (normal mode 에서 사용할 기본값)
    default_im_select = "com.apple.keylayout.ABC",
    -- im-select 바이너리 경로 (Homebrew 로 설치)
    default_command = "/opt/homebrew/bin/im-select",
    -- 모드 전환 시 자동으로 입력 소스 전환 활성화
    set_default_events = { "VimEnter", "FocusGained", "InsertLeave", "CmdlineLeave" },
    set_previous_events = { "InsertEnter" },
  },
}
