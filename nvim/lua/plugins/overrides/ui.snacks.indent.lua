---@type LazySpec
return {
  [1] = "snacks.nvim",
  optional = true,
  ---@param opts snacks.Config
  opts = function(_, opts)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown", "help", "text" },
      callback = function(event)
        vim.b[event.buf].snacks_indent = false
      end,
    })

    return opts
  end,
}
