local val = require("val")
local prefix = val.prefix.task
local key_word_overseer = prefix:sub(-1, -1)
local map_keyword = require("val").map_keyword

-- or
-- "jedrzejboczar/toggletasks.nvim",

---@type LazySpec
return {
  -- https://code.visualstudio.com/Docs/editor/tasks
  [1] = "stevearc/overseer.nvim",
  enabled = true,
  lazy = false,
  cmd = {
    "OverseerRun",
    "OverseerInfo",
    "OverseerBuild",
    "OverseerOpen",
    "WatchRun",
  },
  keys = {
    {
      -- [1] = string.format("%s.%s", prefix, prefix.sub(-1, -1)),
      [1] = prefix .. key_word_overseer,
      -- [2] = "<C-\\><C-n>:Overseer"
      [2] = "<cmd>Telescope commands<CR>overseer ",
      desc = "run-cmd",
    },
    {
      -- [1] = string.format("%s.%s", prefix, prefix.sub(-1, -1)),
      [1] = prefix .. "r",
      [2] = "<cmd>OverseerRun<CR>",
      desc = "run",
    },
    {
      [1] = require("val").prefix.sidebar .. key_word_overseer,
      [2] = "<cmd>OverseerOpen<CR>",
      desc = "overseer",
    },
  },
  opts = {
    templates = { "builtin", "user.run-file" },
  },
  config = function(_, opts)
    require("overseer").setup(opts)

    vim.api.nvim_create_user_command("WatchRun", function()
      local overseer = require("overseer")

      -- 2024-02-01 copied from https://github.com/stevearc/overseer.nvim/blob/master/doc/tutorials.md
      -- follows MIT license
      overseer.run_template({ name = "run file" }, function(task)
        if task then
          task:add_component({
            [1] = "restart_on_save",
            paths = { vim.fn.expand("%:p") },
          })
          local main_win = vim.api.nvim_get_current_win()
          overseer.run_action(task, "open vsplit")
          vim.api.nvim_set_current_win(main_win)
        else
          vim.notify(
            "WatchRun not supported for filetype " .. vim.bo.filetype,
            vim.log.levels.ERROR
          )
        end
      end)
    end, {})
  end,
}
