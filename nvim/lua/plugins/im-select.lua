-- im-select.nvim — normal mode 진입 시 자동으로 영문 입력으로 전환
return {
  "keaising/im-select.nvim",
  event = "VeryLazy",
  opts = {
    default_im_select = "com.apple.keylayout.ABC",
    default_command = "/opt/homebrew/bin/im-select",
    set_default_events = { "InsertLeave", "CmdlineLeave", "TermLeave" },
    set_previous_events = {},
  },
}
