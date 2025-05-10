---@type LazySpec
return {
  [1] = "copilot.lua",
  optional = true,
  keys = {
    -- <Leader>ua default: Toggle Animation
    -- TODO: 이거 안먹는데?? <2025-05-01>
    -- Snacks.toggle.animate():map("<leader>ua") 가 먹고 있어서 그런가.
    {
      [1] = "<leader>ua",
      [2] = "<cmd>Copilot toggle<CR>",
      desc = "copilot-toggle",
    },
  },
  opts = {
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
      dependencies = { "copilot-lualine" },
      opts = function(_, opts)
        opts.sections = opts.sections or {}
        opts.sections.lualine_x = opts.sections.lualine_x or {}

        local colors = {
          winbar = require("copilot-lualine.colors").get_hl_value(0, "Winbar", "fg"),
          warn = require("copilot-lualine.colors").get_hl_value(0, "DiagnosticWarn", "fg"),
          error = require("copilot-lualine.colors").get_hl_value(0, "DiagnosticError", "fg"),
        }

        -- for _, component in ipairs(opts.sections.lualine_x) do
        --   -- if component[1] == "copilot" then
        --   -- end
        -- end

        -- HACK: Lazyvim 14.14.0 기준 , 기존 copliot 아이콘 제거
        table.remove(opts.sections.lualine_x, 2) --remove

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
}
