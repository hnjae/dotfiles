---@type LazySpec[]
return {
  {
    -- NOTE: use S in visual-mode <2024-05-09>
    [1] = "kylechui/nvim-surround",
    lazy = true,
    version = "*",
    -- event = { "InsertEnter" },
    event = { "VeryLazy" },
    opts = {},
  },
  --[[ {
    [1] = "roobert/surround-ui.nvim",
    dependencies = {
      "kylechui/nvim-surround",
      "folke/which-key.nvim",
    },
    main = "surround-ui",
    opts = {
      root_key = "S",
    },
  }, ]]
}
