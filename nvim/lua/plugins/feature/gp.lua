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
          local agent = gp.get_command_agent()
          gp.Prompt(params, gp.Target.vnew, agent, template)
        end,
      },
    }
  end,
  keys = function()
    local map_keyword = require("val.map-keyword")
    local keyword = map_keyword.ai
    local bp = "<LocalLeader>" .. keyword
    local prefix = require("val.prefix")

    return {
      { [1] = "<Leader>" .. keyword, [2] = "<cmd>GpChatToggle popup<CR>" },
      {
        [1] = bp .. "e",
        [2] = ":<C-u>'<,'>GpNew<CR>",
        desc = "edit-current-line-in-horizonotal-buffer",
        mode = "v",
      },
      {
        [1] = bp .. "E",
        [2] = "<cmd>%GpNew<CR>",
        desc = "edit-current-buffer-in-horizonotal-buffer",
      },
      {
        [1] = prefix.close .. keyword,
        [2] = "<cmd>GpStop<CR>",
        desc = "gp-stop",
      },
    }
  end,
}
