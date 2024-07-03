-- alternative: https://github.com/utilyre/barbecue.nvim

---@type LazySpec
local M = {
  [1] = "nvimdev/lspsaga.nvim",
  lazy = true,
  event = "LspAttach",
  enabled = true,
  dependencies = {
    { [1] = "nvim-tree/nvim-web-devicons", optional = true },
    "nvim-treesitter/nvim-treesitter",
  },
  opts = function()
    local utils = require("utils")
    local map_keyword = require("val").map_keyword

    local ret = {
      scroll_preview = {
        scroll_down = "<C-f>",
        scroll_up = "<C-b>",
      },
      code_action = {
        show_server_name = true,
        extend_gitsigns = utils.is_plugin("gitsigns.nvim"),
      },

      lightbulb = {
        -- NOTE: textDocument/codeAction 을 지원안할 경우, 에러 메시지 송출 <2024-04-07>
        enable = false,
      },

      hover = {
        open_cmd = "!" .. utils.get_browser_cmd(),
      },
      symbol_in_winbar = {
        -- alternatives https://github.com/utilyre/barbecue.nvim
        -- Breadcrumbs
        enable = not utils.is_plugin("lualine.nvim"),
        delay = 500, -- default: 300
      },
      diagnostic = {
        extend_relatedInformation = true,
        exec_action = map_keyword.execute,
      },
      finder = {
        -- methods = {},
        keys = {
          -- shuttle = "[w",
          -- toggle_or_open = "o",
          vsplit = map_keyword.vsplit,
          split = map_keyword.split,
          tabe = map_keyword.tab,
          -- tabnew = "r",
          -- quit = "q",
          -- close = "<C-c>k",
        },
      },

      -- require(lspsaga.symbol.winbar).get_bar()
      definition = {
        width = 0.6,
        height = 0.5,
        save_pos = false,
        keys = {
          edit = string.format("<C-c>%s", map_keyword.current),
          tabe = string.format("<C-c>%s", map_keyword.tab),
          vsplit = string.format("<C-c>%s", map_keyword.vsplit),
          split = string.format("<C-c>%s", map_keyword.split),
          -- quit = "q",
          -- close = "<C-c>k",
        },
      },
    }

    if require("utils").enable_icon then
      ret.ui = {
        border = "rounded",
        devicons = true,
        expand = "", -- nf-cod-expand_all
        collapse = "", -- nf-cod-collapse_all
        code_action = require("val").icons.signs.code_action,
        actionfix = " ", -- nf-cod-lightbulb_autofix
        imp_sign = "", -- nf-cod-wand
      }
    else
      ret.ui = {
        devicons = false,
        code_action = "!",
        actionfix = "!F",
        imp_sign = "I",
      }
    end
    return ret
  end,
  cmd = {
    "Lspsaga",
  },
  keys = function()
    local val = require("val")
    local map_keyword = val.map_keyword
    local prefix = val.prefix

    local ret = {
      { [1] = "sL", [2] = vim.lsp.buf.hover, desc = "lspsaga-test" },
      {
        [1] = prefix.sidebar .. map_keyword.lsp,
        [2] = "<cmd>Lspsaga outline<CR>",
        desc = "lspsaga-outline",
      },
      --------------------------------------------------------------------------
      -- {{{ Finder
      --------------------------------------------------------------------------
      {
        [1] = string.format("%s%s%s", prefix.buffer, map_keyword.lsp, "f"),
        [2] = "<cmd>Lspsaga finder<CR>",
        desc = "lspsaga-finder",
      },
      -- }}}
    }

    return ret
  end,
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function(_, opts)
        -- :h lualine-Custom-components
        local modules = require("lualine_require").lazy_require({
          lspsaga = "lspsaga.symbol.winbar",
        })

        local disabled_buftypes = {
          "picker",
          "prompt",
          "nofile",
          "nowrite",
          "quickfix",
          "terminal",
        }

        local component = {
          [1] = modules.lspsaga.get_bar,
          cond = function()
            return not vim.tbl_contains(disabled_buftypes, vim.bo.buftype)
          end,
          fmt = function(str)
            -- NOTE: nil 이 아닌  "nil" 이거 오타 아님. <2024-04-05>
            return str == "nil" and "" or str
          end,
        }

        table.insert(opts.tabline.lualine_a, component)
      end,
    },
  },
}

return M
