---@type LazySpec[]
return {
  [1] = "neovim/nvim-lspconfig",
  optional = true,
  dependencies = {
    {
      -- shows popup window about parameter/func
      -- NOTE: activated when on_attach() happens / or call .setup() in init.lua
      -- can be replaced by noice (or cmp-nvim-lsp-signature-help)
      -- either does not open popup permanently while typing
      [1] = "ray-x/lsp_signature.nvim",
      lazy = true,
      opts = function()
        return {
          -- log dir when debug is on
          log_path = require("plenary.path"):new(
            vim.fn.stdpath("state"),
            "/lsp_signature.log"
          ).filename,
          -- floating_window = true,
          -- floating_window_above_cur_line = true,
          -- doc_lines = 12,
          floating_window_off_x = function()
            local winheight = vim.fn.winheight(0) - 1
            local winline = vim.fn.winline() -- line number in the window
            local winwidth = vim.fn.winwidth(0)

            if winline <= 13 then
              if winwidth <= 160 then
                return -1000000
              end

              return 10000000
            end

            if winheight - winline <= 10 then
              if winwidth <= 160 then
                return -1000000
              end

              return 10000000
            end

            return 0
          end,
          floating_window_off_y = function()
            local winheight = vim.fn.winheight(0) - 1
            local winline = vim.fn.winline() -- line number in the window
            local winwidth = vim.fn.winwidth(0)

            if winline <= 13 then
              if winwidth <= 160 then
                return 1000000
              end
              return -10000000
            end

            if winheight - winline <= 10 then
              if winwidth <= 160 then
                return -10000000
              end
              return 1000000
            end

            return 0

            -- vim.o.columns
          end,
          -- floating_window_off_y = function()
          -- max_height = 24,
          hint_prefix = require("utils").enable_icon and " " or "", -- nf-cod-beaker
          -- vim.fn.hlexists("LspSignatureActiveParameter"),
          -- hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
          -- zindex = 999999,
          move_cursor_key = "<C-w>", -- imap
        }
      end,
      enabled = true,
    },
  },
}
