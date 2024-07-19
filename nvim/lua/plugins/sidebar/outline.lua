local prefix = require("val").prefix
local map_keyword = require("val").map_keyword

---@type LazySpec
return {
  [1] = "hedyhli/outline.nvim",
  lazy = true,
  cmd = {
    "Outline",
    "OutlineOpen",
    "OutlineClose",
    "OutlineFocus",
    "OutlineFocusCode",
    "OutlineFocusOutline",
    "OutlineFollow",
    "OutlineStatus",
    "OutlineRefresh",
  },
  ---@type LazyKeysSpec[]
  ---@type fun(LazyPlugin, keys: LazyKeysSpec[]): nil
  keys = function(_, keys)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.supports_method("textDocument/documentSymbol") then
          vim.keymap.set(
            "n",
            prefix.sidebar .. map_keyword.symbols,
            "<cmd>Outline<CR>",
            { buffer = args.buf, desc = "outline (symbols)" }
          )
          vim.keymap.set(
            "n",
            prefix.focus .. map_keyword.symbols,
            "<cmd>OutlineFocus<CR>",
            { buffer = args.buf, desc = "outline (symbols)" }
          )
        end
      end,
    })
  end,
  dependencies = {
    "onsails/lspkind.nvim",
    "neovim/nvim-lspconfig",
  },
  opts = {
    symbols = {
      icon_source = "lspkind",
    },
    outline_window = {
      width = 20,
    },
  },
}
