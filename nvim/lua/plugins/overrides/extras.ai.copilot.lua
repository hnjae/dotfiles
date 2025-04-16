--[[
  NOTE:
    - My own implementation of `ai.copilot` from LazyVim
    - DO NOT USE `ai.copilot` from LazyVim
]]

---@type LazySpec[]
return {
  {
    [1] = "zbirenbaum/copilot.lua",
    version = false,
    build = ":Copilot auth",

    cond = not vim.g.vscode and vim.fn.executable("node") == 1,

    lazy = true,
    cmd = "Copilot",
    event = "BufReadPost",

    --[[ keys = function()
      local prefix = require("globals").prefix
      local keyword = "c"
      return {
        {
          [1] = prefix.sidebar .. keyword,
          [2] = "<cmd>Copilot panel<CR>",
          desc = "copilot-panel",
        },
        {
          [1] = prefix.close .. keyword,
          [2] = "<cmd>Copilot disable<CR>",
          desc = "copilot-disable",
        },
      }
    end, ]]
    opts = {
      panel = {
        -- enabled = false,
        auto_refresh = true,
      },
      suggestion = {
        -- enabled = false,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 100, -- default 75
        keymap = {
          accept = "<F10>",
          -- accept_word = false,
          -- accept_line = false,
          -- next = "<M-]>",
          -- prev = "<M-[>",
          -- dismiss = "<C-]>",
          dismiss = "<S-F10>",
        },
      },
      filetypes = {
        sh = function()
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
            -- Disable for `.env` files
            return false
          end
          return true
        end,

        -- data-formats
        yaml = false,
        json = false,
        jsonc = false,
        toml = false,
        ini = false,

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
        ["*"] = true,
      },
    },
    specs = {
      {
        [1] = "lualine.nvim",
        optional = true,
        dependencies = { "AndreM222/copilot-lualine" },
        opts = function(_, opts)
          opts.sections = opts.sections or {}
          opts.sections.lualine_x = opts.sections.lualine_x or {}

          local colors = {
            winbar = require("copilot-lualine.colors").get_hl_value(0, "Winbar", "fg"),
            warn = require("copilot-lualine.colors").get_hl_value(0, "DiagnosticWarn", "fg"),
            error = require("copilot-lualine.colors").get_hl_value(0, "DiagnosticError", "fg"),
          }

          table.insert(opts.sections.lualine_x, {
            [1] = "copilot",
            -- show_colors = true,
            symbols = {
              spinner_color = colors.winbar,
              status = {
                icons = {
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
          })
        end,
      },
    },
  },
}
