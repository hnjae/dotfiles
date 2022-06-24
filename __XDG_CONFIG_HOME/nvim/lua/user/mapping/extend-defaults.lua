local M = {}

function M.setup()
  local status_wk, wk = pcall(require, "which-key")
  if not status_wk then
    return
  end

  if _IS_PLUGIN('tagbar') then

    wk.register({
      ["[t"] = { ":<C-u>TagbarJumpPrev<CR>", "tag", mode = "n" },
      ["]t"] = { ":<C-u>TagbarJumpNext<CR>", "tag", mode = "n" },
    })
  end
end

return M
