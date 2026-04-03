---@type LazySpec
return {
  [1] = "none-ls.nvim",
  version = false,
  event = "LazyFile",
  dependencies = { "mason.nvim" },
  opts = function(_, opts)
    -- Do NOT use NULL_LS as formatter
    opts.sources = vim.tbl_filter(function(source)
      return not (
        (source.method == "NULL_LS_FORMATTING")
        or (
          type(source.method) == "table" and vim.list_contains(source.method, "NULL_LS_FORMATTING")
        )
      )
    end, opts.sources or {})

    return opts
  end,
}
