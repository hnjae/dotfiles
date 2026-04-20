---@type LazyPluginSpec
local spec = {
  [1] = "lualine.nvim",
  optional = true,
  opts = function(_, opts)
    local nil_icon = "󰟢 " -- nf-md-null

    local hide_width = 65
    local truc_width = 110
    local suppress_sources = {}
    local num_source_light_limit = 1
    -- local lualine_width = vim.o.columns -- or vim.fn.winwidth(0) if not using globalstatus

    ---@param icon string
    ---@param sources string[]
    local fmt = function(icon, sources)
      sources = vim.tbl_filter(function(source)
        return not vim.tbl_contains(suppress_sources, source)
      end, sources)

      if #sources == 0 then
        return ""
      end

      if vim.o.columns < truc_width then
        return (string.format("%s[%s]", icon, #sources))
      end

      if #sources > num_source_light_limit and (#sources - num_source_light_limit) > 1 then
        return string.format(
          "%s%s +[%s]",
          icon,
          table.concat({ unpack(sources, 1, num_source_light_limit) }, ", "),
          #sources - num_source_light_limit
        )
      end

      return string.format("%s%s", icon, table.concat(sources, ", "))
    end

    ------

    local modules = require("lualine_require").lazy_require({
      sources = "null-ls.sources",
    })

    local component = {
      [1] = function()
        local sources = vim.tbl_map(function(nil_source)
          return nil_source.name
        end, modules.sources.get_available(vim.bo.filetype))

        return fmt(nil_icon, sources)
      end,

      cond = function()
        return (vim.o.columns > hide_width)
          and #(vim.lsp.get_clients({ bufnr = 0, name = "null-ls" })) ~= 0
      end,
    }

    table.insert(opts.sections.lualine_x, component)
  end,
}

---@type LazySpec
return {
  [1] = "none-ls.nvim",
  optional = true,
  specs = { spec },
}
