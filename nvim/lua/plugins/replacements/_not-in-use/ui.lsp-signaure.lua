--[[
  **replace noice.nvim's signature feature**

  Shows popup window about parameter/func

  NOTE:
    - activated when on_attach() happens / or call .setup() in init.lua
    - Can be replaced by `noice` or `cmp-nvim-lsp-signature-help`; **neither** opens a popup permanently while typing.
]]

---@type LazyPluginSpec
local spec = {
  [1] = "ray-x/lsp_signature.nvim",
  version = false,

  lazy = true,
  event = "InsertEnter",

  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = function()
    return {
      -- log dir when debug is on
      -- log_path = require("plenary.path"):new(vim.fn.stdpath("log"), "/lsp_signature.log").filename,
      log_path = vim.fs.joinpath(vim.fn.stdpath("log"), "/lsp_signature.log"),

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

      hint_prefix = " ", -- nf-cod-beaker

      move_cursor_key = "<C-w>", -- imap
    }
  end,
}

---@type LazySpec{}
return {
  {
    [1] = "neovim/nvim-lspconfig",
    optional = true,
    dependencies = { spec },
  },
  {
    [1] = "noice.nvim",
    optional = true,
    ---@type NoiceConfig
    opts = {
      lsp = {
        signature = {
          enabled = false,
        },
      },
    },
  },
}
