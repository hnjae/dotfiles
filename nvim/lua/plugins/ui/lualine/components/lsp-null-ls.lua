local icon = require("utils").enable_icon and "" or ""
local hide_width = 65
local truc_width = 100
local num_source_semi_limit = 2

local modules = require("lualine_require").lazy_require({
  sources = "null-ls.sources",
})

-- TODO: null-ls 타입(diagnostics, formatter)에 따라 우선 순위로 정렬 <2024-01-10>
local suppress_sources = {
  -- codespell = true,
}

return {
  function()
    local win_width = vim.fn.winwidth(0)
    if win_width < hide_width then
      return ""
    end

    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    local names = {}

    ---@type string
    local client_name
    local is_null_ls = false
    for _, client in ipairs(clients) do
      if client.name == "null-ls" then
        -- NOTE: selene complains but it works <2023-12-14>
        -- issue: https://github.com/Kampfkarren/selene/issues/224
        is_null_ls = true
        goto continue
      end

      client_name = client.name:sub(-16, -1) == "_language_server"
          and client.name:sub(1, -17) .. "-ls"
        or (
          client.name:sub(-3, -1) == "_ls" and client.name:sub(1, -4) .. "-ls"
          or client.name
        )

      table.insert(names, client_name)
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
      return (
        require("utils").enable_icon and "No active LSP" or (icon .. " ∅")
      )
    end

    if win_width < truc_width then
      return string.format("%s [%s]", icon, #names)
    end

    if
      #names > num_source_semi_limit and (#names - num_source_semi_limit) > 1
    then
      return string.format(
        "%s %s +[%s]",
        icon,
        table.concat({ unpack(names, 1, num_source_semi_limit) }, ", "),
        #names - num_source_semi_limit
      )
    end

    return string.format("%s %s", icon, table.concat(names, ", "))
  end,
  cond = nil,
}
