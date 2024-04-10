-- function string:endswith(suffix)
--   return self:sub(-#suffix) == suffix
-- end
-- local function startswith(string, prefix)
--   return string:sub(1, #prefix) == prefix
-- end

local val = require("val")

---@type LazySpec
return {
  -- "jose-elias-alvarez/null-ls.nvim",
  [1] = "nvimtools/none-ls.nvim",
  lazy = true,
  event = { "VeryLazy" },
  cmd = { "NullLsInfo", "NullLsLog" },
  enabled = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/CONFIG.md
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
  opts = function(_, opts)
    opts = vim.tbl_deep_extend("force", opts, {
      debug = false,
      fallback_severity = vim.diagnostic.severity.WARN,

      -- diagnostics_format = "#{m} (#{s})",
      diagnostics_format = "[#{c}] #{m} (#{s})",
      -- root_dir = require("null-ls.utils").root_pattern(unpack(val.root_patterns)),
      sources = {},
      on_attach = val.on_attach,

      should_attach = function(bufnr)
        if vim.api.nvim_buf_get_option(bufnr, "buftype") ~= "" then
          return false
        end
        return true
      end,
    })

    return opts
  end,
  config = function(_, opts)
    local null_ls = require("null-ls")
    null_ls.setup(opts)
  end,
}
