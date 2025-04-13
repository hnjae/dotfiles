---@type LazyPluginSpec
local spec = {
  [1] = "lualine.nvim",
  optional = true,
  opts = function(_, opts)
    local icon = "󰟢 " -- nf-md-null

    local hide_width = 40
    local truc_width = 100
    local modules = require("lualine_require").lazy_require({
      sources = "null-ls.sources",
    })
    local suppress_sources = {}
    local num_source_light_imit = 2

    local component = {
      [1] = function()
        local lualine_width = vim.o.columns -- or vim.fn.winwidth(0) if not using globalstatus

        if lualine_width < hide_width then
          return ""
        end

        local clients = vim.lsp.get_clients({ bufnr = 0, name = "null-ls" })

        local is_null_ls = #clients ~= 0

        local names = {}
        if is_null_ls then
          for _, source in ipairs(modules.sources.get_available(vim.bo.filetype)) do
            if not names[source.name] and not suppress_sources[source.name] then
              table.insert(names, source.name)
              names[source.name] = true
            end
          end
        end

        if next(names) == nil then
          return ""
        end

        if lualine_width < truc_width then
          return (string.format("%s[%s]", icon, #names))
        end

        if #names > num_source_light_imit and (#names - num_source_light_imit) > 1 then
          return string.format(
            "%s%s +[%s]",
            icon,
            table.concat({ unpack(names, 1, num_source_light_imit) }, ", "),
            #names - num_source_light_imit
          )
        end

        return string.format("%s%s", icon, table.concat(names, ", "))
      end,
      cond = nil,
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
