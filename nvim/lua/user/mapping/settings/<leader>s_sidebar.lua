local M = {}

local _SIDEBAR_PREFIX="<leader>s"

function M.setup()
  local status_wk, wk = pcall(require, "which-key")
  if not status_wk then
    return
  end

  ------------------------------------------------------
  -- window_prefix specific
  ------------------------------------------------------
  if _IS_PLUGIN('minimap') then
    vim.api.nvim_set_keymap("n", _SIDEBAR_PREFIX .. "m", ":MinimapToggle<CR>", {})
    wk.register({ ["m"] = "minimap" }, { prefix = _SIDEBAR_PREFIX })
  end

  ----------------------------------------
  -- file explorer
  ----------------------------------------
  if _IS_PLUGIN("nvim-tree.lua") then
    wk.register( { ["n"] = {"<cmd>NvimTreeToggle<CR>", "NvimTreeToggle"} }, { prefix = _SIDEBAR_PREFIX })
  elseif _IS_PLUGIN('nerdtree') then
    vim.api.nvim_set_keymap("n", _SIDEBAR_PREFIX .. "n", ":<C-u>NERDTreeToggle %<CR>", {})
    wk.register({ ["n"] = "nerdtree" }, { prefix = _SIDEBAR_PREFIX })

    vim.api.nvim_set_keymap("n", _SIDEBAR_PREFIX .. "N", ":<C-u>NERDTreeFind<CR>", {})
    wk.register({ ["N"] = "nerdtree-find" }, { prefix = _SIDEBAR_PREFIX })
  end

  if _IS_PLUGIN("chadtree") then
    wk.register( { ["c"] = {"<cmd>CHADopen<CR>", "CHADopen"} }, { prefix = _SIDEBAR_PREFIX })
  end
end

return M
