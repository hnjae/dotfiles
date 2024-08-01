---@type LazySpec
return {
  [1] = "Bekaboo/dropbar.nvim",
  enabled = vim.fn.has("nvim-0.10") == 1 and false,
  lazy = true,
  event = { "VeryLazy" },
  dependencies = {
    { [1] = "nvim-tree/nvim-web-devicons", optional = true },
    { [1] = "onsails/lspkind.nvim", optional = true },
  },
  opts = function(_, opts)
    -- TODO: symbols 선언 부분은 lspkind 쪽 spec으로 옮기는게 좋아보인다.
    local utils = require("utils")
    local symbols =
      vim.tbl_deep_extend("keep", require("lspkind").symbol_map, {})
    for key, val in pairs(symbols) do
      symbols[key] = val .. " "
    end

    return vim.tbl_deep_extend("keep", {
      general = {
        enable = false,
      },
      icons = {
        enable = utils.enable_icon,
        kinds = {
          use_devicons = utils.is_plugin("nvim-web-devicons"),
          symbols = symbols,
        },
      },
    }, opts or {})
  end,
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function(_, opts)
        -- :h lualine-Custom-components

        local disabled_buftypes = {
          "picker",
          "prompt",
          "nofile",
          -- "nowrite",
          "quickfix",
          -- "terminal",
        }

        local component = {
          [1] = function()
            -- INFO: function 으로 감싸야함. <2024-08-01>
            return _G.dropbar.get_dropbar_str()
          end,
          cond = function()
            return vim.api.nvim_buf_is_valid(0)
              and vim.api.nvim_win_is_valid(0)
              and vim.fn.win_gettype(0) == ""
              and vim.bo.ft ~= "help"
              and not vim.tbl_contains(disabled_buftypes, vim.bo.buftype)
            -- and ((pcall(vim.treesitter.get_parser, buf)) and true or false)
          end,
          -- fmt = function(str)
          -- NOTE: nil 이 아닌  "nil" 이거 오타 아님. <2024-04-05>
          -- return str == "nil" and "" or str
          -- end,
        }

        if not opts.tabline then
          opts.tabline = {}
        end
        if not opts.tabline.lualine_a then
          opts.tabline.lualine_a = {}
        end

        table.insert(opts.tabline.lualine_a, component)

        local icons = require("val").icons
        require("state.lualine-ft-data"):add({
          dropbar_menu = { display_name = "Dropbar Menu", icon = icons.menu },
        })
      end,
    },
  },
}
