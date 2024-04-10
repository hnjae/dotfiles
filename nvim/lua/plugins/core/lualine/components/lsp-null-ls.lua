return function(options)
  -- local lsp_icon = options.icons_enabled and "  " or "" -- nf-oct-gear
  local lsp_icon = options.icons_enabled and " " or "" -- nf-cod-gear
  local hide_width = 65
  local truc_width = 100
  local num_source_semi_limit = 2

  local modules = require("lualine_require").lazy_require({
    sources = "null-ls.sources",
  })

  -- TODO: null-ls 타입(diagnostics, formatter)에 따라 우선 순위로 정렬 <2024-01-10>
  local suppress_sources = {
    codespell = true,
  }

  local lsp_name_fmt = function(name)
    return name:sub(-16, -1) == "_language_server" and name:sub(1, -17) .. "-ls"
      or (name:sub(-3, -1) == "_ls" and name:sub(1, -4) .. "-ls" or name)
  end

  return {
    function()
      -- local lualine_width = options.globalstatus and vim.opt.columns:get()
      --   or vim.fn.winwidth(0)
      local lualine_width = options.globalstatus and vim.o.columns
        or vim.fn.winwidth(0)

      if lualine_width < hide_width then
        return ""
      end

      local clients = vim.lsp.get_active_clients({ bufnr = 0 })
      local names = {}

      ---@type boolean
      local is_null_ls = false
      for _, client in ipairs(clients) do
        if client.name == "null-ls" then
          -- NOTE: selene complains but it works <2023-12-14>
          -- issue: https://github.com/Kampfkarren/selene/issues/224
          is_null_ls = true
          goto continue
        end

        table.insert(names, lsp_name_fmt(client.name))
        ::continue::
      end

      if is_null_ls then
        for _, source in ipairs(modules.sources.get_available(vim.bo.filetype)) do
          if not names[source.name] and not suppress_sources[source.name] then
            table.insert(names, source.name)
            names[source.name] = true
          end
        end
      end

      if next(names) == nil then
        if vim.bo.buftype ~= "" or vim.bo.filetype == "text" then
          return ""
        end

        return (
          options.icons_enabled and (lsp_icon .. "∅")
          or "No active LSP"
        )
      end

      if lualine_width < truc_width then
        return (string.format("%s[%s]", lsp_icon, #names))
      end

      if
        #names > num_source_semi_limit
        and (#names - num_source_semi_limit) > 1
      then
        return string.format(
          "%s%s +[%s]",
          lsp_icon,
          table.concat({ unpack(names, 1, num_source_semi_limit) }, ", "),
          #names - num_source_semi_limit
        )
      end

      return string.format("%s%s", lsp_icon, table.concat(names, ", "))
    end,
    cond = nil,
  }
end
