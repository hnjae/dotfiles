local trunc = require("plugins.ui.lualine.utils").trunc

local modules = require("lualine_require").lazy_require({
  sources = "null-ls.sources",
})

local suppress_sources = {
  codespell = true,
}

return {
  [1] = function()
    local names = {}

    -- null-ls 가 활성화 되어있는지 확인
    local clients = vim.lsp.get_active_clients({ bufnr = 0, name = "null-ls" })
    if next(clients) == nil then
      return ""
    end

    local filetype = vim.api.nvim_buf_get_option(0, "filetype")
    for _, source in ipairs(modules.sources.get_available(filetype)) do
      if not names[source.name] and not suppress_sources[source.name] then
        table.insert(names, source.name)
        names[source.name] = true
      end
    end

    return table.concat(names, ", ")
  end,
  icon = require("utils").enable_icon and "" or "󰟢",
  -- NOTE: lualine 은 출력이 없을 경우를 별도로 체크할 필요가 없다. <2023-12-28>
  cond = nil,
  fmt = trunc(110, 0, 90, 20, false),
}
