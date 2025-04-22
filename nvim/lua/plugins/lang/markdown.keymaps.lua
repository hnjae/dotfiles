---@type LazySpec
return {
  [1] = "LazyVim",
  optional = true,
  keys = {
    -- from <https://github.com/linkarzu/dotfiles-latest>
    {
      "<Leader>chI",
      function()
        -- Save the current cursor position
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        -- I'm using [[ ]] to escape the special characters in a command
        vim.cmd([[:g/\(^$\n\s*#\+\s.*\n^$\)/ .+1 s/^#\+\s/#&/]])
        -- Restore the cursor position
        vim.api.nvim_win_set_cursor(0, cursor_pos)
        -- Clear search highlight
        vim.cmd("nohlsearch")
      end,
      ft = "markdown",
      desc = "[P]Increase headings without confirmation",
    },
  },
}
