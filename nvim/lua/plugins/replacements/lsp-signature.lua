--[[
shows popup window about parameter/func

NOTE: activated when on_attach() happens / or call .setup() in init.lua
  can be replaced by noice (or cmp-nvim-lsp-signature-help)
  either does not open popup permanently while typing
]]

---@type LazyPluginSpec
local spec = {
  [1] = "ray-x/lsp_signature.nvim",
  version = false,
  lazy = true,
  event = "InsertEnter",
  opts = function()
    return {
      -- log dir when debug is on
      log_path = vim.fs.joinpath(vim.fn.stdpath("state"), "lsp_signature.log"),
      max_width = 80,

      -- handler_opts = {
      --   border = "rounded",
      -- },

      -- BEST CONFIG NOT TO HIDE ANYTHING FROM THE BUFFER
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
      end,
      hint_prefix = " ", -- nf-cod-beaker
      move_cursor_key = "<C-w>", -- imap
    }
  end,
  enabled = true,
}

---@type LazySpec[]
return {
  {
    [1] = "nvim-lspconfig",
    optional = true,
    dependencies = {
      "lsp_signature.nvim",
    },
    specs = {
      spec,
    },
  },
  {
    -- disable noice's signature
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
