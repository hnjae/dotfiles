-- WIP

---@type LazySpec
return {
  [1] = "tzachar/cmp-ai",
  lazy = true,
  enabled = false,
  -- cond = os.getenv("OPENAI_API_KEY") ~= nil,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    max_lines = 100,
    -- provider = "OpenAI",
    -- provider_options = {
    --   model = "gpt-4o-mini",
    -- },
    provider = "Ollama",
    provider_options = {
      -- model = "codellama:7b-instruct-q4_K_M",
      -- model = "qwen2.5-coder:0.5b",
      model = "codegemma:2b-code-v1.1-q4_K_M",
      prompt = function(lines_before, lines_after)
        return lines_before
      end,
      suffix = function(lines_after)
        return lines_after
      end,
    },

    notify = true,
    run_on_every_keystroke = false,
    -- run_on_every_keystroke = false,
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
        -- if not opts.sources then
        --   opts.sources = {}
        -- end
        -- vim.list_extend(
        --   opts.sources,
        --   cmp.config.sources({
        --     { name = "cmp_ai" },
        --   })
        -- )

        opts.mapping = vim.tbl_extend(
          "keep",
          opts.mapping or {},
          cmp.mapping.preset.insert({
            ["<C-x>"] = cmp.mapping(
              cmp.mapping.complete({
                config = {
                  sources = cmp.config.sources({
                    { name = "cmp_ai" },
                  }),
                },
              }),
              { "i" }
            ),
          })
        )
      end,
    },
  },
}
