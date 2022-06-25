-- To List Filetype: :set filetype? or :set ft?

vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.foldmethod = "marker"
vim.opt_local.foldlevel = 0
vim.opt_local.colorcolumn = vim.fn.join(vim.fn.range(81, 999), ",")

if _IS_PLUGIN('auto-pairs') then
  vim.b.AutoPairs = {
    ["''"] = "''",
    -- ['"'] = '"',
    -- ['"""'] = '"""',
    ["'"] = "'",
    ["'''"] = "'''",
    ["("] = ")",
    ["["] = "]",
    ["`"] = "`",
    ["```"] = "```",
    ["{"] = "}"
  }
end
