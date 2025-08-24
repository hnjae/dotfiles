---@type  LazySpec
return {
  [1] = "3rd/image.nvim",
  version = false,
  lazy = true,
  -- enabled = false,
  build = false,
  ft = { "markdown" },
  cond = vim.env.TERM_PROGRAM == "ghostty",
  opts = {
    backend = "kitty",
    processor = "magick_cli",
  },
}
