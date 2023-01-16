vim.opt_local.tabstop = 8
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.colorcolumn = "0"
vim.opt_local.conceallevel = 2

local status, nvim_autopairs = pcall(require, "nvim-autopairs")
if status then
  local rule = require('nvim-autopairs.rule')
  nvim_autopairs.add_rules( {
      rule("`+", "+`", "asciidoctor"),
      rule("`+", "+`", "asciidoc"),
      rule("``", "``", "asciidoctor"),
      rule("``", "``", "asciidoc"),
  })
  nvim_autopairs.remove_rule('`')
end
-- {'```': '```', '`': '`', '"': '"', '{': '}', '''': '''', '(': ')', '''''''': '''''''', '[': ']', '"""': '"""'}

-- require("asciidoc_wiki").buffer_setup()
-- if _IS_PLUGIN("asciidoc-wiki") then
-- end
