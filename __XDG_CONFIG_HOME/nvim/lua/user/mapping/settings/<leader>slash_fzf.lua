local M = {}

_SEARCH_PREFIX = "<leader>/"

function M.setup()
  local status_wk, wk = pcall(require, "which-key")
  if not status_wk or not _IS_PLUGIN('fzf.vim') then
    return
  end

  wk.register({ [_SEARCH_PREFIX] = { name = "+search" } })

  wk.register({
    ["a"] = { ":<C-u>Ag", "Ag" },
    ["r"] = { ":<C-u>Rg", "Rg" },
    ----
    ["l"] = { ":<C-u>BLines<CR>", "buffer-line" },
    -- ["L"] = { ":<C-u>Lines<CR>", "line" },
    ["m"] = { ":<C-u>Marks<CR>", "marks" },
    ["w"] = { ":<C-u>Windows<CR>", "windows" },
    ["s"] = { ":<C-u>Snippets<CR>", "snippets" },
    ["p"] = { ":<C-u>Maps<CR>", "maps" },
    ["c"] = { ":<C-u>Commands<CR>", "commands" },
    ["f"] = { ":<C-u>Filetypes<CR>", "filetypes" },
    ["hh"] = { ":<C-u>History<CR>", "history" },
    ["h:"] = { ":<C-u>History:<CR>", "history-:" },
    ["h/"] = { ":<C-u>History/<CR>", "history-/" },
  }, { prefix = _SEARCH_PREFIX, mode = "n" }
  )
end

return M
