---@type LazySpec
return {
  [1] = "nvim-lint",
  optional = true,
  opts_extend = {
    "linters_by_ft.text",
    "linters_by_ft.markdown",
    "linters_by_ft.tex",
  },
  cmd = { "LintInfo" },
  opts = function()
    vim.api.nvim_create_user_command("LintInfo", function()
      local filetype = vim.bo.filetype
      local linters = require("lint").linters_by_ft[filetype]

      if linters ~= nil and #linters > 0 then
        vim.notify("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))
      else
        vim.notify("No linters configured for filetype: " .. filetype)
      end
    end, {})
  end,
}
