return {
  name = "leetcode-test",
  builder = function()
    local num = string.match(vim.fn.expand("%:t:r"), "^[0-9]+")

    if not num then
      return {
        cmd = { "echo", "can't recognize number" },
      }
    end

    return {
      cmd = { "leetcode", "test", num },
      components = {
        -- { [1] = "on_output_quickfix", open = true },
        "on_exit_set_status",
        "on_complete_dispose",
        { [1] = "unique", replace = true },
      },
    }
  end,
  condition = {
    callback = function()
      -- return true
      local match = string.match(vim.fn.expand("%:p"), "^.*/leetcode/.*$")
      if match then
        return true
      end
      return false
    end,
  },
}
