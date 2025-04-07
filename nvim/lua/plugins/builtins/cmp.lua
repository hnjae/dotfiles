-- LazyExtra's coding.cmp
-- cmdline 설정 별도로 안해도 path 자동완성 등 잘 됨.

---@type LazySpec
return {
  [1] = "hrsh7th/nvim-cmp",
  optional = true,
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")

    -- disable preselect
    opts.completion.completeopt = "menu,menuone,noinsert,noselect"
    opts.preselect = cmp.PreselectMode.None

    -- disable lazyvim's default keymaps
    opts.mapping["<CR>"] = nil
    opts.mapping["<S-CR>"] = nil
    opts.mapping["<C-CR>"] = nil

    local source_name_map = {
      nvim_lsp = "LSP",
    }

    opts.formatting.format = function(entry, item)
      local icons = LazyVim.config.icons.kinds
      if icons[item.kind] then
        item.kind = icons[item.kind] .. item.kind
      end
      item.menu = string.format("[%s]", source_name_map[entry.source.name] or entry.source.name)

      local widths = {
        abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
        menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
      }

      for key, width in pairs(widths) do
        if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
          item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
        end
      end

      return item
    end
  end,

  specs = {
    {
      [1] = "folke/lazydev.nvim",
      optional = true,
      opts = {
        library = {
          "nvim-cmp",
        },
      },
    },
  },
}
