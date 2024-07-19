local map_keyword = require("val.map-keyword")
local val = require("val")
-- local prefix = require("val.prefix")

local use_freedesktop_secret_service = vim.fn.executable("secret-tool") == 1

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
    api_key_cmd = use_freedesktop_secret_service
        and "secret-tool lookup api openapi"
      or "op read op://Personal/OpenAI/api/editor --no-newline",
    openai_params = {
      model = "gpt-4o",
    },
    openai_edit_params = {
      model = "gpt-4o",
    },
    chat = {
      active_sign = "󰄵", -- nf-md-checkbox_marked_outline
      in_active_sign = "󰄱", -- nf-md-checkbox_blank_outline
      answer_sign = val.icons.ai,
    },
    actions_paths = {
      require("plenary.path"):new(
        vim.fn.stdpath("config"),
        "assets",
        "chatgpt",
        "default-actions.json"
      ).filename,
      require("plenary.path"):new(
        vim.fn.stdpath("config"),
        "assets",
        "chatgpt",
        "default-actions-altered.json"
      ).filename,
      require("plenary.path"):new(
        vim.fn.stdpath("config"),
        "assets",
        "chatgpt",
        "custom-actions.json"
      ).filename,
    },
  },
  ---@type LazyKeysSpec[]
  keys = {
    -- stylua: ignore start
    { [1] = "<Leader>" .. map_keyword.ai, [2] = "<cmd>ChatGPT<CR>", desc = "chatgpt-toggle" },
    { [1] = "<Leader>" .. string.upper(map_keyword.ai), [2] = "<cmd>ChatGPTActAs<CR>", desc = "chatgpt-actas" },
    -- { [1] = "<LocalLeader>" .. map_keyword.ai, desc = "+ChatGPT" },
    --
    { [1] = "<LocalLeader>" .. map_keyword.ai .. "e",            [2] = "<cmd>ChatGPTEditWithInstructions<CR>",          desc = "edit-with-instructions",   mode = { "n", "v" } },
    { [1] = "<LocalLeader>" .. map_keyword.ai .. map_keyword.ai, [2] = "<cmd>ChatGPTCompleteCode<CR>",                  desc = "complete-code", },
    --
    { [1] = "<LocalLeader>" .. map_keyword.ai .. "s", [2] = "<cmd>ChatGPTRun summarize<CR>",                 desc = "summarize",                mode = { "n", "v" } },
    { [1] = "<LocalLeader>" .. map_keyword.ai .. "o", [2] = "<cmd>ChatGPTRun optimize_code<CR>",             desc = "optimize-code",            mode = { "n", "v" } },
    { [1] = "<LocalLeader>" .. map_keyword.ai .. "l", [2] = "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "code-readability-analias", mode = { "n", "v" } },
    { [1] = "<LocalLeader>" .. map_keyword.ai .. "f", [2] = "<cmd>ChatGPTRun fix_bugs<CR>",                  desc = "fix-bugs",                 mode = { "n", "v" } },
    { [1] = "<LocalLeader>" .. map_keyword.ai .. "r", [2] = "<cmd>ChatGPTRun roxygen_edit<CR>",              desc = "roxygen-edit",             mode = { "n", "v" } },
    { [1] = "<LocalLeader>" .. map_keyword.ai .. "d", [2] = "<cmd>ChatGPTRun docstring<CR>",                 desc = "docstring",                mode = { "n", "v" } },
    { [1] = "<LocalLeader>" .. map_keyword.ai .. "x", [2] = "<cmd>ChatGPTRun explain_code<CR>",              desc = "explain-code",             mode = { "n", "v" } },
    -- stylua: ignore end
    {
      [1] = "<LocalLeader>" .. map_keyword.ai .. "t",
      [2] = function()
        -- local mode = vim.api.nvim_get_mode().mode
        vim.ui.select({
          "English",
          "Korean",
          "Japanese",
          "Chinese",
        }, {
          prompt = "Select language",
        }, function(lang)
          -- 이렇게 작성하면 버퍼 전체 전달
          --   vim.api.nvim_cmd({
          --     cmd = "ChatGPTRun",
          --     args = { "translate", lang },
          --     range = { cursorline },
          --   }, { output = false })
          -- or
          -- require("chatgpt").run_action({
          --   fargs = { "translate", lang },
          -- })
          local cmd = string.format("ChatGPTRun translate %s", lang)
          vim.api.nvim_command(cmd)
        end)
      end,
      desc = "translate",
      mode = { "v" },
    },
    {
      [1] = "<LocalLeader>" .. map_keyword.ai .. "g",
      [2] = "<cmd>ChatGPTRun grammar_correction<CR>",
      desc = "grammer-correction",
      mode = { "v" },
    },
    -- my actions
    {
      [1] = "<LocalLeader>" .. map_keyword.ai .. "v",
      [2] = "<cmd>ChatGPTRun generate_variable_name<CR>",
      desc = "generate_variable_name",
      mode = { "v" },
    },
    {
      [1] = "<LocalLeader>" .. map_keyword.ai .. "c",
      [2] = "<cmd>ChatGPTRun edit_commit_message<CR>",
      desc = "edit_commit_message",
      mode = { "n", "v" },
    },
  },
  specs = {
    {
      [1] = "folke/which-key.nvim",
      optional = true,
      ---@class opts wk.Opts
      opts = function(_, opts)
        if opts.spec == nil then
          opts.spec = {}
        end

        local icon = { icon = val.icons.ai, color = "green" }
        vim.list_extend(opts.spec, {
          {
            [1] = "<LocalLeader>" .. map_keyword.ai,
            group = "chatgpt",
            ---@type wk.Icon
            -- icon = icon,
          },
        })

        if opts.icons == nil then
          opts.icons = {}
        end
        if opts.icons.rules == nil then
          opts.icons.rules = {}
        end

        vim.list_extend(opts.icons.rules, {
          vim.tbl_extend("error", icon, { pattern = "chatgpt" }),
        })
      end,
    },
  },
}
