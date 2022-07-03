local M = {}
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
table.insert(runtime_path, "lua/user/?.lua")
table.insert(runtime_path, "lua/user/?/init.lua")
table.insert(runtime_path, "plugin/?.lua")
table.insert(runtime_path, "vim-include/?.lua")
-- table.insert(_PACKER_COMPILED)

M.opts = {
  -- TODO: vim 설정파일 일때만 다음과 같이 설정하기  <2022-05-08, Hyunjae Kim> --
  settings = {
    Lua = {
      runtime = {
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        -- TODO: Hammerspoon <2022-06-30, Hyunjae Kim>
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

return M
