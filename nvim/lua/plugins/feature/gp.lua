-- WIP

-- local api_key = vim
--   .system({ "secret-tool", "lookup", "api", "openapi" }, { text = true })
--   :wait().stdout

---@type LazySpec
return {
  [1] = "Robitx/gp.nvim",
  lazy = true,
  event = "VeryLazy",
  dependencies = {},
  opts = function()
    return {
      openai_api_key = {
        "secret-tool",
        "lookup",
        "api",
        "openapi",
      },
      providers = {
        openai = {
          disable = false,
        },
        anthropic = {
          disable = false,
          secret = {
            "secret-tool",
            "lookup",
            "api",
            "anthropic",
          },
        },
      },
      hooks = {
        UnitTests = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please respond by writing table driven unit tests for the code above."
          local agent = gp.get_command_agent("CodeClaude-3-5-Sonnet")
          gp.Prompt(params, gp.Target.vnew, agent, template)
        end,
        EditCommitMsg = function(gp, params)
          local template =
            "```gitcommit\n{{selection}}\n```\nI want you to act as a commit message generator. The above text is the commit message I roughly wrote, and I would like you to generate an appropriate commit message using the conventional commit format. The commit message must be in standard English and easy to understand for non-native English speakers.Do not write any explanations or other words, just reply with the commit message."
          -- local agent = gp.get_command_agent("CodeGPT4o")
          local agent = gp.get_command_agent("CodeClaude-3-5-Sonnet")
          gp.Prompt(params, gp.Target.rewrite, agent, template)
        end,
        GrammarCheck = function(gp, params)
          local template = [[
> {{selection}}

I want you to act as an expert proofreader capable of detecting and correcting grammatical issues in any language. The above text is sentences I wrote, and I would like you to correct any grammatical errors. In your responses, highlight the corrections clearly and provide a brief explanation for each correction if necessary. Your response should be in the same language as the input text. Do not alter the original meaning of the text.
]]
          local agent = gp.get_command_agent("CodeClaude-3-5-Sonnet")
          gp.Prompt(params, gp.Target.vnew, agent, template)
        end,
        EnglishTranslate = function(gp, params)
          local template = [[
> {{selection}}

I want you to act as an English translator, spelling corrector and improver. The above text is sentences I roughly wrote, and I would like you to translate it and answer in the corrected and improved version of my text, in English. You should ensure the sentences are simple and easy to understand for non-native English speakers. Hence, avoid complex vocabulary and sentence structures. I want you to only reply the correction, the improvements and nothing else, do not write explanations.
]]
          local agent = gp.get_command_agent("CodeClaude-3-5-Sonnet")
          gp.Prompt(params, gp.Target.vnew, agent, template)
        end,
      },
    }
  end,
  keys = function()
    local map_keyword = require("val.map-keyword")
    local keyword = map_keyword.ai
    local bufprefix = "<LocalLeader>" .. keyword
    local prefix = require("val.prefix")

    return {
      {
        [1] = "<Leader>" .. keyword,
        [2] = "<cmd>GpChatToggle popup<CR>",
        desc = "gp-chat-toggle",
      },
      {
        [1] = bufprefix .. "e",
        [2] = ":<C-u>'<,'>GpNew<CR>",
        desc = "gp-edit-current-line",
        mode = "v",
      },
      {
        [1] = bufprefix .. "E",
        [2] = "<cmd>%GpNew<CR>",
        desc = "gp-edit-current-buffer",
      },
      {
        [1] = bufprefix .. "c",
        [2] = ":<C-u>'<,'>GpEditCommitMsg<CR>",
        desc = "gp-edit-commit-message",
        mode = { "v" },
      },
      {
        [1] = bufprefix .. "g",
        [2] = ":<C-u>'<,'>GpGrammarCheck<CR>",
        desc = "gp-grammer-check",
        mode = { "v" },
      },
      {
        [1] = bufprefix .. "t",
        [2] = ":<C-u>'<,'>GpEnglishTranslate<CR>",
        desc = "gp-english-translate",
        mode = { "v" },
      },
      {
        [1] = prefix.close .. keyword,
        [2] = "<cmd>GpStop<CR>",
        desc = "gp-stop",
      },
    }
  end,
  specs = {
    {
      [1] = "folke/which-key.nvim",
      optional = true,
      opts = function(_, opts)
        if opts.icons == nil then
          opts.icons = {}
        end
        if opts.icons.rules == nil then
          opts.icons.rules = {}
        end
        vim.list_extend(opts.icons.rules, {
          { pattern = "gp", icon = require("val.icons").ai, color = "purple" },
        })

        if opts.spec == nil then
          opts.spec = {}
        end
        vim.list_extend(opts.spec, {
          {
            [1] = "<LocalLeader>" .. require("val.map-keyword").ai,
            group = "gp",
            ---@type wk.Icon
            -- icon = icon,
          },
        })
      end,
    },
  },
}
