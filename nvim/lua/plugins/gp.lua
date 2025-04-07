--[[
NOTE:
  - run `:GpInspectPlugin` to debug
  - run `secret-tool store --label=<api-anthropic> api anthropic` to save password

  - 같이 보기:
    * <https://ai.google.dev/pricing>
    * <https://docs.anthropic.com/en/api/messages>

TODO:
  - gp-chat 경로의 markdown 은 textwidth=0 으로 지정 <2025-04-02>
]]

local keyword = "i"
local prefix = "<Leader>" .. keyword
local vprefix = "<Leader>" .. keyword .. "t"

---@type LazySpec
return {
  [1] = "Robitx/gp.nvim",
  lazy = true,
  cond = not vim.g.vscode,
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
        vim.notify(icon .. " : GpDone!", "info")
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
    local myopts = {
      command_prompt_prefix_template = icon .. " {{agent}} ~ ",

      chat_assistant_prefix = { icon, " [{{agent}}]" },

      chat_user_prefix = (require("globals").icons.textbox .. " :"),

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

      default_command_agent = "gemini-command",
      -- default_chat_agent = "claude-sonnet",
      default_chat_agent = "gemini",

      chat_template = [[
# topic: ?

- file: {{filename}}
{{optional_headers}}
<!--
Respond : `{{respond_shortcut}}` | :{{cmd_prefix}}ChatRespond
Stop    : `{{stop_shortcut}}` | :{{cmd_prefix}}ChatStop
Delete  : `{{delete_shortcut}}` | :{{cmd_prefix}}ChatDelete.
New     : `{{new_shortcut}}` | :{{cmd_prefix}}ChatNew.

Chats are saved automatically.
-->
---

{{user_prefix}}
]],

      style_popup_max_width = 120,

      -- Keys
      openai_api_key = { "secret-tool", "lookup", "api", "openai" },

      providers = {
        openai = {
          disable = false,
        },
        copilot = {
          disable = false,
          secret = { "bash", "-c", "cat ~/.config/github-copilot/apps.json | sed -e 's/.*oauth_token...//;s/\".*//'" },
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
          name = "gemini-command",
          chat = false,
          command = true,
          model = {
            model = "gemini-2.0-flash",
            -- model = "gemini-2.5-pro-exp-03-25",
            temperature = 0.9,
            top_k = 40, -- range 0 -- 41
          },
          system_prompt = "",
        },
      },

      hooks = {
        UnitTests = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please respond by writing table driven unit tests for the code above."
          local agent = gp.get_command_agent("claude-3-7-sonnet")
          gp.Prompt(params, gp.Target.vnew, agent, template)
        end,
        Proofread = function(gp, params)
          local template = [[```
{{selection}}
```
]]
          local agent = gp.get_command_agent("claude-3-7-sonnet")
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
          local agent = gp.get_command_agent("claude-3-5-haiku")
          agent.system_prompt = [[Act as a multilingual grammar specialist with the following responsibilities:

Primary Tasks:
- Analyze provided text for grammatical errors, syntax issues
- Provide corrections in the same language as the source text
- Reply the correction and nothing else, do not write explanations.
]]
          gp.Prompt(params, gp.Target.vnew, agent, template)
        end,
        EnglishTranslate = function(gp, params)
          local template = [[```
{{selection}}
```
]]
          local agent = gp.get_command_agent("claude-3-5-haiku")
          agent.system_prompt =
            [[I want you to act as an English translator, spelling corrector and improver. The given text is sentences I roughly wrote, and I would like you to translate it and answer in the corrected and improved version of my text, in English. You should ensure the sentences are simple and easy to understand for non-native English speakers. Hence, avoid complex vocabulary and sentence structures. I want you to only reply the correction, the improvements and nothing else, do not write explanations.]]
          gp.Prompt(params, gp.Target.vnew, agent, template)
        end,
      },
    }

    vim.tbl_deep_extend("keep", myopts, opts)
    return myopts
  end,

  -- stylua: ignore
  keys = {
    { [1] = prefix .. keyword, mode = "n", [2] = "<cmd>GpChatToggle vsplit<CR>",      desc = "gp-chat-toggle" },
    { [1] = prefix .. "n",     mode = "v", [2] = ":<C-u>'<,'>GpChatNew split<CR>",   desc = "NEW-chat-with-selected" },
    { [1] = prefix .. "N",     mode = "n", [2] = "<cmd>%GpChatNew split<CR>",        desc = "NEW-chat-with-buffer", },
    { [1] = prefix .. "p",     mode = "v", [2] = ":<C-u>'<,'>GpChatPaste split<CR>", desc = "paste-with-selected" },
    { [1] = prefix .. "q",     mode = "v", [2] = ":<C-u>'<,'>GpNew<CR>",             desc = "gp-quich-chat (edit-selected)" },
    { [1] = prefix .. "E",     mode = "n", [2] = "<cmd>%GpVnew<CR>", desc = "gp-edit-buffer", },
    { [1] = vprefix .. "g",    mode = "v", [2] = ":<C-u>'<,'>GpGrammarCheck<CR>", desc = "gp-grammer-check" },
    { [1] = vprefix .. "t",    mode = "v", [2] = ":<C-u>'<,'>GpEnglishTranslate<CR>", desc = "gp-english-translate" },
    { [1] = vprefix .. "p",    mode = "v", [2] = ":<C-u>'<,'>GpProofread<CR>", desc = "gp-proofread" },
  },
  specs = {
    {
      [1] = "folke/which-key.nvim",
      optional = true,
      opts = function(_, opts)
        opts.icons = opts.icons or {}
        opts.icons.rules = opts.icons.rules or {}
        opts.spec = opts.spec or {}

        local icon = require("globals").icons.ai

        table.insert(opts.icons.rules, {
          plugin = "gp.nvim",
          icon = icon,
          color = "purple",
        })

        vim.list_extend(opts.spec, {
          {
            [1] = prefix,
            group = "gp-chat",
            icon = icon,
          },
          {
            [1] = vprefix,
            group = "gp-chat",
            icon = icon,
          },
        })
      end,
    },
  },
}
