---@type LazyPluginSpec
local spec = {
  [1] = "lualine.nvim",
  optional = true,
  opts = function(_, opts)
    local formatter_icon = require("globals").icons.sort

    local hide_width = 65
    local truc_width = 110
    local num_source_light_limit = 2

    ---@param icon string
    ---@param sources string[]
    local fmt = function(icon, sources)
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

    local modules = require("lualine_require").lazy_require({
      conform = "conform",
    })

    local component = {
      [1] = function()
        local formatters, will_fallback_lsp = modules.conform.list_formatters_to_run(0)

        local sources = vim.tbl_map(function(formatter)
          return formatter.name
        end, formatters)

        if #sources == 0 and will_fallback_lsp then
          table.insert(sources, "LSP")
        end

        return fmt(formatter_icon, sources)
      end,
      cond = function()
        return (vim.o.columns > hide_width)
      end,
    }

    table.insert(opts.sections.lualine_x, component)
  end,
}

---@type LazySpec
return {
  [1] = "conform.nvim",
  optional = true,
  specs = { spec },
}
