local M = {}

M.setup_lspconfig = function(lspconfig, opts)
  -- require("buf-format-deny"):add("taplo") -- do not use taplo's formatter

  -- key: executable name / val: lspconfig's key
  local mapping = {
    ["taplo"] = "taplo",
  }

  for exe, lspname in pairs(mapping) do
    if vim.fn.executable(exe) == 1 then
      lspconfig[lspname].setup(opts)
    end
  end
end

-- NOTE: dprint(formatter) requires extra step before available to use <2024-01-04>
-- https://dprint.dev/plugins/toml/
-- M.get_null_ls_sources = function(null_ls, null_ls_utils)
-- return {}
-- end

return M
