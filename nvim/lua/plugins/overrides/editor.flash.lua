local wk_icon = {
  icon = "󰛕 ", -- nf-md-flash_outline
}

---@type LazySpec
return {
  [1] = "flash.nvim",
  optional = true,

  -- stylua: ignore
  keys = {
    -- disable lazyvim's default:
    -- { "s", mode = { "n", "x", "o" }, "<Nop>", },
    -- { "S", mode = { "n", "o", "x" }, "<Nop>", },

    -- replace above
    -- { "<LocalLeader>s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    -- { "<LocalLeader>S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  },
  ---@type Flash.Config
  opts = {
    labels = "setnriaodhfuplwyc,vkx.gmbq;/jz", -- sorted by colemak-dh typing effort
    label = {
      rainbow = {
        -- enabled = true,
      },
    },
    char = {
      enabled = false, -- disable f/F/t/T
      -- autohide = true,
    },
  },
}
