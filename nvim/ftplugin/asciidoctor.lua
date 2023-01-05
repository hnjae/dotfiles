vim.opt_local.tabstop = 8
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.colorcolumn = "0"
vim.opt_local.conceallevel = 2

local status_wk, wk = pcall(require, "which-key")

-- if _IS_PLUGIN('vim-asciidoctor') and status_wk then
if status_wk then
  local buffer_keymap = {
    ["sp"] = { ":AsciidoctorOpenRAW<CR>" , "preview-browser" },
  }

  wk.register(
    buffer_keymap, {mode = "n", silent = true, noremap = true, buffer = 0 }
  )
end


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
