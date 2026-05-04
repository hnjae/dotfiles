--[[
  NOTE:
    Enable `lang.toml` from LazyExtra
--]]

---@type LazySpec
return {
  -- LazyVim does only uses taplo as LSP <2026-05-05>
  [1] = "conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      toml = { "taplo", lsp_format = "never" },
    },
  },
  specs = {
    {
      [1] = "mason.nvim",
      optional = true,
      opts = { ensure_installed = { "taplo" } },
    },
  },
}
