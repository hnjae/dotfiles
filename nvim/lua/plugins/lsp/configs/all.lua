---@type LspSpec
local M = {}

M.get_null_ls_sources = function(null_ls, _)
  local ret = {
    -- completion 관련은 cmp에 추가. 여기에 추가하면 LSP 가 제공한 소스로
    -- 관주되어 우선순위 관리가 까다로움
    -- null_ls.builtins.completion.luasnip,
    -- null_ls.builtins.completion.spell, -- completion scope 더럽힘. 쓰지말자.
    -- null_ls.builtins.completion.tags,

    -- null_ls.builtins.hover.printenv,
    -- null_ls.builtins.hover.dictionary,
  }

  local mapping = {
    codespell = {
      null_ls.builtins.diagnostics.codespell.with({
        args = {
          "-X",
          require("plenary.path"):new(
            vim.fn.stdpath("config"),
            "/spell/en.utf-8.add"
          ).filename,
          "-",
        },
        diagnostics_postprocess = function(diagnostic)
          diagnostic.severity = vim.diagnostic.severity.HINT
        end,
        method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
      }),
    },
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

return M
