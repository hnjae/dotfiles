---@type LspSpec
local M = {}

M.setup_lspconfig = function(lspconfig, opts)
  -- key: executable name / val: lspconfig's key
  local mapping = {
    ["bash-language-server"] = "bashls",
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
    printenv = {
      null_ls.builtins.hover.printenv,
    },

    -- NOTE: bashls 가 있어 shellcheck 는 deprecated 됨: https://github.com/nvimtools/none-ls.nvim/issues/58 <2024-03-06>
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
  return {
    formatters_by_ft = {
      sh = { "shfmt" },
      -- sh = { "shellharden" }, -- for 문 안의 $() to double quote 해버림
    },
  }
end

M.post_conform_setup = function()
  require("conform").formatters.shfmt = {
    prepend_args = function()
      if vim.bo.expandtab then
        return { "-i", tostring(vim.bo.shiftwidth) }
      end

      return {}
    end,
  }
end

return M
