local _confs = {}

return function()
  if next(_confs) ~= nil then
    return _confs
  end

  local paths = vim.fn.uniq(
    vim.fn.sort(
      vim.fn.globpath(
        vim.fn.stdpath("config"),
        "lua/plugins/lsp/configs/*.lua",
        false,
        true
      )
    )
  )

  for _, file in pairs(paths) do
    table.insert(
      _confs,
      require("plugins.lsp.configs." .. file:match("[^/\\]+$"):sub(1, -5))
    )
  end
  return _confs
end
