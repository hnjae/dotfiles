-- vim:foldmethod=marker:foldlevel=1:foldenable:tw=0
local package_path = (...):match("(.-)[^%.]+$")

-- TODO: 기본적으로 vim.lsb.buf 함수들로 설정 하고,  lspsaga 설정에서 vim.lsb.buf 관련 함수들을 덮어쓰기로 해결하는게 더 깔끔할듯. <2024-07-17>

local is_setup = false
return function()
  if is_setup then
    return
  end

  is_setup = true
  local prefix = require(package_path .. ".prefix")
  local map_keyword = require(package_path .. ".map-keyword")
  local utils = require("utils")

  local is_lspsaga = utils.is_plugin("lspsaga.nvim")
  local is_wk, wk = pcall(require, "which-key")

  -- vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "lsp-hover" })
  for _, map in ipairs({
    {
      [1] = "K",
      [2] = "hover",
      lspsaga = "<cmd>Lspsaga hover_doc<CR>",
      fallback = vim.lsp.buf.hoves,
    },
  }) do
    local temp = (is_lspsaga and map["lspsaga"])
    vim.keymap.set(
      (map.mode and map.mode or "n"),
      map[1],
      (temp and map["lspsaga"] or map.fallback),
      { desc = (temp and "lspsaga-" or "lsp-") .. map[2] }
    )
  end

  ------------------------------------------------------------------------------
  -- {{{ prev/next: [ / ] - jump to diagnostic
  for _, map in ipairs({
    { "h", "HINT", "hint" },
    { "i", "INFO", "information" },
    { "w", "WARN", "warning" },
    { "r", "ERROR", "error" },
    { [1] = "d", [3] = "diagnostic" },
  }) do
    local func_opts = map[2]
        and {
          severity = vim.diagnostic.severity[map[2]],
        }
      or {}
    local keymap_opts =
      { desc = (is_lspsaga and "lspsaga-" or "lsp-") .. map[3] }
    local prev_func, next_func
    if is_lspsaga then
      prev_func = function()
        require("lspsaga.diagnostic"):goto_prev(func_opts)
      end
      next_func = function()
        require("lspsaga.diagnostic"):goto_next(func_opts)
      end
    else
      prev_func = function()
        vim.diagnostic.goto_prev(func_opts)
      end
      next_func = function()
        vim.diagnostic.goto_next(func_opts)
      end
    end
    vim.keymap.set("n", "[" .. map[1], prev_func, keymap_opts)
    vim.keymap.set("n", "]" .. map[1], next_func, keymap_opts)
  end
  -- }}}
  ------------------------------------------------------------------------------
  -- {{{ buffer: prefix.buffer .. map_keyword.lsp
  local loc_prefix = prefix.buffer .. map_keyword.lsp
  for _, map in pairs({
    { [1] = "", [2] = "+lsp", group = true },
    {
      [1] = "n",
      [2] = "rename",
      lspsaga = "<cmd>Lspsaga rename<CR>",
      fallback = vim.lsp.buf.rename,
    },
    {
      [1] = map_keyword.execute,
      [2] = "code-action",
      lspsaga = "<cmd>Lspsaga code_action<CR>",
      fallback = vim.lsp.buf.code_action,
    },
    {
      [1] = map_keyword.execute,
      [2] = "code-action",
      -- NOTE: vim 9.0 부터 function() 으로 랩핑 해줘야 동작. <2022-?>
      fallback = function()
        vim.lsp.buf.range_code_action()
      end,
      -- NOTE: xmap is vmap without selection mode <2023-07-20>
      mode = { "x" },
    },

    -- stylua: ignore start
    { [1] = "s", [2] = "code-lens",         fallback = vim.lsp.codelens.run, },
    { [1] = "S", [2] = "code-lens refresh", fallback = vim.lsp.codelens.refresh, },
    -- stylua: ignore end

    -- stylua: ignore start
    { [1] = "d", [2] = "peek-definition",      lspsaga = "<cmd>Lspsaga peek_definition<CR>", },
    { [1] = "p", [2] = "peek-type-definition", lspsaga = "<cmd>Lspsaga peek_type_definition<CR>", },

    -- callhierarchy
    { [1] = "i", [2] = "incoming-calls", lspsaga= "<cmd>Lspsaga incoming_calls<CR>", fallback = vim.lsp.buf.incoming_calls },
    { [1] = "o", [2] = "outgoing-calls", lspsaga= "<cmd>Lspsaga outgoing_calls<CR>", fallback = vim.lsp.buf.outgoing_calls },

    -- list in quickfix windows
    { [1] = "r", [2] = "references",     fallback = vim.lsp.buf.references, },
    -- textDocument/implementation
    { [1] = "m", [2] = "implementation", fallback = vim.lsp.buf.implementation, },
    { [1] = "h", [2] = "signature-help", fallback = vim.lsp.buf.signature_help, },
    { [1] = "y", [2] = "document-symbol", fallback = vim.lsp.buf.document_symbol, },
    { [1] = "Y", [2] = "workspace-symbol", fallback = vim.lsp.buf.workspace_symbol, },
    -- stylua: ignore end

    -- stylua: ignore start
    { [1] = "w",  [2] = "+workspace",       group=true, },
    { [1] = "wa", [2] = "add-workspace",    fallback = vim.lsp.buf.add_workspace_folder, },
    { [1] = "wr", [2] = "remove-workspace", fallback = vim.lsp.buf.remove_workspace_folder, },
    { [1] = "wl", [2] = "list-workspace",   fallback = function()
        vim.ui.select(
          vim.lsp.buf.list_workspace_folders(),
          { prompt = "vim.lsp.buf.list_workspace_folders()" },
          function(choice)
            -- let @a = 'Hello, Neovim!'
            vim.fn.setreg("@", choice)
            vim.notify(
              "Selected workspace has been assigned to the register."
            )
          end
        )
      end,
    },
    -- stylua: ignore end
  }) do
    if map.group then
      if is_wk then
        wk.add({
          { [1] = loc_prefix .. map[1], group = map[2] },
        })
      end
    else
      local is_lspsaga_keymap = (is_lspsaga and map["lspsaga"])
      vim.keymap.set(
        (map.mode and map.mode or "n"),
        loc_prefix .. map[1],
        (is_lspsaga_keymap and map["lspsaga"] or map.fallback),
        { desc = (is_lspsaga_keymap and "lspsaga-" or "") .. map[2] }
      )
    end
  end
  -- }}}
  ------------------------------------------------------------------------------
  -- {{{ goto:  g
  ------------------------------------------------------------------------------
  for _, map in ipairs({
    {
      [1] = "p",
      [2] = "type-definition",
      lspsaga = "<cmd>Lspsaga goto_type_definition",
      fallback = vim.lsp.buf.type_definition,
    },
    {
      [1] = "d",
      [2] = "definition",
      lspsaga = "<cmd>Lspsaga goto_definition<CR>",
      fallback = vim.lsp.buf.definition,
    },
    -- "textDocument/declaration"
    {
      [1] = "D",
      [2] = "declaration",
      fallback = vim.lsp.buf.declaration,
    },
  }) do
    local is_lspsaga_keymap = (is_lspsaga and map["lspsaga"])

    vim.keymap.set(
      (map.mode and map.mode or "n"),
      "g" .. map[1],
      (is_lspsaga_keymap and map["lspsaga"] or map.fallback),
      { desc = (is_lspsaga_keymap and "lspsaga-" or "lsp-") .. map[2] }
    )
  end

  -- }}}
  ------------------------------------------------------------------------------
  -- {{{ prefix.close
  vim.keymap.set("n", prefix.close .. map_keyword.lsp, function()
    for _, buf_client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      buf_client.stop()
    end
  end, { desc = "stop-lsp" })
  -- }}}
end
