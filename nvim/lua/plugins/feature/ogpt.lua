--[[
NOTE: 2024-08-06
ogpt.nvim 이 nui 를 사용하는 과정에서, 각종 윈도우 생성할 때 버그 발생. 이 문제
해결 전까지 사용 힘들듯.
]]

---@type LazySpec
return {
  [1] = "huynle/ogpt.nvim",
  enabled = false,
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    -- "nvim-telescope/telescope.nvim",
  },
  opts = function()
    return {
      default_provider = "openai",
      providers = {
        openai = {
          enabled = true,
          model = "gpt-4o",
          api_key = vim
            .system({
              "secret-tool",
              "lookup",
              "api",
              "openapi",
            }, { text = true })
            :wait().stdout,
        },
        anthropic = {
          enabled = true,
          model = "claude-3-5-sonnet-20240620",
          api_key = vim
            .system({
              "secret-tool",
              "lookup",
              "api",
              "anthropic",
            }, { text = true })
            :wait().stdout,
        },
      },
    }
  end,
}
