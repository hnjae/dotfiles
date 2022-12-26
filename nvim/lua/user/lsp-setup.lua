--[[
  어떤 이유인지 모르겠지만, ftplugin 에서 선언하면 작동하지 않는 것들을 있어,
  여기에 둠.
]]
-- coc 로 이주해서 outdated 함.

local status_lsp, lsp = pcall(require, "user.lsp")
local M = {}

function M.setup()
  if _IS_PLUGIN("coc.nvim") or not status_lsp then
    return
  end

  -- TODO: for ansiblels, ft 도 yaml.ansiblels 로 바꿀것.
  -- ansiblels
  vim.api.nvim_create_autocmd(
    {
      "BufRead", "BufNewFile"
    }, {
      -- pattern = {"*wiki/*.md"},
      pattern = { "*.sh" },
      callback = function()
        lsp.setup({"bashls"})
      end
    }
  )

  -- vim.api.nvim_create_autocmd(
  --   {
  --     "BufRead", "BufNewFile"
  --   }, {
  --     -- pattern = {"*wiki/*.md"},
  --     pattern = { "*.lua" },
  --     callback = function()
  --       lsp.setup({"sumneko_lua"})
  --     end
  --   }
  -- )
  lsp.setup({"sumneko_lua"})
  vim.api.nvim_create_autocmd(
    {
      "BufRead", "BufNewFile", "BufNew"
    }, {
      -- pattern = {"*wiki/*.md"},
      pattern = { "*ansible*/*.yml" },
      callback = function()
        vim.bo.filetype = "yaml.ansible"
      end
    }
  )
  lsp.setup({"ansiblels"})
  lsp.setup({"yamlls"})
  lsp.setup({"jsonls"})

  -- test
  require('user.lsp').setup({ "pylsp", "pyright" })
  -- require('user.lsp').setup({ "pylsp" })
end

return M
