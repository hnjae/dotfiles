-- let g:gutentags_dont_load = 1
-- if packer_plugins and packer_plugins['vim-gutentags'] and packer_plugins['vim-gutentags'].loaded then
if _IS_PLUGIN('vim-gutentags') then
  local status_util, util = pcall(require, 'packer/util')
  if status_util then
    vim.g.gutentags_cache_dir = util.join_paths(vim.fn.stdpath('cache'), "gutentags")
  -- elseif vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
  --   vim.g.gutentags_cache_dir = vim.fn.stdpath('cache') .. "\\gutentags"
  else
    vim.g.gutentags_cache_dir = vim.fn.stdpath('cache') .. "/gutentags"
  end

  vim.g.gutentags_exclude_filetypes = {
    '',
    'fugitive',
    'nerdtree',
    'tagbar',
    'help',
  }
end
