---@type LazySpec
return {
  [1] = "snacks.nvim",
  optional = true,
  ---@param opts snacks.Config
  opts = function(_, opts)
    vim.b.snacks_indent = true

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown", "help", "diff", "text" },
      callback = function(ev)
        vim.b[ev.buf].snacks_indent = false
      end,
    })

    return opts
  end,
}
