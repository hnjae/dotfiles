-- vi:tw=0

-- local map_keyword = require("val.map-keyword")

---@type LazySpec
return {
  [1] = "folke/flash.nvim",
  lazy = true,
  event = "VeryLazy",
  enabled = false,
  keys = {
    -- stylua: ignore start
    {[1] = "s",    mode = { "o", "x" },      [2] = function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    {[1] = "<F3>", mode = { "n", "x", "o" }, [2] = function() require("flash").jump() end,              desc = "Flash" },
    -- {[1] = "<S-F3>",            mode = { "n", "x", "o" }, [2] = function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    -- {[1] = "r",     mode = "o",               [2] = function() require("flash").remote() end,            desc = "Remote Flash" },
    -- {[1] = "<c-s>", mode = { "c" },           [2] = function() require("flash").toggle() end,            desc = "Toggle Flash Search" },

    -- author's recommendation
    -- { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    -- { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    -- { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    -- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    -- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    -- stylua: ignore end
  },
  opts = {
    labels = "etovxqpdygfblzhckisuran",
    modes = {
      char = {
        -- highlight = { backdrop = false },
      },
    },
  },
  -- config = function()
  -- TODO: turnoff flash while using macros <2024-03-29>
  -- end,
}
