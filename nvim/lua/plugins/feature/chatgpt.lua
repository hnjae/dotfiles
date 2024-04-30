local map_keyword = require("val.map-keyword")
local prefix = require("val.prefix")

---@type LazySpec
return {
  [1] = "jackMort/ChatGPT.nvim",
  main = "chatgpt",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim",
    "nvim-telescope/telescope.nvim",
  },
  lazy = true,
  enabled = true,
  cmd = {
    "ChatGPT",
    "ChatGPTRun",
    "ChatGPTActAs",
    "ChatGPTCompleteCode",
    "ChatGPTEditWithInstructions",
  },
  cond = vim.fn.executable("curl") == 1
    and vim.fn.executable("op") == 1
    and not require("utils").is_console,
  opts = {
    api_key_cmd = "op read op://Personal/OpenAI/api/editor --no-newline",
    openai_params = {
      -- model = "gpt-3.5-turbo",
      model = "gpt-4-1106-preview",
    },
    openai_edit_params = {
      model = "gpt-4-1106-preview",
    },
    actions_paths = {
      require("plenary.path"):new(
        vim.fn.stdpath("config"),
        "chatgpt",
        "default-actions.json"
      ).filename,
    },
  },
  ---@type LazyKeysSpec[]
  keys = {
    -- stylua: ignore start
    { [1] = "<Leader>" .. map_keyword.ai, [2] = "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
    { [1] = prefix.buffer .. map_keyword.ai, [2] = nil, desc = "+ChatGPT" },
    { [1] = prefix.buffer .. map_keyword.ai .. "e", [2] = "<cmd>ChatGPTEditWithInstructions<CR>",          desc = "edit-with-instructions",   mode = { "n", "v" } },
    { [1] = prefix.buffer .. map_keyword.ai .. "g", [2] = "<cmd>ChatGPTRun grammar_correction<CR>",        desc = "grammer-correction",       mode = { "n", "v" } },
    { [1] = prefix.buffer .. map_keyword.ai .. "t", [2] = "<cmd>ChatGPTRun translate<CR>",                 desc = "translate",                mode = { "n", "v" } },
    { [1] = prefix.buffer .. map_keyword.ai .. "s", [2] = "<cmd>ChatGPTRun summarize<CR>",                 desc = "summarize",                mode = { "n", "v" } },
    { [1] = prefix.buffer .. map_keyword.ai .. "o", [2] = "<cmd>ChatGPTRun optimize_code<CR>",             desc = "optimize-code",            mode = { "n", "v" } },
    { [1] = prefix.buffer .. map_keyword.ai .. "l", [2] = "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "code-readability-analias", mode = { "n", "v" } },
    { [1] = prefix.buffer .. map_keyword.ai .. "f", [2] = "<cmd>ChatGPTRun fix_bugs<CR>",                  desc = "fix-bugs",                 mode = { "n", "v" } },
    { [1] = prefix.buffer .. map_keyword.ai .. "r", [2] = "<cmd>ChatGPTRun roxygen_edit<CR>",              desc = "roxygen-edit",             mode = { "n", "v" } },
    { [1] = prefix.buffer .. map_keyword.ai .. "d", [2] = "<cmd>ChatGPTRun docstring<CR>",                 desc = "docstring",                mode = { "n", "v" } },
    { [1] = prefix.buffer .. map_keyword.ai .. "x", [2] = "<cmd>ChatGPTRun explain_code<CR>",              desc = "explain-code",             mode = { "n", "v" } },
    -- stylua: ignore end
    {
      [1] = prefix.buffer .. map_keyword.ai .. map_keyword.ai,
      [2] = "<cmd>ChatGPTCompleteCode<CR>",
      desc = "complete-code",
    },
  },
  -- local maps = {
  --   c = {
  --     k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
  --     a = {
  --       "<cmd>ChatGPTRun add_tests<CR>",
  --       "Add Tests",
  --       mode = { "n", "v" },
  --     },
  --   },
  -- }
}
