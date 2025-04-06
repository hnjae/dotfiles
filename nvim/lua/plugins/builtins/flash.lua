---@type LazySpec
return {
  [1] = "folke/flash.nvim",
  optional = true,

  -- stylua: ignore
  keys = {
    -- lazyvim's default:
    { "s", mode = { "n", "x", "o" }, "<Nop>", },
    { "S", mode = { "n", "o", "x" }, "<Nop>", },

    -- replace above
    { "<LocalLeader>s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "<LocalLeader>S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  },
}
