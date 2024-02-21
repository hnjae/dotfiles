-- local prefix = require("val").prefix.snippet
-- local keyword = require("val").map_keyword.snippet

---@type LazySpec
return {
  [1] = "sirver/ultisnips",
  lazy = true,
  enabled = true,
  event = { "InsertEnter" },
  cmd = {
    "UltiSnipsEdit",
    "UltiSnipsAddFiletypes",
  },
  cond = vim.fn.has("python3") == 1,
  -- keys = {
  --   -- [1] = prefix .. keyword .. "e",
  --   [2] = "<cmd>UltiSnipsEdit<cr>",
  --   desc = "ultisnips-edit",
  -- },
  -- keys = {
  --   {
  --     [1] = "iS",
  --     [2] = nil,
  --     desc = "inside-snippet",
  --     mode = "o",
  --     ft = "snippets",
  --   },
  --   {
  --     [1] = "aS",
  --     [2] = nil,
  --     desc = "outside-snippet",
  --     mode = "o",
  --     ft = "snippets",
  --   },
  -- },
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

    local ulti_dir = require("plenary.path"):new(
      vim.fn.stdpath("config"),
      -- "after",
      "ultisnips"
    ).filename

    vim.g.UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = ulti_dir
    vim.g.UltiSnipsSnippetDirectories = { ulti_dir }

    vim.g.UltiSnipsEditSplit = "vertical"
    vim.g.UltiSnipsEnableSnipMate = 0
  end,
  -- config = function()
  --   vim.cmd("UltiSnipsAddFiletypes just.sh")
  -- end,
}
