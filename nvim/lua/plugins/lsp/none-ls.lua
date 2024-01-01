-- function string:endswith(suffix)
--   return self:sub(-#suffix) == suffix
-- end

local val = require("val")
-- local function startswith(string, prefix)
--   return string:sub(1, #prefix) == prefix
-- end

---@type LazySpec
return {
  -- "jose-elias-alvarez/null-ls.nvim",
  [1] = "nvimtools/none-ls.nvim",
  lazy = true,
  event = { "VeryLazy" },
  enabled = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/CONFIG.md
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
  opts = function()
    local ret = {
      debug = true,
      -- diagnostics_format = "#{m} (#{s})",
      diagnostics_format = "[#{c}] #{m} (#{s})",
      -- root_dir = require("null-ls.utils").root_pattern(unpack(val.root_patterns)),
      sources = {},
      on_attach = val.on_attach,
    }

    local null_ls = require("null-ls")
    local utils = require("null-ls.utils")

    local paths =
      vim.fn.uniq(vim.fn.sort(vim.fn.globpath(vim.fn.stdpath("config"), "lua/plugins/lsp/lang/*.lua", false, true)))

    local lang_conf = nil
    for _, file in pairs(paths) do
      lang_conf = require("plugins.lsp.lang." .. file:match("[^/\\]+$"):sub(1, -5))

      if lang_conf.get_null_ls_sources then
        for _, source in pairs(lang_conf.get_null_ls_sources(null_ls, utils)) do
          table.insert(ret.sources, source)
        end
      end
    end

    return ret
  end,
}
