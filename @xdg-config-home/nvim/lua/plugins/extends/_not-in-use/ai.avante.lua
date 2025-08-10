---@type LazySpec[]
return {
  {
    [1] = "yetone/avante.nvim",
    event = "VeryLazy",
    version = "*",
    cmd = {
      "AvanteToggle",
    },
    -- cond = not vim.g.vscode and os.getenv("ANTHROPIC_API_KEY") ~= nil,
    opts = {
      provider = "claude",

      claude = {
        endpoint = "https://api.anthropic.com",
        -- api_key_name = "cmd:bw get notes anthropic-api-key", -- the shell command must prefixed with `^cmd:(.*)`

        -- updated: 2025-05-07
        -- https://docs.anthropic.com/en/docs/about-claude/models/all-models#model-comparison-table
        model = "claude-3-7-sonnet-20250219",
        temperature = 0,
        -- max_token = 8192,
        timeout = 30000, -- Timeout in milliseconds
        disable_tools = true, -- disable LLM models tools!
      },

      file_selector = {
        provider = "snacks",
      },
    },
    build = "make",
    dependencies = {
      -- REQUIRED DEPENDENCIES
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",

      -- Optional dependencies
      { [1] = "mini.icons", optional = true },
      { [1] = "copilot.lua", optional = true },
      { [1] = "nvim-cmp", optional = true },
      -- {
      --   "render-markdown.nvim",
      --   optional = true,
      --   opts = {
      --     file_types = { "Avante" },
      --   },
      --   ft = { "Avante" },
      -- },
    },
  },
}
