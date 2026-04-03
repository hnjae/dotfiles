---@type LazySpec
return {
  [1] = "nvim-lspconfig",
  optional = true,
  opts = {
    -- options for vim.diagnostic.config()
    ---@type vim.diagnostic.Opts
    diagnostics = {
      -- virtual_lines = function(namespace)
      --   local name = vim.diagnostic.get_namespace(namespace).name
      --   -- name: NULL_LS_SOURCE_*
      -- end,

      -- neovim 0.11
      virtual_lines = {
        -- severity = vim.diagnostic.severity.ERROR,
        -- severity = { max = vim.diagnostic.severity.WARN, min = vim.diagnostic.severity.INFO },
        severity = {},
        -- format = function(diagnostic)
        --   return vim.inspect(diagnostic)
        -- end,
      },

      -- 라인 끝에 표시되는 메시지
      virtual_text = {
        -- severity = {},
        severity = vim.diagnostic.severity.ERROR,
        -- severity = { max = vim.diagnostic.severity.WARN, min = vim.diagnostic.severity.INFO },

        -- following is LazyVim 14's default
        source = "if_many",
        spacing = 4,
        prefix = "●",
      },

      underline = {
        -- severity = vim.diagnostic.severity.WARN,
        -- severity = { max = vim.diagnostic.severity.ERROR, min = vim.diagnostic.severity.WARN },
        severity = { min = vim.diagnostic.severity.WARN },
      },
    },
  },
}
