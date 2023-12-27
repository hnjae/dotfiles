local prefix = require("val").prefix
local map_keyword = require("val").map_keyword

--------------------------------------------------------------------------------
-- leader & localleader
--------------------------------------------------------------------------------
vim.g.mapleader = " "
-- NOTE: , : repeat t/T/f/F backwards
vim.g.maplocalleader = ","

--------------------------------------------------------------------------------
-- disable some default behavior
--------------------------------------------------------------------------------
-- disable s/S, use c/0C instead
-- NOTE: do not include selection mode here <2023-07-20>
vim.keymap.set({ "n", "x", "o" }, "s", "<Nop>")
vim.keymap.set({ "n", "x", "o" }, "S", "<Nop>")

--------------------------------------------------------------------------------
-- escape teriminal
vim.keymap.set({ "t" }, "<S-Esc>", "<C-\\><C-n>", { desc = "escape-terminal" })

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- open new page with current buffer
vim.keymap.set({ "n" }, prefix.vsplit .. prefix.vsplit:sub(-1, -1), "<cmd>vsplit<CR>", { desc = "current-buffer" })
vim.keymap.set({ "n" }, prefix.split .. prefix.split:sub(-1, -1), "<cmd>split<CR>", { desc = "current-buffer" })
vim.keymap.set({ "n" }, prefix.tab .. prefix.tab:sub(-1, -1), "<cmd>tabedit %<CR>", { desc = "current-buffer" })

-- open new page with an empty window
vim.keymap.set({ "n" }, prefix.vsplit .. "e", "<cmd>vnew<CR>", { desc = "empty-file" })
vim.keymap.set({ "n" }, prefix.split .. "e", "<cmd>new<CR>", { desc = "empty-file" })
vim.keymap.set({ "n" }, prefix.tab .. "e", "<cmd>tabedit<CR>", { desc = "empty-file" })

--------------------------------------------------------------------------------

local nmapping = {
  { "n",  vim.lsp.buf.rename,                  { desc = "lsp-rename" } },
  { "a",  vim.lsp.buf.code_action,             { desc = "lsp-code-action" } },
  { "wa", vim.lsp.buf.add_workspace_folder,    { desc = "lsp-add-workspace" } },
  { "wr", vim.lsp.buf.remove_workspace_folder, { desc = "lsp-remove-workspace" } },
  {
    "wl",
    function()
      vim.notify(vim.inspect(vim.lsp.buf.lisp_workspace_folders))
    end,
    { desc = "lsp-list-workspace" },
  },
}

for _, map in pairs(nmapping) do
  vim.keymap.set("n", prefix.lang .. map_keyword.lsp .. map[1], map[2], map[3])
end

--------------------------------------------------------------------------------

-- NOTE: xmap is vmap without selection mode <2023-07-20>
vim.keymap.set(
  "x",
  prefix.lang .. map_keyword.lsp .. "a",
  -- NOTE: vim 9.0 부터 function() 으로 랩핑 해줘야 동작. <2022-?>
  function()
    vim.lsp.buf.range_code_action()
  end,
  { desc = "lsp-code-action" }
)

--------------------------------------------------------------------------------

-------------------------------------------------------------------
vim.keymap.set("n", "<Leader><Leader>", "za", { desc = "toggle-fold" })
vim.keymap.set("n", "ZA", "<cmd>wa<CR>", { desc = "save" })
vim.keymap.set("n", prefix.close .. map_keyword.lsp, function()
  for _, buf_client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
    buf_client.stop()
  end
end, { desc = "stop-lsp" })

--------------------------------------------------------------------------------

-- vim.keymap.set({"n", "t"}, "<left>", "<C-\\><C-n><C-w>h")
--
-- vim.keymap.set({"n", "t"}, "<left>", "<cmd>wincmd h<CR>")
-- vim.keymap.set({"n", "t"}, "<down>", "<cmd>wincmd j<CR>")
-- vim.keymap.set({"n", "t"}, "<up>", "<cmd>wincmd k<CR>")
-- vim.keymap.set({"n", "t"}, "<right>", "<cmd>wincmd l<CR>")
-- vim.keymap.set("n", "<S-left>", "<C-w>H")
-- vim.keymap.set("n", "<S-down>", "<C-w>J")
-- vim.keymap.set("n", "<S-up>", "<C-w>K")
-- vim.keymap.set("n", "<S-right>", "<C-w>L")
--
-- vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], {})

--------------------------------------------------------------------------------

-- vim.keymap.set({ "n", "v" }, "<F12>", [["+y]], { desc = "copy-to-clipboard" })
-- vim.keymap.set({ "n", "v", "i" }, "<S-F12>", [["+p]], { desc = "paste-from-clipboard" })
-- vim.keymap.set({ "n", "v", "i" }, "<F24>", [["+p]], { desc = "paste-from-clipboard" })

--------------------------------------------------------------------------------

-- vim.keymap.set("n", "[i", vim.diagnostic.goto_prev, { desc = "information" })
-- vim.keymap.set("n", "]i", vim.diagnostic.goto_next, { desc = "information" })
vim.keymap.set("n", "[f", function()
  vim.diagnostic.goto_prev({
    severity = { max = vim.diagnostic.severity.INFO },
  })
end, { desc = "information" })
vim.keymap.set("n", "]f", function()
  vim.diagnostic.goto_next({
    severity = { max = vim.diagnostic.severity.INFO },
  })
end, { desc = "information" })
vim.keymap.set("n", "]w", function()
  vim.diagnostic.goto_next({
    severity = { min = vim.diagnostic.severity.WARN },
  })
end, { desc = "error" })
vim.keymap.set("n", "[w", function()
  vim.diagnostic.goto_prev({
    severity = { min = vim.diagnostic.severity.WARN },
  })
end, { desc = "error" })
vim.keymap.set("n", "[g", function()
  vim.diagnostic.goto_prev({
    severity = { min = vim.diagnostic.severity.ERROR },
  })
end, { desc = "error" })
vim.keymap.set("n", "]g", function()
  vim.diagnostic.goto_next({
    severity = { min = vim.diagnostic.severity.ERROR },
  })
end, { desc = "error" })

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "lsp-declaration" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "lsp-definition" })
vim.keymap.set("n", "<F12>", vim.lsp.buf.definition, { desc = "lsp-definition" })

vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "lsp-declaration" })
vim.keymap.set("n", "g" .. map_keyword.lsp .. "i", vim.lsp.buf.implementation, { desc = "lsp-implementation" })
vim.keymap.set("n", "g" .. map_keyword.lsp .. "r", vim.lsp.buf.references, { desc = "lsp-references" })
vim.keymap.set("n", "g" .. map_keyword.lsp .. "y", vim.lsp.buf.type_definition, { desc = "lsp-type-definition" })
vim.keymap.set("n", "g" .. map_keyword.lsp .. "r", vim.lsp.buf.signature_help, { desc = "lsp-signature-help" })

-- ----

-- vim.api.nvim_set_keymap("", "gb", "<cmd>bnext<CR>", {})
-- vim.api.nvim_set_keymap("", "gB", "<cmd>bprevious<CR>", {})

-- NOTE: VS Code Mapping:
-- https://code.visualstudio.com/shortcuts/keyboard-shortcuts-Linux.pdf
-- F1: VS Code 에서는 커맨드 검색인듯
-- F5: Start Debugging
-- General
----------------------------------------------------------
-- Basic Editing
----------------------------------------------------------
-- Rich Languages Editing
----------------------------------------------------------
-- Multi-cursor and selection
----------------------------------------------------------
-- Display
----------------------------------------------------------
-- C-B Toggle Sidebar visibility
-- F11: Toggle full screen
-- nnoremap <F3> :NERDTreeToggle<CR>

-- Search and replace
----------------------------------------------------------
-- F3 / Shift-F3: Find next/previous

-- Navigation
----------------------------------------------------------
-- Editor management
----------------------------------------------------------
-- File Management
----------------------------------------------------------
-- Debug
----------------------------------------------------------
-- F9: Toggle breakpoint
-- F5: Start / continue
-- nnoremap <F5> :QuickRun<CR>
-- nnoremap <Leader>mcc :QuickRun<CR>
-- nnoremap <Leader>mcc :AsyncRun -raw python %<CR>
-- nnoremap <Leader>rr :AsyncRun -mode=term %:p<CR>
-- nnoremap <F6> :CocCommand python.execSelectionInTerminal
-- Shift-F5 Stop
-- F11 / S-F11 Step into/out
-- F10: Step over
-- C-K C-I Show hover

-- Integrated terminal
----------------------------------------------------------
-- C-grave: Show integrated terminal
-- Create New terminal
-- C-S-Up/Down: Scroll up/down
-- imap <C-l> <Plug>(coc-snippets-expand)
--
