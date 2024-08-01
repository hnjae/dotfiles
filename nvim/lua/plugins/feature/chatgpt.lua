local map_keyword = require("val.map-keyword")
local val = require("val")
-- local prefix = require("val.prefix")

local use_freedesktop_secret_service = vim.fn.executable("secret-tool") == 1

-- TODO: does this working? <2024-07-26>
local check_visual_and_run_cmd = function(cmd)
  local bufnr = vim.fn.bufnr()

  -- local ESC_FEEDKEY = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  -- vim.api.nvim_feedkeys(ESC_FEEDKEY, "n", true)
  -- vim.api.nvim_feedkeys("gv", "x", false)
  -- vim.api.nvim_feedkeys(ESC_FEEDKEY, "n", true)

  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(bufnr, "<"))
  local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(bufnr, ">"))

  if start_row == 0 or (start_row == end_row and start_col == end_col) then
    local msg = "No visual selected: "
      .. vim.inspect({ start_row, start_col, end_row, end_col })
    vim.notify(msg, vim.log.levels.WARN)
    return
  end

  vim.api.nvim_command(cmd)
end

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
  enabled = use_freedesktop_secret_service,
  cmd = {
    "ChatGPT",
    "ChatGPTRun",
    "ChatGPTActAs",
    "ChatGPTCompleteCode",
    "ChatGPTEditWithInstructions",
  },
  -- cond = vim.fn.executable("curl") == 1,
  -- and vim.fn.executable("op") == 1,
  -- and not require("utils").is_console,
  opts = function()
    local assets_path =
      require("plenary.path"):new(vim.fn.stdpath("config"), "assets", "chatgpt")

    return {
      api_key_cmd = use_freedesktop_secret_service
        and "secret-tool lookup api openapi",
      -- or "op read op://Personal/OpenAI/api/editor --no-newline",
      openai_params = {
        model = "gpt-4o",
        max_tokens = 600, -- default 300
      },
      openai_edit_params = {
        model = "gpt-4o",
      },
      popup_input = {},
      chat = {
        -- border_left_sign = "",
        -- border_right_sign = "",
        max_line_length = 100,
        answer_sign = val.icons.ai,
        sessions_window = {
          active_sign = "󰄵", -- nf-md-checkbox_marked_outline
          in_active_sign = "󰄱", -- nf-md-checkbox_blank_outline
          -- current_line_sign = "",
        },
      },
      predefined_chat_gpt_prompts = string.format(
        "file://%s",
        assets_path:joinpath("prompts.csv").filename
      ),
      actions_paths = {
        assets_path:joinpath("default-actions.json").filename,
        assets_path:joinpath("default-actions-altered.json").filename,
        assets_path:joinpath("custom-actions.json").filename,
      },
    }
  end,
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
        local winid = vim.fn.win_getid()
        local bufnr = vim.fn.bufnr()

        local ESC_FEEDKEY =
          vim.api.nvim_replace_termcodes("<ESC>", true, false, true)

        vim.api.nvim_feedkeys(ESC_FEEDKEY, "n", true)
        vim.api.nvim_feedkeys("gv", "x", false)
        vim.api.nvim_feedkeys(ESC_FEEDKEY, "n", true)

        local start_row, start_col =
          unpack(vim.api.nvim_buf_get_mark(bufnr, "<"))
        local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(bufnr, ">"))

        if
          start_row == 0
          or (start_row == end_row and start_col == end_col)
        then
          local msg = "No visual selected: "
            .. vim.inspect({ start_row, start_col, end_row, end_col })
          vim.notify(msg, vim.log.levels.WARN)
          return
        end

        vim.ui.select({
          "English",
          "Korean",
          "Japanese",
          "Chinese",
        }, {
          prompt = "Select language",
        }, function(lang)
          if not lang then
            return
          end

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

          -- vim.api.nvim_cmd({
          --   cmd = "ChatGPTRun",
          --   args = { "translate", lang },
          --   range = { start_row, end_row, },
          -- }, { output = false })

          vim.api.nvim_set_current_win(winid)
          vim.api.nvim_command(string.format("ChatGPTRun translate %s", lang))
        end)
      end,
      desc = "translate",
      mode = { "v" },
    },
    {
      [1] = "<LocalLeader>" .. map_keyword.ai .. "g",
      [2] = function()
        check_visual_and_run_cmd("ChatGPTRun grammar_correction")
      end,
      desc = "grammer-correction",
      mode = { "v" },
    },
    -- my actions
    {
      [1] = "<LocalLeader>" .. map_keyword.ai .. "v",
      [2] = function()
        check_visual_and_run_cmd("ChatGPTRun generate_variable_name")
      end,
      desc = "generate_variable_name",
      mode = { "v" },
    },
    {
      [1] = "<LocalLeader>" .. map_keyword.ai .. "c",
      -- [2] = "<cmd>ChatGPTRun edit_commit_message<CR>",
      [2] = function()
        check_visual_and_run_cmd("ChatGPTRun edit_commit_message")
      end,
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
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function()
        local icons = require("val").icons
        require("state.lualine-ft-data"):add({
          ["chatgpt-input"] = {
            display_name = "ChatGPT Input",
            icon = icons.textbox,
          },
        })
      end,
    },
    -- {
    --   [1] = "windwp/nvim-autopairs",
    --   optional = true,
    --   opts = function()
    --     require("utils.plugin").on_load("nvim-autopairs", function()
    --       local Rule = require("nvim-autopairs.rule")
    --       require("nvim-autopairs").add_rules({
    --         Rule("`", "`", "chatgpt-input"),
    --         Rule("```", "```", "chatgpt-input"),
    --       })
    --     end)
    --   end,
    -- },
  },
}
