-- LazyExtra's coding.nvim-cmp
-- cmdline 설정 별도로 안해도 path 자동완성 등 잘 됨.

---@type LazySpec
return {
  [1] = "nvim-cmp",
  optional = true,
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    -- disable transparency
    vim.opt.pumblend = 0
    vim.cmd([[
      hi Pmenu blend=0
      hi PmenuSel blend=0
    ]])
    -- vim.api.nvim_set_hl(0, "Pmenu", { blend = 0, default = true })
    -- vim.api.nvim_set_hl(0, "PmenuSel", { blend = 0, default = true })

    local cmp = require("cmp")

    -- disable preselect
    opts.completion.completeopt = "menu,menuone,noinsert,noselect"
    opts.preselect = cmp.PreselectMode.None

    -- disable lazyvim's default keymaps
    opts.mapping["<CR>"] = nil
    opts.mapping["<S-CR>"] = nil
    opts.mapping["<C-CR>"] = nil

    -- configure formatting
    local source_name_map = {
      nvim_lsp = "LSP",
    }

    opts.formatting.format = function(entry, item)
      -- if kind_icons[item.kind] then
      --   item.kind = kind_icons[item.kind] .. item.kind
      -- end
      -- if kind_icons[item.kind] then
      -- end
      item.kind = LazyVim.config.icons.kinds[item.kind] or item.kind
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

    -- sorting
    opts.sorting.priority_weight = 10
  end,

  specs = {},
}
