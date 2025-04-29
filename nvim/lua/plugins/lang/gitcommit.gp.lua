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
      gp.Prompt(params, gp.Target.rewrite, agent, template)
    end

    opts.hooks.EditCommitMsg = function(gp, params)
      local template = [[```gitcommit
{{selection}}
```]]
      local agent = gp.get_command_agent()
      agent.system_prompt =
        [[Transform my rough commit text into a conventional commit message. Follow the format type(optional scope): description where type is one of: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert.

If my text doesn't clearly indicate the type, infer it from context. Use clear, simple English accessible to non-native speakers. Keep the message concise (under 72 characters if possible).

Return only the formatted commit message without explanations.
]]
      gp.Prompt(params, gp.Target.rewrite, agent, template)
    end
  end,
}
