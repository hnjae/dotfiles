---@type LazySpec
return {
  [1] = "nvim-lint",
  optional = true,
  cmd = { "LintInfo" },
  opts = function()
    vim.api.nvim_create_user_command("LintInfo", function()
      local filetype = vim.bo.filetype
      local linters = require("lint").linters_by_ft[filetype]

      if #linters == 0 then
        vim.notify("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))
      else
        vim.notify("No linters configured for filetype: " .. filetype)
      end
    end, {})
  end,
}
