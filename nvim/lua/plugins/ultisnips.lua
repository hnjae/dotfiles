return {
  "sirver/ultisnips",
  lazy = true,
  event = { "InsertEnter" },
  cond = vim.fn.has("python3"),
  dependencies = {
    {
      "honza/vim-snippets",
      init = function()
        vim.g.snips_author = "Hyunjae Kim"
        vim.g.snips_email = "hyunjae.kim@gmx.com"
        vim.g.snips_github = "https://github.com/hnjae"
      end,
    },
  },
  init = function()
    -- vim.g.UltiSnipsExpandTrigger = '<tab>'
    -- let g:UltiSnipsListSnippets = '<c-tab>'
    vim.g.UltiSnipsJumpForwardTrigger = "<tab>" -- default: <c-j>
    vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>" -- default: <c-k>
    -- vim.g.UltiSnipsEditSplit = "horizontal" -- if you want

    local ulti_dir = vim.fn.stdpath("config") .. "/UltiSnips"
    vim.g.UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = ulti_dir

    vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }

    vim.g.UltiSnipsEditSplit = "context"
    vim.g.UltiSnipsEnableSnipMate = 0
  end,
}
