---@type LazySpec
return {
  [1] = "hrsh7th/nvim-cmp",
  optional = true,
  dependencies = {
    { [1] = "hrsh7th/cmp-nvim-lsp-signature-help" },
  },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    table.insert(
      opts.sources,
      { name = "nvim_lsp_signature_help", group_index = 1 }
    )
    return opts
  end,
}
