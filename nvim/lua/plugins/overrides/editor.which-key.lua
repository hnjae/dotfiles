---@type LazySpec
return {
  [1] = "which-key.nvim",
  opts_extend = { "spec", "icons.rules" },
  optional = true,
  opts = {
    ---@type wk.Spec[]
    spec = {
      {
        -- Add missing icon from LazyVim v14.14.0 (2025-04-09)
        -- <https://neovim.io/doc/user/options.html#'keywordprg'>
        [1] = "<Leader>K",
        mode = { "n" },
        icon = {
          icon = " ", -- nf-cod-question
          color = "yellow",
        },
      },
    },
  },
  specs = {
    {
      [1] = "lazydev.nvim",
      optional = true,
      opts = {
        library = {
          "which-key.nvim",
        },
      },
    },
  },
}
