return {
  -- Lsp server name .
  function()
    local msg = "No Active LSP"

    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    if next(clients) == nil then
      return msg
    end

    local names = {}
    --@type string
    local client_name
    for _, client in ipairs(clients) do
      client_name = client.name:sub(-16, -1) == "_language_server" and client.name:sub(1, -17) .. "-ls" or client.name

      table.insert(names, client_name)
    end

    if next(names) == nil then
      return msg
    end

    return table.concat(names, ", ")
  end,
  icon = "",
  cond = function()
    return (next(vim.lsp.get_active_clients()) ~= nil)
  end,
}
