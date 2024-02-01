-- docs: map-table
local prefix = require("val").prefix
local map_keyword = require("val").map_keyword

vim.keymap.set(
  { "n", "x", "s" },
  "<F12>",
  [["+y]],
  { desc = "yank-to-clipboard" }
)

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
vim.keymap.set({ "n", "x", "s", "o" }, "s", "<Nop>")
vim.keymap.set({ "n", "x", "s", "o" }, "S", "<Nop>")

--------------------------------------------------------------------------------
-- handy emacs-like behavior
--------------------------------------------------------------------------------
vim.keymap.set({ "i" }, "<C-e>", "<C-\\><C-n>A")
vim.keymap.set({ "i" }, "<C-a>", "<C-\\><C-n>I")

--------------------------------------------------------------------------------
-- escape teriminal
--------------------------------------------------------------------------------
vim.keymap.set({ "t" }, "<S-Esc>", "<C-\\><C-n>", { desc = "escape-terminal" })

--------------------------------------------------------------------------------

-- open new page with current buffer
-- vim.keymap.set({ "n" }, prefix.new .. "c", "", { desc = "+current" })
vim.keymap.set(
  { "n" },
  prefix.new .. "c" .. map_keyword.vsplit,
  "<cmd>vsplit<CR>",
  { desc = "current-buffer-vsplit" }
)
vim.keymap.set(
  { "n" },
  prefix.new .. "c" .. map_keyword.split,
  "<cmd>split<CR>",
  { desc = "current-buffer-split" }
)
vim.keymap.set(
  { "n" },
  prefix.new .. "c" .. map_keyword.tab,
  "<cmd>tabedit %<CR>",
  { desc = "current-buffer-tab" }
)

-- open new page with an empty window
vim.keymap.set(
  { "n" },
  prefix.new .. "e" .. map_keyword.vsplit,
  "<cmd>vnew<CR>",
  { desc = "empty-vsplit" }
)
vim.keymap.set(
  { "n" },
  prefix.new .. "e" .. map_keyword.split,
  "<cmd>new<CR>",
  { desc = "empty-split" }
)
vim.keymap.set(
  { "n" },
  prefix.new .. "e" .. map_keyword.tab,
  "<cmd>tabedit<CR>",
  { desc = "empty-tab" }
)

--------------------------------------------------------------------------------

local nmapping = {
  { "n", vim.lsp.buf.rename, { desc = "lsp-rename" } },
  { "a", vim.lsp.buf.code_action, { desc = "lsp-code-action" } },
  { "wa", vim.lsp.buf.add_workspace_folder, { desc = "lsp-add-workspace" } },
  {
    "wr",
    vim.lsp.buf.remove_workspace_folder,
    { desc = "lsp-remove-workspace" },
  },
  {
    "wl",
    function()
      vim.notify(vim.inspect(vim.lsp.buf.lisp_workspace_folders))
    end,
    { desc = "lsp-list-workspace" },
  },
}

for _, map in pairs(nmapping) do
  vim.keymap.set(
    "n",
    prefix.buffer .. map_keyword.lsp .. map[1],
    map[2],
    map[3]
  )
end

--------------------------------------------------------------------------------

-- NOTE: xmap is vmap without selection mode <2023-07-20>
vim.keymap.set(
  "x",
  prefix.buffer .. map_keyword.lsp .. "a",
  -- NOTE: vim 9.0 부터 function() 으로 랩핑 해줘야 동작. <2022-?>
  function()
    vim.lsp.buf.range_code_action()
  end,
  { desc = "lsp-code-action" }
)

--------------------------------------------------------------------------------

-------------------------------------------------------------------
vim.keymap.set({ "n", "v" }, "<Leader><Leader>", ":", { desc = "cmdline" })
-- vim.keymap.set({ "n", "x", "s" }, ":", "<Nop>") -- disable default behavior

vim.keymap.set({ "n" }, "<F3>", "<cmd>wa<CR>", { desc = "write-all" })
-- vim.keymap.set("n", "<C-s>", "<cmd>wa<CR>", { desc = "write-all" })

vim.keymap.set(
  "n",
  prefix.close .. "b",
  "<cmd>bd<CR>",
  { desc = "buffer-delete" }
)
vim.keymap.set("n", prefix.close .. "QA", "<cmd>qa<CR>", { desc = "quit-all" })
vim.keymap.set(
  "n",
  prefix.close .. "h",
  "<cmd>nohlsearch<CR>",
  { desc = "no-highlight-search" }
)
-- vim.keymap.set("n", prefix.close .. "s", "<cmd>luafile $MYVIMRC<CR>", { desc = "source $MYVIMRC" })
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

vim.keymap.set("n", "[i", function()
  vim.diagnostic.goto_prev({
    severity = { max = vim.diagnostic.severity.INFO },
  })
end, { desc = "information" })
vim.keymap.set("n", "]i", function()
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
vim.keymap.set("n", "[W", function()
  vim.diagnostic.goto_prev({
    severity = { min = vim.diagnostic.severity.ERROR },
  })
end, { desc = "error" })
vim.keymap.set("n", "]W", function()
  vim.diagnostic.goto_next({
    severity = { min = vim.diagnostic.severity.ERROR },
  })
end, { desc = "error" })

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "lsp-declaration" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "lsp-definition" })
vim.keymap.set(
  "n",
  "<F12>",
  vim.lsp.buf.definition,
  { desc = "lsp-definition" }
)

vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "lsp-declaration" })
vim.keymap.set(
  "n",
  "g" .. map_keyword.lsp .. "i",
  vim.lsp.buf.implementation,
  { desc = "lsp-implementation" }
)
vim.keymap.set(
  "n",
  "g" .. map_keyword.lsp .. "r",
  vim.lsp.buf.references,
  { desc = "lsp-references" }
)
vim.keymap.set(
  "n",
  "g" .. map_keyword.lsp .. "y",
  vim.lsp.buf.type_definition,
  { desc = "lsp-type-definition" }
)
vim.keymap.set(
  "n",
  "g" .. map_keyword.lsp .. "r",
  vim.lsp.buf.signature_help,
  { desc = "lsp-signature-help" }
)

-- NOTE: VS Code Mapping:
-- https://code.visualstudio.com/shortcuts/keyboard-shortcuts-Linux.pdf
