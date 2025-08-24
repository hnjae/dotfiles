-- local package_path = (...)
local package_path = "plugins.replacements.ui-heirline"

---@type LazySpec[]
return {
  {
    [1] = "lualine.nvim",
    optional = true,
    enabled = false,
  },
  {
    [1] = "bufferline.nvim",
    optional = true,
    enabled = false,
  },
  {
    [1] = "rebelot/heirline.nvim",
    version = "*",

    lazy = false,
    opts = {},
    config = function(_, opts)
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")

      local function setup_colors()
        return {
          bright_bg = utils.get_highlight("Folded").bg,
          bright_fg = utils.get_highlight("Folded").fg,
          red = utils.get_highlight("DiagnosticError").fg,
          dark_red = utils.get_highlight("DiffDelete").bg,
          green = utils.get_highlight("String").fg,
          blue = utils.get_highlight("Function").fg,
          gray = utils.get_highlight("NonText").fg,
          orange = utils.get_highlight("Constant").fg,
          purple = utils.get_highlight("Statement").fg,
          cyan = utils.get_highlight("Special").fg,
          diag_warn = utils.get_highlight("DiagnosticWarn").fg,
          diag_error = utils.get_highlight("DiagnosticError").fg,
          diag_hint = utils.get_highlight("DiagnosticHint").fg,
          diag_info = utils.get_highlight("DiagnosticInfo").fg,
          git_del = utils.get_highlight("diffDeleted").fg,
          git_add = utils.get_highlight("diffAdded").fg,
          git_change = utils.get_highlight("diffChanged").fg,
        }
      end

      local Align = { provider = "%=" }
      local Space = { provider = " " }

      local group_id = vim.api.nvim_create_augroup("Heirline", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          utils.on_colorscheme(setup_colors)
        end,
        group = group_id,
      })

      local modules = { conditions = conditions, utils = utils }

      opts.statusline = opts.statusline or {}
      opts.statusline = {
        require(package_path .. ".statuslines.vi-mode"),
        require(package_path .. ".statuslines.file-type")(modules),
        require(package_path .. ".statuslines.file-encoding"),
        Align,
        require(package_path .. ".statuslines.lsp-active")(modules),
        Space,
        require(package_path .. ".statuslines.ruler"),
      }

      opts.tabline = require(package_path .. ".tabline")(modules)

      require("heirline").setup(opts)
    end,
  },
}
