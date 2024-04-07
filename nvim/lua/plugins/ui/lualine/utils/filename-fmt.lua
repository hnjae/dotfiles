local utils = require("utils")
local get_icon = require("plugins.ui.lualine.utils.get-icon")

local ft_data = require("plugins.ui.lualine.utils.ft-data")
-- local ft_names = {}
-- for key, val in pairs(fts) do
-- end

-- local ft_names = {
--   --
--   checkhealth = "CheckHealth",
--   qf = "QuickFix",
--   netrw = "Netrw",
--   --
--   toggleterm = "ToggleTerm",
--   TelescopePrompt = "Telescope",
--   dashboard = "Dashboard",
--   packer = "Packer",
--   fzf = "FZF",
--   alpha = "Alpha",
--   -- sidebar
--   oil = "Oil",
--   tagbar = "Tagbar",
--   Outline = "Outline",
--   NvimTree = "NvimTree",
--   ["neo-tree"] = "NeoTree",
--   -- lspsaga
--   sagafinder = "SagaFinder",
--   sagaoutline = "SagaOutline",
--   -- popup
--   saga_codeaction = "Saga CodeAction",
--   sagarename = "SagaRename",
--   ["neo-tree-popup"] = "NeoTree Popup",
--   noice = "Noice",
--   --
--   ["chatgpt-input"] = "ChatGPT Input",
-- }

---@type fun(name: string, context: table): string
return function(name, context)
  if ft_data[context.filetype] and ft_data[context.filetype][1] then
    name = ft_data[context.filetype][1]
  elseif
    context.buftype == "nofile"
    and context.filetype ~= ""
    and vim.b[context.bufnr].did_ftplugin ~= nil
  then
    -- e.g. preview pane of LspSaga's outline/hover
    -- name = utils.enable_icon and "󱔘 " or "[DOCUMENT]" -- nf-md-file_document_multiple_outline
    name = "[DOCUMENT]"
    -- vim.notify(vim.inspect(context))
  end

  if utils.enable_icon then
    local icon = get_icon(
      vim.fn.expand(string.format("#%s:t", tostring(context.bufnr))),
      context.filetype,
      context.buftype
    )

    if not icon then
      return name
    end

    return string.format("%s %s", icon, name)
  end

  return name
end
