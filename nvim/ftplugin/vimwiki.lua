local wk = require("which-key")

vim.opt_local.commentstring="<!--%s-->"
vim.opt_local.comments="b:>,b:*,b:+,b:-"
-- vim.opt_local.comments="fb:*,fb:-,fb:+,n:>"

vim.opt_local.tabstop = 8
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.colorcolumn = "0"
vim.opt_local.foldlevel = 10
-- vim.api.nvim_create_autocmd(
--   -- { "BufRead", "BufNewFile", "BufNew" }, -- vim-markdown 에서 override 하는 듯
--   { "BufEnter" },
--   {
--   pattern  = { "*.md" },
--   callback = function()
--     if vim.opt_local.conceallevel:get() ~= 0 then
--       vim.opt_local.conceallevel = 0
--     end
--   end
--   }
-- )

-----------------------------------------
-- headers
local headers_mappings = {
  ["#"] = { "<plug>VimwikiAddHeaderLevel", "add-header-level" },
  ["="] = { "<plug>VimwikiAddHeaderLevel", "add-header-level" },
  ["-"] = { "<plug>VimwikiRemoveHeaderLevel", "remove-header-level" },
  ["[["] = { "<plug>VimwikiGoToPrevHeader", "header" },
  ["]]"] = { "<plug>VimwikiGoToNextHeader", "header" },

  -- signature-mark 랑 충돌 해결할 것
  ["]="] = { "<plug>VimwikiGoToPrevSiblingHeader", "sibling-header" },
  ["[="] = { "<plug>VimwikiGoToNextSiblingHeader", "sibling-header" },

  ["]u"] = { "<plug>VimwikiGoToParentHeader", "parent-header" },
  ["[u"] = { "<plug>VimwikiGoToParentHeader", "parent-header" },
}
wk.register(headers_mappings, { buffer = 0 })

-----------------------------------------
-- vimwiki text_objs

-----------------------------------------
-- vimwiki table
vim.cmd([[
  " <C-s> 로 테이블에서 오른쪽 컬럼으로 이동한다.
  inoremap <C-s> <C-r>=vimwiki#tbl#kbd_tab()<CR>
  " <C-a> 로 테이블에서 왼쪽 컬럼으로 이동한다.
  inoremap <C-a> <Left><C-r>=vimwiki#tbl#kbd_shift_tab()<CR>
]])

----------------------------------------
-- list vimwiki lists
local lists_mappings = {
  -- TASK
  ["glt"] = { "<plug>VimwikiToggleListItem", "todo-toggle" },
  -- remapped
  ["glc"] = { "<plug>VimwikiRemoveSingleCB", "remove-checkbox" },
  -- remapped
  ["gLc"] = { "<plug>VimwikiRemoveCBInList", "remove-checkbox" },
  ["gnt"] = { "<plug>VimwikiNextTask", "next-task" },
  ["gln"] = { "<plug>VimwikiIncrementListItem", "increment-list-item" },
  ["glp"] = { "<plug>VimwikiIncrementListItem", "increment-list-item" },

  -- LIST
  ["gl"] = { name = "+list" },
  ["gL"] = { name = "+list-all" },
  ["gll"] = { "<plug>VimwikiIncreaseLvlSingleItem", ">>" },
  ["gLl"] = { "<plug>VimwikiIncreaseLvlWholeItem", ">>" },
  ["glh"] = { "<plug>VimwikiDecreaseLvlSingleItem", "<<" },
  ["gLh"] = { "<plug>VimwikiDecreaseLvlWholeItem", "<<" },
  ["glr"] = { "<plug>VimwikiRenumberList", "renumber-list" },
  ["gLr"] = { "<plug>VimwikiRenumberAllLists", "renumber-all-lists" },
  ["gl*"] = { ":VimwikiChangeSymbolTo *<CR>", "change-symbol-*" },
  ["gL*"] = { ":VimwikiChangeSymbolInListTo *<CR>", "change-symbol-*" },
  -- ["gl#"] = { ":VimwikiChangeSymbolTo #<CR>", "change-symbol-#" },
  -- ["gL#"] = { ":VimwikiChangeSymbolInListTo #<CR>", "change-symbol-#" },
  ["gl-"] = { ":VimwikiChangeSymbolTo -<CR>", "change-symbol-\\-" },
  ["gL-"] = { ":VimwikiChangeSymbolInListTo -<CR>", "change-symbol-\\-" },
  ["gl1"] = { ":VimwikiChangeSymbolTo 1.<CR>", "change-symbol-1." },
  ["gL1"] = { ":VimwikiChangeSymbolInListTo 1.<CR>", "change-symbol-1." },
  ["gla"] = { ":VimwikiChangeSymbolTo a)<CR>", "change-symbol-a)" },
  ["gLa"] = { ":VimwikiChangeSymbolInListTo a)<CR>", "change-symbol-a)" },
  -- ["gli"] = { ":VimwikiChangeSymbolTo i)<CR>", "change-symbol-i)" },
  -- ["gLi"] = { ":VimwikiChangeSymbolInListTo i)<CR>", "change-symbol-i)" },
  -- ["glI"] = { ":VimwikiChangeSymbolTo i)<CR>", "change-symbol-i)" },
  -- ["gLI"] = { ":VimwikiChangeSymbolInListTo i)<CR>", "change-symbol-i)" },

  ["glx"] = { "<plug>VimwikiToggleRejectedListItem", "toggle-rejected-list-item" },
}
local lists_mappings_v = {
  ["gln"] = { "<plug>VimwikiIncrementListItem", "increment-list-item" },
  ["glp"] = { "<plug>VimwikiIncrementListItem", "increment-list-item" },
}
wk.register(lists_mappings, { buffer = 0 })
wk.register(lists_mappings_v, { buffer = 0, mode = "v" })

--------------------------
-- vimwiki links
local links_mappings_no_prefix = {
  ["<CR>"]     = { "<plug>VimwikiFollowLink", "vimwiki-follow-link" },
  ["<S-CR>"]   = { "<plug>VimwikiSplitLink", "vimwiki-split-link" },
  ["<C-CR>"]   = { "<plug>VimwikiVSplitLink", "vimwiki-vsplit-link" },
  ["<C-S-CR>"] = { "<plug>VimwikiTabnewLink", "vimwiki-tabnew-link" },
  ["<D-CR>"]   = { "<plug>VimwikiTabnewLink", "vimwiki-tabnew-link" },
  ["<Tab>"]    = { "<plug>VimwikiNextLink", "vimwiki-next-link" },
  ["<S-Tab>"]  = { "<plug>VimwikiPrevLink", "vimwiki-prev-link" },
  ["+"]        = { "<plug>VimwikiNormalizeLink", "diary-prev-day" },
}
local links_mappings = {
  ["b"]  = { "<plug>VimwikiGoBackLink", "goback-link" },
  -- ["wn"]   = { "<plug>VimwikiGoto", "goto" },
  ["f"]  = "+file",
  ["fd"] = { "<plug>VimwikiDeleteFile", "delete-file" },
  ["fr"] = { "<plug>VimwikiRenameFile", "rename-file" },

  ["d"]   = "+diary",
  ["dn"]  = { "<plug>VimwikiDiaryNextDay", "diary-next-day" },
  ["dp"]  = { "<plug>VimwikiDiaryPrevDay", "diary-prev-day" },
  ["dg"]  = "+generate",
  ["dgl"] = { "<plug>VimwikiDiaryGenerateLinks", "diary-generate-links" },

  -- 기본값에 없는 것
  ["g"]  = "+generate",
  ["gl"] = { ":<C-u>VimwikiDiaryGenerateLinks<CR>", "generate-links" },

  -- more
  ["p"] = { "<Plug>MarkdownPreviewToggle", "preview-toggle" },
}
local links_mappings_no_pre_v = {
  ["+"] = { "<plug>VimwikiNormalizeLinkVisual", "diary-prev-day" },
}
wk.register(links_mappings, { prefix = _LANG_PREFIX, buffer = 0 })
wk.register(links_mappings_no_prefix, { buffer = 0 })
wk.register(links_mappings_no_pre_v, { buffer = 0, mode = 'v' })

-- overrides global mappings
-- if packer_plugins['fzf.vim'] then
if _IS_PLUGIN('fzf.vim') then
  -- local file_parent = vim.fn.expand(('%:p:h'), false, false)
  for _, wiki in pairs(vim.g.vimwiki_list) do
    -- TODO: Current wiki <2022-05-11, Hyunjae Kim> --
    local wiki_path = vim.fn.expand(wiki["path"], false, false)
    -- local wiki_path = vim.fn.expand(vim.g.vimwiki_list[1]["path"], false, false)
    -- if file_parent == wiki_path then
    wk.register({
      ["f"] = { "<cmd>Files " .. wiki_path .. "<CR>", "open-specific-wiki" },
    }, { prefix = _EDIT_PREFIX, buffer = 0, mode = "n" }
    )
    wk.register({
      ["f"] = { "<cmd>tabnew<CR>:Files " .. wiki_path .. "<CR>", "open-specific-wiki" },
    }, { prefix = _TAB_PREFIX, buffer = 0, mode = "n" }
    )
    wk.register({
      ["f"] = { "<cmd>vnew<CR>:Files " .. wiki_path .. "<CR>", "open-specific-wiki" },
    }, { prefix = _WINDOW_PREFIX, buffer = 0, mode = "n" }
    )
    break
    -- end
  end
end

--------------------------------------------------------
-- 3.1 vimwiki-global-mappings
-- mapped under o and t layer

-- TODO: 이렇게 지정하면 반영 안됨. <2022-04-22, Hyunjae Kim> --
-- vim.g.vimwiki_key_mappings['text_objs'] = 1
-- vim.g.vimwiki_key_mappings['table_format'] = 1
-- vim.g.vimwiki_key_mappings['mouse'] = 0


-------------------------------------------------------------------------------
-- lsp
-------------------------------------------------------------------------------
-- if not _IS_PLUGIN('coc.nvim') then
--   require('user.lsp').setup({"ltex"})
-- end
------------------------------------------------------------
-- vim.cmd([[TagbarOpen]])
