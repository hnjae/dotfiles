---@type LazySpec[]
return {
  {
    [1] = "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local null_ls = require("null-ls")

      local mapping = {
        -- TODO: 이거 nvim-lint 로 써보자. <2025-02-22>
        -- commitlint = { null_ls.builtins.diagnostics.commitlint },
      }

      for exe, sources in pairs(mapping) do
        if vim.fn.executable(exe) == 1 then
          vim.list_extend(opts.sources, sources)
        end
      end
    end,
  },
  {
    [1] = "Robitx/gp.nvim",
    optional = true,
    keys = function(_, keys)
      local map_keyword = require("globals").map_keyword
      -- local bufprefix = "<LocalLeader>" ..
      local bufprefix2 = "<LocalLeader>" .. string.upper(map_keyword.ai)
      local mykeys = {
        {
          [1] = bufprefix2 .. "e",
          [2] = ":<C-u>'<,'>GpEditCommitMsg<CR>",
          desc = "gp-edit-commit-message",
          mode = { "v" },
        },
        {
          [1] = bufprefix2 .. "g",
          [2] = "<cmd>GpGenerateCommit<CR>",
          ft = "gitcommit",
          desc = "generate-commit",
        },
      }

      vim.list_extend(keys, mykeys)
    end,
    opts = function(_, opts)
      if not opts.hooks then
        opts.hooks = {}
      end

      opts.hooks.GenerateCommitMsg = function(gp, params)
        local gitdiff = vim
          .system({ "git", "diff", "--staged" }, { text = true })
          :wait().stdout
        local template = string.format(
          [[```diff
%s
```]],
          gitdiff
        )

        local agent = gp.get_command_agent()
        -- local agent = gp.get_command_agent("claude-command")
        agent.system_prompt =
          [[Suggest a precise and informative commit message based on the following diff. Use markdown syntax in your response if needed.

The commit message should follow the Angular commit message format:

    <type>(<scope>): <short summary>
    <BLANK LINE>
    <body>
    <BLANK LINE>
    <footer>

Where:

*   `<type>` is one of: build, chore, ci, docs, feat, fix, perf, refactor, revert, style, test
*   `<scope>` is optional and represents the module affected (e.g., core, common, forms)
*   `<short summary>` starts with lowercase, doesn't end with a period, and is limited to 50 characters
*   `<body>` is optional, uses present tense, and wraps at 72 characters
*   `<footer>` is optional and contains any breaking changes or closed issues

Examples:

    feat(user-profile): add ability to update user avatar

    Implement a new feature allowing users to upload and update their profile avatar.
    This change includes:
    - New API endpoint for avatar upload
    - Frontend UI updates in the profile section
    - Image processing to resize and optimize uploaded avatars

    Closes #123

If necessary, include an explanatory body and/or footer to provide more context about the changes, their rationale, and any significant impacts or considerations.

Diff:
]]
        gp.Prompt(params, gp.Target.rewrite, agent, template)
      end

      opts.hooks.EditCommitMsg = function(gp, params)
        local template = [[```gitcommit
{{selection}}
```]]
        local agent = gp.get_command_agent()
        agent.system_prompt =
          [[I want you to serve as a Git commit message optimizer that follows the Conventional Commits specification. Your task is to:

1. Take my rough commit message as input
2. Transform it into a well-structured commit message following this format:
   <type>(<optional scope>): <description>

   [optional body]

   [optional footer(s)]

Requirements:
- Use clear, standard English vocabulary
- Keep messages concise but descriptive
- Make it understandable for non-native English speakers
- Choose appropriate type prefixes (feat, fix, docs, style, refactor, test, chore)
- Include scope when relevant
- Break down complex changes into bullet points in the body if needed

Please provide only the formatted commit message without any additional explanation or commentary.

Example input: "added login button to homepage"
Expected output format:
feat(auth): add login button to homepage navigation

- Implement responsive button component
- Add basic click handler
- Style according to design system
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
  },
}
