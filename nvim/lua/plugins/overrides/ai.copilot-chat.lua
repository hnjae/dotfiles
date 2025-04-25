---@type LazySpec
return {
  [1] = "CopilotChat.nvim",
  optional = true,
  opts = {
    model = "claude-3.7-sonnet", -- Default model to use, see ':CopilotChatModels' for available models (can be specified manually in prompt via $).

    -- default mappings

    mappings = {
      complete = {
        insert = "<Tab>",
      },
      close = {
        normal = "q",
        insert = "<C-c>",
      },
      reset = {
        normal = "<C-g-r>", -- default '<C-l>'
        insert = "<C-g-r>", -- default '<C-l>'
      },
      submit_prompt = {
        normal = "<CR>",
        insert = "<C-s>",
      },
      toggle_sticky = {
        normal = "grr",
      },
      clear_stickies = {
        normal = "grx",
      },
      accept_diff = {
        normal = "<C-y>",
        insert = "<C-y>",
      },
      jump_to_diff = {
        normal = "gj",
      },
      quickfix_answers = {
        normal = "gqa",
      },
      quickfix_diffs = {
        normal = "gqd",
      },
      yank_diff = {
        normal = "gy",
        register = '"', -- Default register to use for yanking
      },
      show_diff = {
        normal = "gd",
        full_diff = false, -- Show full diff instead of unified diff when showing diff window
      },
      show_info = {
        normal = "gi",
      },
      show_context = {
        normal = "gc",
      },
      show_help = {
        normal = "gh",
      },
    },
  },
}
