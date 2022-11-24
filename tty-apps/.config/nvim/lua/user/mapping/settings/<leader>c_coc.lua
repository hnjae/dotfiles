----------------------------------------------------------------
-- coc-list
----------------------------------------------------------------

local M = {}

local prefix = "<leader>c"

local status_wk, wk = pcall(require, "which-key")

M.setup = function ()
  if not status_wk or not _IS_PLUGIN("coc.nvim") then
    return
  end
  ----------------------------------------------------------------
  wk.register({ [prefix] = { name = "+coc" } })
  ----------------------------------------------------------------

  wk.register({
    [prefix .. "l"] = {
      -- TODO: Maybe <silent><nowait> 필요할지도. coc github에서는 쓰임 <2022-04-22, Hyunjae Kim> --
      name = "+coc-list",
      -- CocList
      ['.'] = { ":<C-u>CocList --reverse lists<CR>", "CocList", mode = "n" },
      -- Show all diagnostics.
      -- nowait 설정이 안됨.
      d = { ":<C-u>CocList --reverse --auto-preview diagnostics<CR>", "diagnostics", mode = "n" },
      -- lines
      l = { ":<C-u>CocList --reverse lines<CR>", "lines", mode = "n" },
      w = { ":<C-u>CocList --reverse words<CR>", "words", mode = "n" },
      -- tags
      t = { ":<C-u>CocList --reverse tags<CR>", "tags", mode = "n" },
      m = { ":<C-u>CocList --reverse marks<CR>", "tags", mode = "n" },
      b = { ":<C-u>CocList --reverse buffers<CR>", "buffers", mode = "n" },
      r = { ":<C-u>CocList --reverse registers<CR>", "registers", mode = "n" },
      s = { ":<C-u>CocList --reverse sessions<CR>", "sessions", mode = "n" },
      c = { ":<C-u>CocList --reverse changes<CR>", "changes", mode = "n" },
      h = { ":<C-u>CocList --reverse cmdhistory<CR>", "cmdhistory", mode = "n" },
      -- Show commands.
      C = { ":<C-u>CocList --reverse commands<CR>", "commands", mode = "n" },
      V = { ":<C-u>CocList --reverse dimcommands<CR>", "vimcommands", mode = "n" },
      -- Find symbol of current document.
      o = { ":<C-u>CocList --reverse outline<CR>", "outline", mode = "n" },
      -- Search workspace symbols.
      y = { ":<C-u>CocList --interactive --reverse symbols<CR>", "symbols", mode = "n" },

      -- Resume latest coc list.
      R = { ":<C-u>CocListResume<CR>", "Resume", mode = "n" },
      q = { ":<C-u>CocListCancel<CR>", "quit", mode = "n" },

      k = { ":<C-u>CocList --reverse links<CR>", "links", mode = "n" },
      n = { ":<C-u>CocList --reverse location<CR>", "location", mode = "n" },
      f = { ":<C-u>CocList --reverse files<CR>", "files", mode = "n" },
      F = { ":<C-u>CocList --reverse folders<CR>", "forders", mode = "n" },
      p = { ":<C-u>CocList --reverse snippets<CR>", "snippets", mode = "n" },
      -- for debugging
      D = {name = "+debug"},
      ['Du'] = { ":<C-u>CocList --reverse sources<CR>", "sources", mode = "n" },
      ['Ds'] = { ":<C-u>CocList --reverse services<CR>", "services", mode = "n" },
      -- Manage extensions.
      ['Dx'] = { ":<C-u>CocList --reverse extensions<CR>", "extensions", mode = "n" },
      ['Dm'] = { ":<C-u>CocList --reverse maps<CR>", "maps", mode = "n" },
    },
  })

  ----------------------------------------------------------------
  --
  ----------------------------------------------------------------
  -- Do default action for next item.
  -- nnoremap <silent><nowait> <Leader>cn  :<C-u>CocNext<CR>
  -- Do default action for previous item.
  -- nnoremap <silent><nowait> <Leader>cp  :<C-u>CocPrev<CR>
  vim.cmd([[
  " 내 커맨드
  " nnoremap <silent><nowait> <Leader>cd  :CocCommand workspace.showOutput<CR>
  " nnoremap <Leader>cd :<C-u>CocDiagnostics<CR> (use cld instead)
  " nnoremap <Leader>cdi :<C-u>call CocAction('diagnosticInfo')<CR>
  " nnoremap <Leader>cdp :<C-u>call CocAction('diagnosticPreview')<CR>
  " nnoremap <Leader>cdp :<C-u>call CocAction('diagnosticToggle')<CR>

  " nnoremap <leader>ol <Plug>(coc-openlink)
  ]])
  wk.register({
    [prefix] = {
      ['i'] = { name = "+info" },
      ['ii'] = { ":<C-u>CocInfo<CR>", "CocInfo", mode = "n" },
      ['il'] = { ":<C-u>CocOpenLog<CR>", "CocOpenLog", mode = "n" },
    },
  })

  ----------------------------------------------------------------
  -- ce
  ----------------------------------------------------------------
  wk.register({
    [prefix .. "e"] = {
      name = "+edit",
      g = { ":<C-u>CocConfig<CR>", "global-config", mode = "n" },
      l = { ":<C-u>CocLocalConfig<CR>", "local-config", mode = "n" },
      s = { ":<C-u>call CocAction('runCommand', 'snippets.editSnippets')<CR>", "snippets", mode = "n" },
    },
  })
  ----------------------------------------------------------------
  -- others
  ----------------------------------------------------------------
  wk.register({
    [prefix .. "R"] = { ":<C-u>CocRestart<CR>", "restart", mode = "n" },
  })
end

return M
