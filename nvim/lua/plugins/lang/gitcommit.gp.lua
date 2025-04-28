local keyword = "i"
local tprefix = "<Leader>" .. keyword .. "t" -- task

---@type LazySpec
return {
  [1] = "gp.nvim",
  optional = true,
  keys = function(_, keys)
    local mykeys = {
      {
        [1] = tprefix .. "e",
        [2] = ":<C-u>'<,'>GpEditCommitMsg<CR>",
        desc = "gp-edit-commit-message",
        mode = { "v" },
      },
      {
        [1] = tprefix .. "g",
        [2] = "<cmd>GpGenerateCommit<CR>",
        ft = "gitcommit",
        desc = "generate-commit",
      },
    }

    return vim.list_extend(keys, mykeys)
  end,
  opts = function(_, opts)
    opts.hooks = opts.hooks or {}

    opts.hooks.GenerateCommitMsg = function(gp, params)
      local gitdiff = vim.system({ "git", "diff", "--staged" }, { text = true }):wait().stdout
      local template = string.format(
        [[```diff
          %s
          ```]],
        gitdiff
      )

      local agent = gp.get_command_agent()
      agent.system_prompt =
        [[Generate a commit message for the provided diff using the conventional commit format:

type(optional scope): description

Where:
- type = feat, fix, docs, style, refactor, test, chore, etc.
- scope = the area of code affected (optional)
- description = what changed and why

Use simple language (B1-B2 English level):
- Short, clear sentences
- Common vocabulary
- No technical jargon unless necessary

IMPORTANT: Return ONLY the commit message with no additional text, explanations, or commentary.

]]
      --         [[Suggest a precise and informative commit message based on the following diff. Use markdown syntax in your response if needed.
      --
      -- The commit message should follow the Angular commit message format:
      --
      --     <type>(<scope>): <short summary>
      --     <BLANK LINE>
      --     <body>
      --     <BLANK LINE>
      --     <footer>
      --
      -- Where:
      --
      -- *   `<type>` is one of: build, chore, ci, docs, feat, fix, perf, refactor, revert, style, test
      -- *   `<scope>` is optional and represents the module affected (e.g., core, common, forms)
      -- *   `<short summary>` starts with lowercase, doesn't end with a period, and is limited to 50 characters
      -- *   `<body>` is optional, uses present tense, and wraps at 72 characters
      -- *   `<footer>` is optional and contains any breaking changes or closed issues
      --
      -- Examples:
      --
      --     feat(user-profile): add ability to update user avatar
      --
      --     Implement a new feature allowing users to upload and update their profile avatar.
      --     This change includes:
      --     - New API endpoint for avatar upload
      --     - Frontend UI updates in the profile section
      --     - Image processing to resize and optimize uploaded avatars
      --
      --     Closes #123
      --
      -- If necessary, include an explanatory body and/or footer to provide more context about the changes, their rationale, and any significant impacts or considerations.
      --
      -- Diff:
      -- ]]
      gp.Prompt(params, gp.Target.rewrite, agent, template)
    end

    opts.hooks.EditCommitMsg = function(gp, params)
      local template = [[```gitcommit
{{selection}}
```]]
      local agent = gp.get_command_agent()
      agent.system_prompt =
        [[Transform my rough git commit message into a conventional commit format that follows the pattern: type(optional scope): description

Make the language simple and clear for non-native English speakers (B1-B2 level) by:
- Using common vocabulary
- Writing short, direct sentences
- Avoiding idioms and complex phrases
- Keeping technical terms when necessary

Provide only the formatted commit message without any additional text.

Paste your rough commit message below:
]]
      gp.Prompt(params, gp.Target.rewrite, agent, template)
    end

    opts.hooks.EditCommitMsg2 = function(gp, params)
      local template = [[```gitcommit
{{selection}}
```]]
      local agent = gp.get_command_agent()
      agent.system_prompt =
        [[I want you to act as a commit message generator. The given text is the commit message I roughly wrote, and I would like you to generate an appropriate commit message using the conventional commit format. The commit message must be in standard English and easy to understand for non-native English speakers. Do not write any explanations or other words, just reply with the commit message.]]
      gp.Prompt(params, gp.Target.rewrite, agent, template)
    end
  end,
}
