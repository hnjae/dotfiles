local wk_icon = {
  icon = "󰕛 ", -- nf-md-vector_difference_ab
  color = "orange",
}

---@type LazySpec
return {
  [1] = "sindrets/diffview.nvim",
  cond = not vim.g.vscode,
  lazy = true,
  cmd = {
    "DiffviewFileHistory",
    "DiffviewClose",
    "DiffviewFocusFiles",
    "DiffviewToggleFiles",
    "DiffviewLog",
    "DiffviewOpen",
    "DiffviewRefresh",
  },
  opts = {
    use_icons = true,
    icons = { -- Only applies when use_icons is true.
      folder_closed = " ", --nf-cod-folder
      folder_open = " ", --nf-cod-folder_opened
    },
    signs = {
      -- fold_closed = "",
      -- fold_open = "",
      -- fold_closed = "󰞘", -- nf-md-expand-right
      -- fold_open = "󰞖", -- nf-md-arrow-expand-down
      -- fold_closed = " ", -- nf-oct-fold
      -- fold_open = " ", -- nf-oct-fold_down
      done = "", --nf-oct-check
    },
  },
  keys = {
    { [1] = "<Leader>gdo", [2] = "<cmd>DiffviewOpen<CR>",        desc = "diffview-open" },
    { [1] = "<Leader>gdc", [2] = "<cmd>DiffviewClose<CR>",       desc = "diffview-close" },
    { [1] = "<Leader>gdl", [2] = "<cmd>DiffviewLog<CR>",         desc = "diffview-log" },
    { [1] = "<Leader>gdr", [2] = "<cmd>DiffviewRefresh<CR>",     desc = "diffview-refresh" },
    { [1] = "<Leader>gdf", [2] = "<cmd>DiffviewFocusFiles<CR>",  desc = "diffview-focus-files" },
    { [1] = "<Leader>gdh", [2] = "<cmd>DiffviewFileHistory<CR>", desc = "diffview-file-history" },
    {
      [1] = "<Leader>gdh",
      mode = "v",
      [2] = ":<C-u>'<,'>DiffviewFileHistory<CR>",
      desc = "diffview-file-history",
    },
  },
  specs = {
    {
      [1] = "which-key.nvim",
      optional = true,
      -- ---@type wk.Opts
      opts = {
        ---@type wk.IconRule[]
        icons = {
          rules = {
            { plugin = "diffview.nvim", icon = wk_icon.icon, color = wk_icon.color },
          },
        },
        ---@type wk.Spec[]
        spec = {
          { [1] = "<Leader>gd", mode = { "n", "v" }, group = "diffview", icon = wk_icon },
        },
      },
    },
  },
}
