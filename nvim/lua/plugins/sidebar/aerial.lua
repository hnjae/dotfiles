-- NOTE: outline 류 플러그인 도움 안되고 필요 없는듯.  <2024-07-26>
---@type LazySpec
return {
  [1] = "stevearc/aerial.nvim",
  enabled = false,
  dependencies = {
    {
      [1] = "nvim-treesitter/nvim-treesitter",
      optional = true,
    },
  },
  lazy = true,
  -- event = { "LspAttach", },
  cmd = {
    "AerialToggle",
  },
  keys = function()
    local val = require("val")
    local prefix = val.prefix
    local map_keyword = val.map_keyword

    return {
      {
        [1] = prefix.sidebar .. map_keyword.symbols,
        [2] = "<cmd>AerialToggle!<CR>",
        desc = "aerial-toggle",
      },
    }
  end,
  opts = {
    -- backends = {
    --   ["_"] = { "lsp", "treesitter" },
    --   asciidoc = { "asciidoc" },
    -- },
  },
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function()
        local icons = require("val").icons
        require("state.lualine-ft-data"):add({
          aerial = { display_name = "Aerial", icon = icons.symbol },
        })
      end,
    },
  },
}
