-- WIP
-- TODO: use tabby instead of ollama <2024-12-26>

---@type LazySpec
return {
  [1] = "tzachar/cmp-ai",
  lazy = true,
  enabled = false,
  cond = not vim.g.vscode,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    -- max_lines = 100,
    notify = true,
    run_on_every_keystroke = false,

    provider = "Ollama",
    provider_options = {
      model = "qwen2.5-coder:1.5b-base",
      temperature = 0.7,
      prompt = function(lines_before, lines_after)
        return "<|fim_prefix|>"
          .. lines_before
          .. "\n"
          .. "<|fim_suffix|>"
          .. "\n"
          .. lines_after
          .. "<|fim_middle|>"
      end,
    },

    -- provider = "Tabby",
    -- provider_options = {
    --   -- TABBY_API_KEY
    -- },
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

        -- Add cmp-ai to source
        -- if not opts.sources then
        --   opts.sources = {}
        -- end
        -- table.insert(
        --   opts.sources,
        --   cmp.config.sources({
        --     { name = "cmp_ai" },
        --   })
        -- )

        if not opts.mapping then
          opts.mapping = {}
        end

        opts.mapping["<C-x>"] = cmp.mapping(
          cmp.mapping.complete({
            config = {
              sources = cmp.config.sources({
                { name = "cmp_ai" },
              }),
            },
          }),
          { "i" }
        )
      end,
    },
  },
}
