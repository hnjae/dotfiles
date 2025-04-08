---@type LazyPluginSpec
local spec = {
  [1] = "lualine.nvim",
  optional = true,
  opts = function(_, opts)
    local hide_width = 40
    local truc_width = 100
    local suppress_sources = {
      ["null-ls"] = true,
      ["copilot"] = true,
    }

    local lsp_icon = (require("globals").icons.codicons.gear .. " ")

    local lsp_name_fmt = function(name)
      return name:sub(-16, -1) == "_language_server" and name:sub(1, -17) .. "-ls"
        or (name:sub(-3, -1) == "_ls" and name:sub(1, -4) .. "-ls" or name)
    end

    local lsp_filter = function(name)
      return suppress_sources[name] == nil and true or false
    end

    local component = {
      [1] = function()
        local lualine_width = vim.o.columns -- or vim.fn.winwidth(0) if not using globalstatus

        if lualine_width < hide_width then
          return ""
        end

        local clients = vim.lsp.get_clients({ bufnr = 0 })

        local names = {}
        ---@type boolean
        for _, client in ipairs(clients) do
          if lsp_filter(client.name) then
            table.insert(names, lsp_name_fmt(client.name))
          end
        end

        if next(names) == nil then
          return ""
        end

        if lualine_width < truc_width then
          return (string.format("%s[%s]", lsp_icon, #names))
        end

        return string.format("%s%s", lsp_icon, table.concat(names, ", "))
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
