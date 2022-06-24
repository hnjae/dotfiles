-- Enabling Provider (Python, Node.js, Ruby)

if vim.fn.has('mac') == 1 then
  vim.g.python3_host_prog = '/usr/local/bin/python3'
elseif vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
  vim.g.python3_host_prog = ''
end

vim.g.loaded_ruby_provider = 0    -- disable ruby
vim.g.loaded_python_provider = 0  -- disable python2
vim.g.loaded_perl_provider = 0    -- disable perl
