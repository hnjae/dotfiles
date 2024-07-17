local map_keyword = require("val.map-keyword")
-- local prefix = require("val.prefix")

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
      model = "gpt-4o",
    },
    openai_edit_params = {
      model = "gpt-4o",
    },
    chat = {
      active_sign = "󰄵", -- nf-md-checkbox_marked_outline
      in_active_sign = "󰄱", -- nf-md-checkbox_blank_outline
      answer_sign = "🤖",
    },
    actions_paths = {
      require("plenary.path"):new(
        vim.fn.stdpath("config"),
        "chatgpt",
        "default-actions.json"
      ).filename,
      require("plenary.path"):new(
        vim.fn.stdpath("config"),
        "chatgpt",
        "default-actions-altered.json"
      ).filename,
      require("plenary.path"):new(
        vim.fn.stdpath("config"),
        "chatgpt",
        "custom-actions.json"
      ).filename,
    },
  },
  ---@type LazyKeysSpec[]
  keys = {
    -- stylua: ignore start
    { [1] = "<Leader>" .. map_keyword.ai, [2] = "<cmd>ChatGPT<CR>", desc = "toggle-ChatGPT" },
    { [1] = "<Leader>" .. string.upper(map_keyword.ai), [2] = "<cmd>ChatGPTActAs<CR>", desc = "ChatGPTActAs" },
    { [1] = "<LocalLeader>" .. map_keyword.ai, desc = "+ChatGPT" },
    --
    -- NOTE: <cmd>ChatGPT<CR> 을 돌려서 1password unlock 을 한 이후에 아래 커맨드가 정상 작동 <2024-07-17>
    -- TODO: op 말고 pass 나 gpg --decrypt 같은 커맨드 사용. <2024-07-17>
    --
    { [1] = "<LocalLeader>" .. map_keyword.ai .. "e",            [2] = "<cmd>ChatGPTEditWithInstructions<CR>",          desc = "edit-with-instructions",   mode = { "n", "v" } },
    { [1] = "<LocalLeader>" .. map_keyword.ai .. map_keyword.ai, [2] = "<cmd>ChatGPTCompleteCode<CR>",                  desc = "complete-code", },
    --
    { [1] = "<LocalLeader>" .. map_keyword.ai .. "g", [2] = "<cmd>ChatGPTRun grammar_correction<CR>",        desc = "grammer-correction",       mode = { "n", "v" } },
    { [1] = "<LocalLeader>" .. map_keyword.ai .. "t", [2] = "<cmd>ChatGPTRun translate<CR>",                 desc = "translate",                mode = { "n", "v" } },
    { [1] = "<LocalLeader>" .. map_keyword.ai .. "s", [2] = "<cmd>ChatGPTRun summarize<CR>",                 desc = "summarize",                mode = { "n", "v" } },
    { [1] = "<LocalLeader>" .. map_keyword.ai .. "o", [2] = "<cmd>ChatGPTRun optimize_code<CR>",             desc = "optimize-code",            mode = { "n", "v" } },
    { [1] = "<LocalLeader>" .. map_keyword.ai .. "l", [2] = "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "code-readability-analias", mode = { "n", "v" } },
    { [1] = "<LocalLeader>" .. map_keyword.ai .. "f", [2] = "<cmd>ChatGPTRun fix_bugs<CR>",                  desc = "fix-bugs",                 mode = { "n", "v" } },
    { [1] = "<LocalLeader>" .. map_keyword.ai .. "r", [2] = "<cmd>ChatGPTRun roxygen_edit<CR>",              desc = "roxygen-edit",             mode = { "n", "v" } },
    { [1] = "<LocalLeader>" .. map_keyword.ai .. "d", [2] = "<cmd>ChatGPTRun docstring<CR>",                 desc = "docstring",                mode = { "n", "v" } },
    { [1] = "<LocalLeader>" .. map_keyword.ai .. "x", [2] = "<cmd>ChatGPTRun explain_code<CR>",              desc = "explain-code",             mode = { "n", "v" } },
    -- my actions
    { [1] = "<LocalLeader>" .. map_keyword.ai .. "v", [2] = "<cmd>ChatGPTRun generate_variable_name<CR>",    desc = "generate_variable_name",   mode = { "n", "v" } },
    { [1] = "<LocalLeader>" .. map_keyword.ai .. "c", [2] = "<cmd>ChatGPTRun edit_commit_message<CR>",       desc = "edit_commit_message",      mode = { "n", "v" } },
    -- stylua: ignore end
  },
}
