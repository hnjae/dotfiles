---@type LazyPluginSpec
local spec = {
  [1] = "lualine.nvim",
  optional = true,
  opts = function(_, opts)
    local lsp_icon = require("globals").icons.cog

    local hide_width = 60
    local truc_width = 105
    -- local lualine_width = vim.o.columns -- or vim.fn.winwidth(0) if not using globalstatus
    local num_source_light_limit = 2

    local suppress_sources = {
      ["null-ls"] = true,
      ["copilot"] = true,
      ["typos_lsp"] = true,
    }
    local rename_sources = {
      -- typos_lsp = "typos",
    }

    ---@param icon string
    ---@param sources string[]
    local fmt = function(icon, sources)
      sources = vim.tbl_filter(function(source)
        return not suppress_sources[source]
      end, sources)

      if #sources == 0 then
        return ""
      end

      sources = vim.tbl_map(function(source)
        return rename_sources[source]
          or (source:sub(-3, -1) == "_ls" and source:sub(1, -4) .. "-ls")
          or source
      end, sources)

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

    local component = {
      [1] = function()
        local sources = vim.tbl_map(function(lsp_client)
          return lsp_client.name
        end, vim.lsp.get_clients({ bufnr = 0 }))

        return fmt(lsp_icon, sources)
      end,

      cond = function()
        return (vim.o.columns > hide_width) and #(vim.lsp.get_clients({ bufnr = 0 })) ~= 0
      end,
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
