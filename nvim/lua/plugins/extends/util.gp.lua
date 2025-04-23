--[[
NOTE:
  - run `:GpInspectPlugin` to debug
  - run `secret-tool store --label=<api-anthropic> api anthropic` to save password

  - 같이 보기:
    * <https://ai.google.dev/pricing>
    * <https://docs.anthropic.com/en/api/messages>
]]

local keyword = "i"
local prefix = "<Leader>" .. keyword
local tprefix = "<Leader>" .. keyword .. "t" -- task
local wk_icon = {
  icon = require("globals").icons.ai,
  color = "purple",
}

---@type LazySpec
return {
  [1] = "Robitx/gp.nvim",
  version = "*", -- NOTE: latest release 2024-08-12 (2025-04-08)
  -- commit = "72f4b3a0bd8798afb5dedc9b56129808c890e68c", -- <https://github.com/Robitx/gp.nvim/pull/255>
  pin = true,
  cond = not vim.g.vscode,

  lazy = true,
  event = "VeryLazy",

  dependencies = {},
  config = function(_, opts)
    require("gp").setup(opts)

    local rm_commands = {
      "GpWhisper",
      "GpWhisperRewrite",
      "GpWhisperAppend",
      "GpWhisperPrepend",
      "GpWhisperEnew",
      "GpWhisperNew",
      "GpWhisperVnew",
      "GpWhisperTabnew",
      "GpWhisperPopup",
    }
    for _, command in ipairs(rm_commands) do
      vim.api.nvim_del_user_command(command)
    end

    local icon = require("globals").icons.ai

    vim.api.nvim_create_autocmd({ "User" }, {
      pattern = { "GpDone" },
      callback = function(_)
        vim.notify(icon .. ": GpDone!", "info")
      end,
    })

    -- local gp_file_regex = vim.regex(".*/gp/chats/.*")
    -- vim.api.nvim_create_autocmd("BufWinEnter", {
    --   -- pattern = { "markdown" },
    --   callback = function(ev)
    --     vim.notify(vim.inspect(ev))
    --     -- local matches = gp_file_regex:match_str(ev.file)
    --     -- if matches == nil then
    --     --   -- not a gp chat file
    --     --   return
    --     -- end
    --     -- vim.opt_local.number = true
    --     -- vim.opt_local.relativenumber = true
    --   end,
    -- })
  end,
  opts = function(_, opts)
    local icon = require("globals").icons.ai

    return vim.tbl_deep_extend("force", opts, {
      command_prompt_prefix_template = icon .. " {{agent}} ~ ",

      chat_assistant_prefix = { "LLM ", "[{{agent}}]:" },

      -- chat_user_prefix = (require("globals").icons.textbox .. " :"),
      chat_user_prefix = "USER:",

      chat_conceal_model_params = false,
      -- chat_topic_model = "";

      chat_shortcut_new = {
        modes = { "n", "i", "v", "x" },
        shortcut = "<C-g>n",
      },
      chat_shortcut_respond = {
        modes = { "n", "i", "v", "x" },
        shortcut = "<C-g>r",
      },

      -- default_chat_agent = "claude-sonnet",
      -- default_command_agent = "openai-mini",
      default_command_agent = "gemini-command",
      default_chat_agent = "gemini",

      chat_template = [[
# topic: ?

- file: {{filename}}

| Type    | Keyboard | Command          |
| ------- | -------- | ---------------- |
| Respond | `{{respond_shortcut}}` | `:{{cmd_prefix}}ChatRespond` |
| Stop    | `{{stop_shortcut}}` | `:{{cmd_prefix}}ChatStop`    |
| Delete  | `{{delete_shortcut}}` | `:{{cmd_prefix}}ChatDelete.` |
| New     | `{{new_shortcut}}` | `:{{cmd_prefix}}ChatNew.`    |

Chats are saved automatically.

---

{{user_prefix}}
]],
      -- {{optional_headers}}

      style_popup_max_width = 120,

      ----------------------------------------------------------------------------------------------
      -- Keys
      ----------------------------------------------------------------------------------------------
      openai_api_key = { "secret-tool", "lookup", "api", "openai" },

      providers = {
        openai = {
          disable = false,
          secret = { "secret-tool", "lookup", "api", "openai" },
        },
        copilot = {
          disable = false,
          secret = {
            "bash",
            "-c",
            "cat ~/.config/github-copilot/apps.json | sed -e 's/.*oauth_token...//;s/\".*//'",
          },
        },
        anthropic = {
          disable = false,
          secret = { "secret-tool", "lookup", "api", "anthropic" },
        },
        googleai = {
          secret = { "secret-tool", "lookup", "api", "googleai" },
        },
        pplx = {
          secret = { "secret-tool", "lookup", "api", "pplx" },
        },
      },

      ----------------------------------------------------------------------------------------------
      -- Agents
      ----------------------------------------------------------------------------------------------
      agents = {
        -- disable default agents
        { name = "ChatGPT4o", disable = true },
        { name = "CodeGPT4o", disable = true },
        { name = "ChatGPT4o-mini", disable = true },
        { name = "CodeGPT4o-mini", disable = true },
        { name = "ChatClaude-3-5-Sonnet", disable = true },
        { name = "CodeClaude-3-5-Sonnet", disable = true },
        { name = "ChatClaude-3-Haiku", disable = true },
        { name = "CodeClaude-3-Haiku", disable = true },
        { name = "ChatGemini", disable = true },
        { name = "CodeGemini", disable = true },
        { name = "ChatPerplexityLlama3.1-8B", disable = true },
        { name = "CodePerplexityLlama3.1-8B", disable = true },
        { name = "ChatCopilot", disable = true },
        { name = "CodeCopilot", disable = true },
        {
          provider = "openai",
          name = "openai-mini",
          chat = true,
          command = true,
          model = {
            model = "o3-mini",
          },
          system_prompt = require("gp.defaults").chat_system_prompt
            .. "\n\nAlways answer in English regardless of input language.",
        },
        {
          provider = "anthropic",
          name = "claude",
          chat = true,
          command = false,
          model = {
            model = "claude-3-7-sonnet-latest",
            temperature = 0.9,
            max_token = 8192,
          },
          system_prompt = require("gp.defaults").chat_system_prompt
            .. "\n\nAlways answer in English regardless of input language.",
        },
        {
          provider = "anthropic",
          name = "claude-command",
          chat = false,
          command = true,
          model = {
            model = "claude-3-7-sonnet-latest",
            temperature = 0.9,
            max_token = 8192,
          },
          system_prompt = require("gp.defaults").code_system_prompt,
        },
        {
          provider = "googleai",
          name = "gemini",
          chat = true,
          command = false,
          model = {
            model = "gemini-2.5-pro-exp-03-25",
            temperature = 0.9,
          },
          system_prompt = require("gp.defaults").chat_system_prompt
            .. "\n\nAlways answer in English regardless of input language.",
        },
        {
          provider = "googleai",
          name = "gemini-command",
          chat = false,
          command = true,
          model = {
            model = "gemini-2.0-flash",
            -- top_k = 40, -- range 0 -- 41
            -- model = "gemini-2.5-pro-exp-03-25",
            temperature = 0.9,
          },
          system_prompt = require("gp.defaults").code_system_prompt
            .. "\n\nAlways answer in English regardless of input language.",
        },
      },

      ----------------------------------------------------------------------------------------------
      -- Pre-defined tasks
      ----------------------------------------------------------------------------------------------
      hooks = {
        UnitTests = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please respond by writing table driven unit tests for the code above."
          local agent = gp.get_command_agent()
          gp.Prompt(params, gp.Target.vnew, agent, template)
        end,

        Proofread = function(gp, params)
          local template = [[```
{{selection}}
```
]]
          local agent = gp.get_command_agent()
          agent.system_prompt =
            [[Act as a multilingual expert proofreader and grammar specialist with the following responsibilities:

Primary Tasks:
- Analyze provided text for grammatical errors, syntax issues, and structural problems
- Maintain the original meaning and intent while improving technical accuracy
- Provide corrections in the same language as the source text
- Ensure consistency in style and tone

Specific Focus Areas:
- Spelling and punctuation accuracy
- Word choice and vocabulary appropriateness
- Sentence structure and flow
- Tense consistency
]]
          gp.Prompt(params, gp.Target.vnew, agent, template)
        end,

        GrammarCheck = function(gp, params)
          local template = [[```
{{selection}}
```
]]
          local agent = gp.get_command_agent()
          agent.system_prompt =
            [[Act as a multilingual grammar specialist with the following responsibilities:

Primary Tasks:
- Analyze provided text for grammatical errors, syntax issues
- Provide corrections in the same language as the source text
- Ensure consistency in style and tone
- Reply the correction and nothing else, do not write explanations.
]]
          gp.Prompt(params, gp.Target.vnew, agent, template)
        end,

        EnglishTranslate = function(gp, params)
          local template = [[```
{{selection}}
```
]]
          local agent = gp.get_command_agent("claude-command")
          agent.system_prompt =
            [[I want you to act as an English translator, spelling corrector and improver. The given text is sentences I roughly wrote, and I would like you to translate it and answer in the corrected and improved version of my text, in English. You should ensure the sentences are simple and easy to understand for non-native English speakers. Hence, avoid complex vocabulary and sentence structures. I want you to only reply the correction, the improvements and nothing else, do not write explanations.]]
          gp.Prompt(params, gp.Target.vnew, agent, template)
        end,
      },
    })
  end,

  -- stylua: ignore
  keys = {
    { [1] = prefix .. keyword, mode = "n", [2] = "<cmd>GpChatToggle vsplit<CR>",      desc = "chat-toggle (Gp)" },

    { [1] = prefix .. "p",     mode = "n", [2] = "<cmd>%GpChatPaste split<CR>",      desc = "Paste buffer (Gp)", },
    { [1] = prefix .. "p",     mode = "v", [2] = ":<C-u>'<,'>GpChatPaste split<CR>", desc = "Paste selected (Gp)" },

    { [1] = prefix .. "N",     mode = "n", [2] = "<cmd>%GpChatNew split<CR>",        desc = "NEW w. buffer (Gp)", },
    { [1] = prefix .. "N",     mode = "v", [2] = ":<C-u>'<,'>GpChatNew split<CR>",   desc = "NEW w. selected (Gp)" },

    { [1] = prefix .. "T",     mode = "n", [2] = "<cmd>GpChatNew<CR>",   desc = "empTy-chat (Gp)" },

    { [1] = prefix .. "q",     mode = "n", [2] = "<cmd>%GpVnew<CR>",     desc = "Quick (edit-buffer; Gp)", },
    { [1] = prefix .. "q",     mode = "v", [2] = ":<C-u>'<,'>GpNew<CR>", desc = "Quick (edit-selected; Gp)" },

    { [1] = tprefix .. "g",    mode = "v", [2] = ":<C-u>'<,'>GpGrammarCheck<CR>", desc = "gp-grammar-check" },
    { [1] = tprefix .. "t",    mode = "v", [2] = ":<C-u>'<,'>GpEnglishTranslate<CR>", desc = "gp-english-translate" },
    { [1] = tprefix .. "p",    mode = "v", [2] = ":<C-u>'<,'>GpProofread<CR>", desc = "gp-proofread" },

    -- match LazyVim's key mappnig convention
    -- { [1] = "<Leader>s" .. keyword, mode = "n", [2] = "<cmd>GpChatFinder<CR>", desc = "gp-chat (Gp)" },
    { [1] = "<Leader>f" .. keyword, mode = "n", [2] = "<cmd>GpChatFinder<CR>", desc = "gp-chat (Gp)" },
  },
  specs = {
    {
      [1] = "which-key.nvim",
      optional = true,
      -- ---@type wk.Opts
      opts = {
        icons = {
          ---@type wk.IconRule[]
          rules = {
            { plugin = "gp.nvim", icon = wk_icon.icon, color = wk_icon.color },
          },
        },
        ---@type wk.Spec
        spec = {
          { [1] = prefix, mode = { "n", "v" }, group = "gp", icon = wk_icon },
          { [1] = tprefix, mode = { "n", "v" }, group = "task", icon = wk_icon },
        },
      },
    },
  },
}
