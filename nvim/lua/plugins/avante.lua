-- avante.nvim — Cursor 스타일 AI 어시스턴트 (LazyVim plugin override)
-- 프로바이더/API 키는 의도적으로 미설정 (개인 셋업 기본값).
-- 사용하려면 opts.provider 와 providers 를 채운 뒤 nvim 재시작. 예시:
--   opts = {
--     provider = "claude",
--     providers = {
--       claude = {
--         endpoint = "https://api.anthropic.com",
--         model = "claude-sonnet-4-6",
--         api_key_name = "ANTHROPIC_API_KEY", -- 해당 키가 담긴 env 이름
--       },
--     },
--   }
-- 사용법: :AvanteAsk 로 대화, :AvanteToggle 로 패널 토글
return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- 항상 최신 (avante 는 자주 바뀜)
  -- prebuilt 바이너리 다운로드. 소스 빌드를 원하면:
  --   build = "make BUILD_FROM_SOURCE=true"  (rust 필요)
  build = "make",
  opts = {
    -- provider = "claude",  -- 사용 시 위 예시처럼 채우기
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- 선택 의존성
    "nvim-mini/mini.pick", -- file selector
    "stevearc/dressing.nvim",
    "folke/snacks.nvim",
    {
      -- 클립보드 이미지 붙여넣기
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = { insert_mode = true },
        },
      },
    },
    {
      -- 마크다운/응답 렌더링
      "MeanderingProgrammer/render-markdown.nvim",
      opts = { file_types = { "markdown", "Avante" } },
      ft = { "markdown", "Avante" },
    },
  },
}
