---@type LazySpec
return {
  [1] = "olimorris/codecompanion.nvim",
  version = "*",
  lazy = true,
  event = "VeryLazy", -- maybe something else
  opts = function(_, opts)
    local code_prompt =
      [[You are a code editor AI that modifies, optimizes, or fixes code snippets. When given code, respond with only the edited version without explanations, comments, or additional text.]]

    local function openrouter_adapter(model, extra)
      return function()
        local schema = {
          model = {
            default = model,
          },
        }

        if extra then
          schema = vim.tbl_deep_extend("force", schema, extra)
        end

        return require("codecompanion.adapters").extend("openai_compatible", {
          formatted_name = "OpenRouter",
          env = {
            api_key = "cmd:op read op://Personal/openrouter-local/credential",
            url = "https://openrouter.ai/api",
            chat_url = "/v1/chat/completions",
            models_endpoint = "/v1/models",
          },
          schema = schema,
        })
      end
    end

    local function inline_filter(alias, description, placement, system_prompt, user_prompt)
      return {
        interaction = "inline",
        description = description,
        opts = {
          alias = alias,
          adapter = { name = "openrouter_language" },
          auto_submit = true,
          modes = { "v" },
          placement = placement,
          stop_context_insertion = true,
        },
        prompts = {
          {
            role = "system",
            content = system_prompt,
          },
          {
            role = "user",
            content = user_prompt,
          },
        },
      }
    end

    return vim.tbl_deep_extend("force", opts, {
      adapters = {
        http = {
          opts = {
            show_model_choices = false,
          },
          openrouter_chat = openrouter_adapter("openai/gpt-5.4-mini", {
            think = {
              mapping = "parameters",
              type = "boolean",
              default = true,
            },
          }),
          openrouter_light_think = openrouter_adapter("google/gemini-3-flash-preview", {
            think = {
              mapping = "parameters",
              type = "boolean",
              default = true,
            },
          }),
          openrouter_light = openrouter_adapter("openai/gpt-5.4-nano", {
            think = {
              mapping = "parameters",
              type = "boolean",
              default = true,
            },
          }),
          openrouter_language = openrouter_adapter("google/gemini-3-flash-preview", {
            think = {
              mapping = "parameters",
              type = "boolean",
              default = true,
            },
          }),
        },
      },
      interactions = {
        chat = {
          adapter = "openrouter_chat",
        },
        inline = {
          adapter = "openrouter_light_think",
        },
        cmd = {
          adapter = "openrouter_light",
        },
      },
      prompt_library = {
        ["Edit commit message"] = inline_filter(
          "edit_commit_msg",
          "Rewrite selected text as a conventional commit message",
          "replace",
          [[Transform my rough commit text into a conventional commit message. Follow the format type(optional scope): description where type is one of: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert.

If my text doesn't clearly indicate the type, infer it from context. Use clear, simple English accessible to non-native speakers. Keep the message concise (under 72 characters if possible).

Return only the formatted commit message without explanations.]],
          [[Transform this text:

```gitcommit
${context.code}
```]]
        ),

        ["Generate commit message"] = {
          interaction = "inline",
          description = "Generate a conventional commit message from staged changes",
          opts = {
            alias = "generate_commit",
            adapter = { name = "openrouter_light" },
            auto_submit = true,
            placement = "add",
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "system",
              content = [[Generate a conventional commit message from the provided diff.

Requirements:
- Use type: feat, fix, build, chore, ci, docs, style, refactor, perf, or test
- Add scope if helpful: type(scope): description
- For breaking changes: add ! after type/scope or BREAKING CHANGE: footer
- First line: max 50 characters
- Body lines: max 72 characters
- Use simple, clear English (B2 level)

Return only the commit message.]],
            },
            {
              role = "user",
              content = function()
                local diff = vim
                  .system({ "git", "diff", "--no-ext-diff", "--staged" }, { text = true })
                  :wait().stdout
                return string.format("```diff\n%s\n```", diff)
              end,
            },
          },
        },

        ["Grammar check"] = inline_filter(
          "grammar_check",
          "Correct grammar in the selected text",
          "replace",
          [[You are a precise multilingual grammar corrector with linguistic expertise in multiple languages. When I provide text:

1. Correct all grammatical errors, syntax issues, punctuation mistakes, and improve sentence structure while maintaining perfect adherence to the language's rules.
2. Faithfully preserve the original:
  - Language (never translate)
  - Writing style and voice
  - Terminology and technical vocabulary
  - Meaning and intent of the message
3. Return ONLY the corrected version of the text without explanations, comments, or formatting changes.

Only process content between <text> and </text> tags.]],
          [[<text>
${context.code}
</text>]]
        ),

        ["English translate"] = inline_filter(
          "english_translate",
          "Translate selected text into clear English",
          "replace",
          [[You are an English translator, spelling corrector and improver. Transform text between <text> tags into clear, correct English that's easily understood by non-native speakers. Fix spelling, grammar, and phrasing while simplifying complex language.

Respond only with the improved text--no explanations, comments, or other text.]],
          [[<text>
${context.code}
</text>]]
        ),

        ["Proofread"] = inline_filter(
          "proofread",
          "Proofread selected text and show the result in a new buffer",
          "new",
          [[You are a multilingual language perfectionist. When presented with text:

1. Analyze and correct technical errors in:
   - Spelling and punctuation
   - Vocabulary and word choice
   - Syntax and sentence structure
   - Grammatical consistency (tense, number, voice)

2. Always:
   - Respond in the same language as the source text
   - Preserve the original meaning and intent
   - Maintain the author's style and tone

Present corrections clearly, explaining significant changes only when necessary.

Only process content between <text> and </text> tags.]],
          [[<text>
${context.code}
</text>]]
        ),

        ["Unit tests"] = {
          interaction = "inline",
          description = "Generate table-driven unit tests for the selected code",
          opts = {
            alias = "unit_tests",
            adapter = { name = "openrouter_light_think" },
            auto_submit = true,
            modes = { "v" },
            placement = "new",
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "system",
              content = code_prompt,
            },
            {
              role = "user",
              content = [[I have the following code from `${context.filename}`:

```${context.filetype}
${context.code}
```

Please respond by writing table driven unit tests for the code above.]],
            },
          },
        },
      },
    })
  end,
  -- stylua: ignore
  keys = {
    { [1] = "<Leader>itp", mode = "v", [2] = ":<C-u>'<,'>CodeCompanion /proofread<CR>", desc = "proofread" },
    { [1] = "<Leader>itg", mode = "v", [2] = ":<C-u>'<,'>CodeCompanion /grammar_check<CR>", desc = "grammar-check" },
    { [1] = "<Leader>itt", mode = "v", [2] = ":<C-u>'<,'>CodeCompanion /english_translate<CR>", desc = "english-translate" },
    { [1] = "<Leader>ite", mode = "v", [2] = ":<C-u>'<,'>CodeCompanion /edit_commit_msg<CR>", desc = "edit-commit-message" },
    { [1] = "<Leader>itu", mode = "v", [2] = ":<C-u>'<,'>CodeCompanion /unit_tests<CR>", desc = "unit-tests" },
    { [1] = "<Leader>itg", mode = "n", ft = "gitcommit", [2] = "<cmd>CodeCompanion /generate_commit<CR>", desc = "generate-commit" },
  },
  dependencies = {
    { "nvim-treesitter/nvim-treesitter" },
    { "nvim-lua/plenary.nvim" },
    {
      [1] = "nvim-cmp",
      optional = true,
      ---@param opts cmp.ConfigSchema
      opts = function(_, opts)
        table.insert(opts.sources, {
          name = "codecompanion",
        })

        return opts
      end,
    },
  },
}
