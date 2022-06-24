--
-- $XDG_CONFIG_HOME/nvim/init.lua

require('user.builtin').setup()
require('user.plugins')
vim.cmd('source ' .. _PACKER_COMPILED)
require('user.global-var')
require('user.lsp-setup-global').setup()
require('user.set-plugin').setup()
require('user.mapping').setup()
require('user.autocmd').setup()

-- local paths = vim.fn.uniq(
--   vim.fn.sort(
--   vim.fn.globpath(vim.o.runtimepath, 'lua/set-plugin/*.lua', false, true)
--   ))
-- for _, file in pairs(paths) do
--   vim.cmd('source ' .. file)
-- end

local paths = vim.fn.uniq(
  vim.fn.sort(
  vim.fn.globpath(vim.o.runtimepath, 'vim-include/*.[lv][ui][am]', false, true)
  ))
for _, file in pairs(paths) do
  vim.cmd('source ' .. file)
end

-- vim.cmd([[
-- augroup asciidoc_set
--     autocmd FileType asciidoctor nnoremap <CR> :lua OpenAsciidocFile()<CR>
-- augroup END
-- ]])

-- local include = string.match(line, "^.+%.adoc")
-- link:pass:[My Documents/report.pdf][Get Report]
-- link:pass:[My Documents/report.pdf][Get Report]
-- link:My&#32;Documents/report.pdf[Get Report]
--
vim.cmd([[
let @f='ggO---yyjjpggotitle   :0jjciwlastmod3f rTkrTf xjxgg3joisCJKLanguage : true'
"" T

" p
" kciwlastmodwwwwwwwhkvjrkjIljITlxjxwwwwwhxkx:w'
]])
--
