return {
  [1] = "ntpeters/vim-better-whitespace",
  lazy = true,
  event = { "TextChanged" },
  init = function()
    vim.g.strip_whitespace_on_save = 1
    vim.g.strip_whitelines_at_eof = 1

    vim.g.strip_whitespace_confirm = 0
    vim.g.strip_max_file_size = 10000

    -- 공백을 칠하는것 금지.
    vim.g.better_whitespace_enabled = 0
    vim.g.show_spaces_that_precede_tabs = 0

    -- vim.g.better_whitespace_ctermcolor = 'bg'
    -- vim.g.better_whitespace_guicolor = 'bg'
    -- let g:current_line_whitespace_disabled_soft

    -- exclude markdown from blacklists
    vim.g.better_whitespace_filetypes_blacklist = {
      "diff",
      "git",
      "gitcommit",
      "unite",
      "qf",
      "help",
      "fugitive",
    }

    -- disable mappings
    vim.g.better_whitespace_operator = ""
  end,
  config = function()
    -- remove all unnecessary commands
    for _, command in pairs({
      "ToggleWhitespace",
      "EnableWhitespace",
      "DisableWhitespace",
      "NextTrailingWhitespace",
      "PrevTrailingWhitespace",
      "StripWhitespace",
      "StripWhitespaceOnChangedLines",
      "ToggleStripWhitespaceOnSave",
      "EnableStripWhitespaceOnSave",
      "DisableStripWhitespaceOnSave",
      "CurrentLineWhitespaceOn",
      "CurrentLineWhitespaceOff",
    }) do
      vim.api.nvim_del_user_command(command)
    end
  end,
}
