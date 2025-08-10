---@type LazyPluginSpec
local spec = {
  [1] = "lualine.nvim",
  optional = true,
  opts = function(_, opts)
    table.insert(opts.sections.lualine_b, "overseer")
  end,
}

---@type LazySpec
return {
  [1] = "overseer.nvim",
  optional = true,
  specs = { spec },
}
