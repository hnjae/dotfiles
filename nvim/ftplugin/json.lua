-- To List Filetype: :set filetype? or :set ft?

vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.foldlevel = 9
vim.cmd([[syntax match Comment +\/\/.\+$+]])

if not(packer_plugins['coc.nvim'] and packer_plugins['coc.nvim'].loaded) then
  require('user.lsp').setup({"jsonls"})
end
