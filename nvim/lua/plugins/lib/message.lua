-- https://github.com/AckslD/messages.nvim

---@type LazySpec
return {
  [1] = "AckslD/messages.nvim",
  lazy = true,
  cmd = {
    "Messages",
  },
  opts = function()
    local ret = {
      -- help: nvim_open_win()'s `{config}`
      ---@type fun(lines: string[]): table
      buffer_opts = function(lines)
        local gheight = vim.api.nvim_list_uis()[1].height
        local gwidth = vim.api.nvim_list_uis()[1].width
        return {
          title = "Messages",
          relative = "editor",
          width = gwidth - 1,
          height = require("messages.utils").clip_val(8, #lines, gheight * 0.5),
          anchor = "SW",
          row = gheight - 1,
          col = 0,
          style = "minimal",
          border = "rounded",
          zindex = 1,
        }
      end,
      ---@type fun(winnr: number): nil
      post_open_float = function(winnr)
        local bufnr = vim.api.nvim_win_get_buf(winnr)
        vim.api.nvim_buf_set_option(bufnr, "filetype", "txt")
        -- vim.api.nvim_buf_set_option(bufnr, "wrap", true)
      end,
    }
    return ret
  end,
  config = function(_, opts)
    require("messages").setup(opts)
    Msg = function(...)
      require("messages.api").capture_thing(...)
    end
  end,
}
