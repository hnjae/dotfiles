local trunc = require("plugins.ui.lualine.utils").trunc

return {
  -- Lsp server name .
  function()
    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    local names = {}

    ---@type string
    local client_name
    for _, client in ipairs(clients) do
      if client.name == "null-ls" then
        -- TODO: selene complains but it works <2023-12-14>
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

    return table.concat(names, ", ")
  end,
  icon = require("utils").is_console and "" or "",
  cond = nil,
  fmt = trunc(100, 0, 85, 28, false),
}
