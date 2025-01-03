-- TODO: use copilot-cmp.lua instead of official version <2023-11-14>

---@type LazySpec[]
return {
  {
    [1] = "github/copilot.vim",
    lazy = true,
    event = "VeryLazy",
    enabled = false,
    cond = vim.fn.executable("node") == 1,
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_filetypes = {
        xml = false,
        text = false,
        yaml = false,
        json = false,
        jsonc = false,
        toml = false,
        ini = false,
        markdown = false,
        asciidoctor = false,
        asciidoc = false,
        rst = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
      }
    end,
    config = function()
      vim.cmd([[
        imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
    ]])
    end,
  },
  {
    [1] = "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    enabled = false,
    opts = {},
    specs = {
      {
        [1] = "hrsh7th/nvim-cmp",
        optional = true,
        dependencies = { "zbirenbaum/copilot-cmp" },
        ---@param opts myCmpOpts
        opts = function(_, opts)
          local cmp = require("cmp")

          if not opts.sources then
            opts.sources = {}
          end

          table.insert(opts.sources, { name = "copilot", group_index = 2 })
        end,
      },
      {
        [1] = "zbirenbaum/copilot.lua",
        optional = true,
        opts = {},
      },
    },
  },
  {
    [1] = "zbirenbaum/copilot.lua",
    lazy = true,
    event = "VeryLazy",
    enabled = true,
    cond = vim.fn.executable("node") == 1,
    keys = function()
      local prefix = require("val.prefix")
      -- local map_keyword = require("val.map-keyword")
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
    end,
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
          if
            string.match(
              vim.fs.basename(vim.api.nvim_buf_get_name(0)),
              "^%.env.*"
            )
          then
            -- Disable for `.env` files
            return false
          end
          return true
        end,
        text = false,
        yaml = false,
        json = false,
        jsonc = false,
        toml = false,
        ini = false,
        markdown = false,
        asciidoctor = false,
        asciidoc = false,
        rst = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        c = true,
        rust = true,
        java = true,
        lua = true,
        python = true,
        typescript = true,
        javascript = true,
        [""] = false,
        ["*"] = true,
      },
    },
    specs = {
      {
        [1] = "nvim-lualine/lualine.nvim",
        dependencies = { "AndreM222/copilot-lualine" },
        optional = true,
        ---@param opts myLualineOpts
        opts = function(_, opts)
          if not require("utils").enable_icon then
            return
          end

          if not opts.sections then
            opts.sections = {}
          end
          if not opts.sections.lualine_x then
            opts.sections.lualine_x = {}
          end

          local colors = {
            winbar = require("copilot-lualine.colors").get_hl_value(
              0,
              "Winbar",
              "fg"
            ),
            warn = require("copilot-lualine.colors").get_hl_value(
              0,
              "DiagnosticWarn",
              "fg"
            ),
            error = require("copilot-lualine.colors").get_hl_value(
              0,
              "DiagnosticError",
              "fg"
            ),
          }
          table.insert(opts.sections.lualine_x, {
            component = {
              [1] = "copilot",
              -- show_colors = true,
              symbols = {
                spinner_color = colors.winbar,
                status = {
                  icons = {
                    -- enabled = " ",
                    -- sleep = " ", -- auto-trigger disabled
                    -- disabled = " ",
                    -- warning = " ",
                    -- NOTE: Use nf-oct variant to match icon size of above elements <2025-01-02>
                    unknown = " ", -- nf-oct-skip
                    -- unknown = "󰅜 ",
                    -- unknown = " ",
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
            },
            priority = 100,
          })
        end,
      },
    },
  },
}
