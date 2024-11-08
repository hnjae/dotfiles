-- WIP

---@type LazySpec
return {
  [1] = "tzachar/cmp-ai",
  lazy = true,
  enabled = false,
  cond = os.getenv("OPENAI_API_KEY") ~= nil,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    provider = "OpenAI",
    provider_options = {
      model = "gpt-4o-mini",
      run_on_every_keystroke = true,
    },
  },
  config = function(_, opts)
    local cmp_ai = require("cmp_ai.config")
    cmp_ai:setup(opts)
  end,
  optional = true,
  specs = {
    {
      [1] = "hrsh7th/nvim-cmp",
      optional = true,
      dependencies = { "tzachar/cmp-ai" },
      ---@param opts myCmpOpts
      opts = function(_, opts)
        local cmp = require("cmp")
        opts.sources = vim.list_extend(
          opts.sources or {},
          cmp.config.sources({
            { name = "cmp_ai" },
          })
        )

        opts.cmdline_search_sources = vim.list_extend(
          opts.cmdline_search_sources or {},
          require("cmp").config.sources({
            { name = "buffer" },
          })
        )
      end,
    },
  },
}
