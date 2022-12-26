local M = {}

-- local status_hop, hop = pcall(require, "hop")

local status_wk, wk = pcall(require, "which-key")


M.setup = function()
  if not status_wk then
    return
  end
  if _IS_PLUGIN('tagbar') then
    wk.register({
      ["[t"] = { ":<C-u>TagbarJumpPrev<CR>", "tag", mode = "n" },
      ["]t"] = { ":<C-u>TagbarJumpNext<CR>", "tag", mode = "n" },
    }, {noremap = true})
  end

  if _IS_PLUGIN("coc.nvim") then
    local nkeymap = {
      ["[w"] = { "<plug>(coc-diagnostic-prev)", "warning" },
      ["]w"] = { "<plug>(coc-diagnostic-next)", "warning" },
      ["[g"] = { "<plug>(coc-diagnostic-prev-error)", "error" },
      ["]g"] = { "<plug>(coc-diagnostic-next-error)", "error" },
    }
    wk.register(nkeymap, { mode = "n", silent = false, noremap = true, })
  end

end

return M
