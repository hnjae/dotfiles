---@type LazySpec
return {
  -- set keymap / show keymap
  [1] = "folke/which-key.nvim",
  lazy = true,
  event = {
    "VeryLazy",
  },
  opts = {
    operators = {},
    hidden = {
      "<silent>",
      "<cmd>",
      "<Cmd>",
      "<CR>",
      "call",
      "lua",
      "^:",
      "^ ",
      "require",
      [[("orgmode")]],
    }, -- hide mapping boilerplate
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    local prefix = require("val").prefix
    -- local map_keyword = require("val").map_keyword

    local maps = {
      -- vim builtin
      ["['"] = { name = "Previous line with mark" },
      ["]'"] = { name = "Next line with mark" },
      ["[`"] = { name = "Previous mark" },
      ["]`"] = { name = "Next mark" },
    }
    for name, map in pairs(prefix) do
      maps[map] = { name = name }
    end

    -- TODO: dirty code. fix it <2023-12-26>
    -- maps["g" .. map_keyword.lsp] = { name = "+lsp" }

    maps[prefix.new .. "c"] = { name = "+current-buffer" }
    maps[prefix.new .. "e"] = { name = "+empty" }

    wk.register(maps, {})
  end,
}
