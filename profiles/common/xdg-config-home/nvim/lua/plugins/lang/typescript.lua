---@type LazySpec[]
return {
  {
    [1] = "lazy.nvim",
    optional = true,
    opts = function()
      vim.g.lazyvim_python_lsp = "tsgo"
    end,
  },
}
