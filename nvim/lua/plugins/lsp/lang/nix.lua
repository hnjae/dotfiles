---@type LspSpec
local M = {}

M.setup_lspconfig = function(lspconfig, opts)
  require("buf-format-deny"):add("rnix")
  require("buf-format-deny"):add("nixd") -- NOTE: formatter 기능 없는데, 있다고 인식하는 듯? <2024-01-05>
  require("buf-format-deny"):add("nil_ls")

  local mapping = {
    -- NOTE: last update: 2022-06-14 <2024-01-05>
    -- includes formatter (using nixpkgs-fmt)
    ["rnix-lsp"] = "rnix",

    -- https://github.com/nix-community/nixd/blob/main/nixd/docs/editors/nvim-lsp.nix
    nixd = "nixd",

    --lints & suggestions
    -- NOTE: 에러 발생. 당분간은 null-ls 로 사용하자. <2024-01-05>
    -- statix = "statix",

    -- no formatter
    -- ["nil"] = "nil_ls",
  }
  for exe, lspname in pairs(mapping) do
    if vim.fn.executable(exe) == 1 then
      lspconfig[lspname].setup(opts)
    end
  end
end

M.get_null_ls_sources = function(null_ls)
  local ret = {}

  local mapping = {
    statix = {
      null_ls.builtins.diagnostics.statix,
      null_ls.builtins.code_actions.statix,
    },
    -- scan dead code
    deadnix = { null_ls.builtins.diagnostics.deadnix },
  }

  for exe, sources in pairs(mapping) do
    if vim.fn.executable(exe) == 1 then
      for _, source in pairs(sources) do
        table.insert(ret, source)
      end
    end
  end

  return ret
end

M.get_conform_opts = function()
  -- NOTE: last-update 2022-06-15 <2024-01-05>
  -- ["nixpkgs-fmt"] = null_ls.builtins.formatting.nixpkgs_fmt,
  return {
    formatters_by_ft = {
      nix = { "alejandra" },
    },
  }
end

return M
