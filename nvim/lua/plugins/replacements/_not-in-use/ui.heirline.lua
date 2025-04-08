local ViMode = {
  static = {
    mode_names = { ... },
  },
  provider = function(self)
    return " %2(" .. self.mode_names[vim.fn.mode(1)] .. "%)"
  end,
  hl = function(self)
    local color = self:mode_color() -- here!
    return { fg = color, bold = true }
  end,
}

local Ruler = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  provider = "%7(%l/%3L%):%2c %P",
}
local Align = { provider = "%=" }
local Space = { provider = " " }

---@type LazySpec[]
return {
  {
    [1] = "rebelot/heirline.nvim",
    version = "*",

    lazy = false,
    opts = {
      statusline = {
        -- ViMode,
        Align,
        Ruler,
      },
      winbar = {},
      tabline = {},
      -- ruler 가 보이는 곳
      statuscolumn = {},
    },
    config = function(_, opts)
      require("heirline").setup(opts)

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

      vim.api.nvim_create_augroup("Heirline", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          utils.on_colorscheme(setup_colors)
        end,
        group = "Heirline",
      })
    end,
  },
  {
    [1] = "lualine.nvim",
    optional = true,
    enabled = false,
  },
}
