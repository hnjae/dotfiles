-- Enabling Provider (Python, Node.js, Ruby)


local temp = vim.fn.execute("!pyenv which python3")
local ps, pe = vim.regex("/[a-zA-Z0-9/]*"):match_str(temp)
if ps ~= nil then
  vim.g.python3_host_prog = temp:sub(ps+1, pe)
  -- vim.g.python3_host_prog = "~/.local/share/pyenv/shims/python3"
elseif vim.fn.has('mac') == 1 then
  vim.g.python3_host_prog = '/usr/local/bin/python3'
else
  vim.g.python3_host_prog = "/usr/bin/python3"
end

vim.g.loaded_ruby_provider = 0    -- disable ruby
vim.g.loaded_python_provider = 0  -- disable python2
vim.g.loaded_perl_provider = 0    -- disable perl
