-- :h lualine-Custom-components
return function(options)
  local modules = require("lualine_require").lazy_require({
    lspsaga = "lspsaga.symbol.winbar",
  })
  local disabled_buftypes = {
    "picker",
    "prompt",
    "nofile",
    "nowrite",
    "quickfix",
    "terminal",
  }

  return {
    [1] = modules.lspsaga.get_bar,
    cond = function()
      return not vim.tbl_contains(disabled_buftypes, vim.bo.buftype)
    end,
    fmt = function(str)
      -- NOTE: nil 이 아닌  "nil" 이거 오타 아님. <2024-04-05>
      return str == "nil" and "" or str
    end,
  }
end
