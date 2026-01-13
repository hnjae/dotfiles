--[[
  NOTE:
    - My own implementation of `ai.copilot` from LazyVim
    - DO NOT USE `ai.copilot` from LazyVim
]]

---@type LazySpec
return {
  [1] = "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "BufReadPost",
  dependencies = {
    {
      [1] = "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
      lazy = true,
      specs = {
        {
          [1] = "mason.nvim",
          optional = true,
          opts = { ensure_installed = { "copilot-language-server" } },
        },
      },
    },
  },
  cond = not vim.g.vscode and vim.fn.executable("node") == 1,
  version = false,
  lazy = true,
  keys = {
    -- <Leader>ua default: Toggle Animation (LazyVim 15)
    {
      [1] = "<leader>ua",
      [2] = function()
        vim.notify("Toggle copilot")
        vim.cmd("Copilot toggle")
      end,
      desc = "copilot-toggle",
    },
    {
      [1] = "<F10>",
      [2] = function()
        -- 적당한 알림 문구 작성
        vim.notify("")

        vim.notify("Asking copilot to autocomplete")
        require("copilot.suggestion").next()
        require("copilot.suggestion").update_preview()
      end,
      mode = { "n" },
      desc = "copilot-suggestion-next",
    },
  },
  opts = {
    panel = {
      enabled = true,
      auto_refresh = true,
      keymap = {
        -- open = "<C-CR>",
        open = "<F8>",
      },
    },
    suggestion = {
      enabled = false,
      auto_trigger = true,
      hide_during_completion = false,
      debounce = 100, -- default 75
      keymap = {
        -- works in insert mode
        accept = false,
        accept_word = false,
        accept_line = false,
        next = false,
        prev = false,
        dismiss = false,
      },
    },
    nes = {
      enabled = true, -- requires copilot-lsp as a dependency
      auto_trigger = false,
      keymap = {
        accept_and_goto = false,
        accept = false,
        dismiss = false,
      },
    },

    filetypes = {
      sh = function()
        local bufname = vim.api.nvim_buf_get_name(0)
        local basename = vim.fs.basename(bufname)

        -- Disable for `.env` files
        if string.match(basename, "^%.env.*") or string.match(basename, "env") then
          return false
        elseif vim.startswith(bufname, "/tmp/") then
          return false
        end

        return true
      end,

      nix = function()
        if string.match(vim.api.nvim_buf_get_name(0), "^.*-encrypted.nix") then
          return false
        end
        return true
      end,

      -- data-formats
      conf = false,
      csv = false,
      ini = false,
      json = false,
      jsonc = false,
      toml = false,
      xml = false,
      yaml = false,

      -- plain text accounting (ledger)
      ledger = false,
      beancount = false,

      -- docs
      text = false,
      markdown = false,
      org = false,
      norg = false,
      asciidoctor = false,
      asciidoc = false,
      rst = false,
      help = false,
      [""] = false,
      typst = false,
      tex = false,

      -- version-control
      gitcommit = false,
      gitrebase = false,
      hgcommit = false,
      svn = false,
      cvs = false,

      --
      c = true,
      rust = true,
      java = true,
      lua = true,
      python = true,
      typescript = true,
      javascript = true,
      ["yaml.ansible"] = true,
      ["*"] = true,
    },
  },
  specs = {
    {
      [1] = "lualine.nvim",
      optional = true,
      event = "VeryLazy",
      dependencies = { "AndreM222/copilot-lualine" },
      opts = function(_, opts)
        opts.sections = opts.sections or {}
        opts.sections.lualine_x = opts.sections.lualine_x or {}

        local colors = {
          winbar = require("copilot-lualine.colors").get_hl_value(0, "Winbar", "fg"),
          warn = require("copilot-lualine.colors").get_hl_value(0, "DiagnosticWarn", "fg"),
          error = require("copilot-lualine.colors").get_hl_value(0, "DiagnosticError", "fg"),
        }

        local component = {
          [1] = "copilot",
          -- show_colors = true,
          symbols = {
            spinner_color = colors.winbar,
            status = {
              icons = {
                -- enabled = "󱙺 ", -- nf-md-robot_outline
                -- sleep = "󱙺 ", -- nf-md-robot_outline
                -- disabled = "󱙻 ", -- nf-md-robot_off_outline
                -- warning = "󱚟 ", -- nf-md-robot_confused

                -- enabled = " ", --nf-oct-copilot
                -- sleep = " ", -- auto-trigger disabled
                -- disabled = " ",
                -- warning = " ",
                -- NOTE: Use nf-oct variant to match icon size of above elements <2025-01-02>
                unknown = " ", -- nf-oct-skip
              },
              hl = {
                enabled = colors.winbar,
                sleep = colors.winbar,
                disabled = colors.warn,
                warning = colors.error,
                unknown = colors.error,
              },
            },
          },
        }

        table.insert(
          opts.sections.lualine_x,
          (#opts.sections.lualine_x > 2 and 3 or (#opts.sections.lualine_x + 1)),
          component
        )
      end,
    },
  },
}
