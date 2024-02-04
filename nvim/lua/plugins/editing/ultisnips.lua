---@type LazySpec
return {
  [1] = "sirver/ultisnips",
  lazy = false,
  enabled = true,
  -- event = { "InsertEnter" },
  cond = vim.fn.has("python3") == 1,
  dependencies = {
    -- {
    --   [1] = "honza/vim-snippets",
    --   init = function()
    --     vim.g.snips_author = "KIM Hyunjae"
    --     vim.g.snips_github = "https://github.com/hnjae"
    --   end,
    -- },
  },
  init = function()
    vim.g.UltiSnipsExpandTrigger = "<tab>"
    -- let g:UltiSnipsListSnippets = '<c-tab>'
    vim.g.UltiSnipsJumpForwardTrigger = "<tab>" -- default: <c-j>
    vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>" -- default: <c-k>
    -- vim.g.UltiSnipsEditSplit = "horizontal" -- if you want

    local ulti_dir = require("plenary.path"):new(
      vim.fn.stdpath("config"),
      "after",
      "ultisnips"
    ).filename

    vim.g.UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = ulti_dir
    vim.g.UltiSnipsSnippetDirectories = { ulti_dir }

    vim.g.UltiSnipsEditSplit = "context"
    vim.g.UltiSnipsEnableSnipMate = 0
  end,
}
