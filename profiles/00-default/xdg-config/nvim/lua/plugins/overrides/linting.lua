---@type LazySpec
return {
  [1] = "nvim-lint",
  optional = true,
  opts_extend = {
    "linters_by_ft.text",
    "linters_by_ft.markdown",
    "linters_by_ft.rst",
    "linters_by_ft.tex",
    "linters_by_ft.asciidoc",
    "linters_by_ft.org",
    "linters_by_ft.xml",
    "linters_by_ft.html",
    "linters_by_ft.*",
  },
  cmd = { "LintInfo" },
  -- keys = {
  --   { [1] = "<leader>cL", [2] = "<cmd>LintInfo<CR>", desc = "lint-info" },
  -- },
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
