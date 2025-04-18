---@type LazySpec
return {
  [1] = "bufferline.nvim",
  optional = true,

  opts = function(_, opts)
    local highlights = {
      tab_selected = {
        fg = {
          attribute = "fg",
          highlight = "Normal",
          bold = true,
        },
        bg = {
          attribute = "bg",
          highlight = "Normal",
        },
      },
    }

    opts.highlights = vim.tbl_deep_extend("force", opts.highlights or {}, highlights)
    return opts
  end,
}
