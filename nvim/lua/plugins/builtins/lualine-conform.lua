---@type LazyPluginSpec
local spec = {
  [1] = "lualine.nvim",
  optional = true,
  opts = function(_, opts)
    local hide_width = 40
    local truc_width = 100
    local num_source_semi_limit = 2

    local icon = (require("globals").icons.sort .. " ")

    local modules = require("lualine_require").lazy_require({
      conform = "conform",
    })

    local component = {
      [1] = function()
        local lualine_width = vim.o.columns -- or vim.fn.winwidth(0)

        if lualine_width < hide_width then
          return ""
        end

        local formatters, will_fallback_lsp = modules.conform.list_formatters_to_run(0)

        local names = {}
        for _, formatter in ipairs(formatters) do
          table.insert(names, formatter.name)
        end

        if #names == 0 and will_fallback_lsp then
          table.insert(names, "LSP")
        end

        if #names == 0 then
          return ""
        end

        if lualine_width < truc_width then
          return (string.format("%s[%s]", icon, #names))
        end

        if #names > num_source_semi_limit and (#names - num_source_semi_limit) > 1 then
          return string.format(
            "%s%s +[%s]",
            icon,
            table.concat({ unpack(names, 1, num_source_semi_limit) }, ", "),
            #names - num_source_semi_limit
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
  [1] = "nvim-lspconfig",
  optional = true,
  specs = { spec },
}
