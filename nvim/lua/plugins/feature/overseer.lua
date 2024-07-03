-- https://code.visualstudio.com/Docs/editor/tasks

local val = require("val")
local prefix = val.prefix.task
local key_word_overseer = prefix:sub(-1, -1)
local map_keyword = require("val").map_keyword

-- or
-- "jedrzejboczar/toggletasks.nvim",

---@return number|nil
local function get_oversee_bufnr()
  local len_winnr = vim.fn.winnr("$")

  local bufnr, filetype
  for winnr = 0, (len_winnr - 1) do
    bufnr = vim.fn.winbufnr(winnr)
    filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    if filetype == "OverseerList" then
      return winnr
    end
  end

  return nil
end

---@type LazySpec
return {
  [1] = "stevearc/overseer.nvim",
  enabled = true,
  lazy = true,
  dependencies = {
    {
      [1] = "nvim-telescope/telescope.nvim",
      optional = true,
      keys = {
          -- stylua: ignore start
          { [1] = prefix .. "z", [2] = "<cmd>Telescope commands<CR>overseer ", desc = "list", },
        -- stylua: ignore end
      },
    },
  },
  cmd = {
    "OverseerRun",
    "OverseerInfo",
    "OverseerBuild",
    "OverseerOpen",
    "WatchRun",
  },
  keys = {
    {
      [1] = prefix .. key_word_overseer:upper(),
      [2] = "<cmd>OverseerRun<CR>",
      desc = "run-new-template",
    },
    {
      [1] = prefix .. key_word_overseer,
      [2] = function()
        local tasks = require("overseer.task_list").list_tasks()
        if next(tasks) == nil then
          vim.cmd("OverseerRun")
          return
        end

        vim.cmd([[OverseerQuickAction restart]])
      end,
      -- "<cmd>OverseerQuickAction restart<CR>",
      desc = "run-or-restart",
    },
    {
      [1] = require("val").prefix.focus .. key_word_overseer,
      [2] = "<cmd>OverseerOpen<CR>",
      desc = "overseer (task-runner)",
    },
    {
      [1] = require("val").prefix.sidebar .. key_word_overseer,
      [2] = function()
        local tasks = require("overseer.task_list").list_tasks()
        if next(tasks) == nil then
          local msg = "No tasks have been run."
          vim.notify(msg)
          return
        end

        local cur_bufnr = vim.fn.bufnr()
        vim.cmd("OverseerOpen!")
        -- vim.cmd([[OverseerQuickAction open hsplit]])
        vim.cmd(
          string.format([[exe %d .. "wincmd w"]], vim.fn.bufwinnr(cur_bufnr))
        )
      end,
      desc = "overseer",
    },
      -- stylua: ignore start
      { [1] = prefix .. "a", [2] = "<cmd>OverseerTaskAction<CR>", desc = "actions" },
      { [1] = prefix .. "c", [2] = "<cmd>OverseerClearCache<CR>", desc = "clear-cache" },
    -- { [1] = prefix .. "i", [2] = "<cmd>OverseerInfo<CR>", desc = "info" },
    -- stylua: ignore end
  },
  opts = function()
    local ret = {
      -- strategy = {
      --   [1] = "jobstart",
      --   preserve_output = false,
      --   use_terminal = true,
      -- },
      -- strategy = "terminal",
      strategy = {
        [1] = "toggleterm",
        use_shell = false,
        direction = "float",
        open_on_start = true,
        close_on_exit = false,
        hidden = false,
      },

      templates = {
        "builtin",
      },
    }

    local paths = vim.fn.uniq(
      vim.fn.sort(
        vim.fn.globpath(
          vim.fn.stdpath("config"),
          "lua/overseer/template/user/*.lua",
          false,
          true
        )
      )
    )

    for _, file in pairs(paths) do
      table.insert(ret.templates, "user." .. file:match("[^/\\]+$"):sub(1, -5))
    end

    return ret
  end,

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
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function(_, opts)
        table.insert(
          opts.sections.lualine_b,
          { component = "overseer", priority = 60 }
        )
      end,
    },
  },
}

-- [2] = function()
--   local winnr = get_oversee_bufnr()
--   if winnr ~= nil then
--     vim.cmd(string.format([[exe %d .. "wincmd w"]], winnr))
--   end
--
--   vim.cmd("OverseerOpen")
-- end,
-- [2] = function()
--   local o_winnr = get_oversee_bufnr()
--   if o_winnr ~= nil then
--     -- close overseer window
--     vim.cmd("OverseerToggle")
--     -- vim.api.nvim_win_close(o_winnr, false)
--     return
--   end
--
--   local cur_bufnr = vim.fn.bufnr()
--   vim.cmd("OverseerOpen")
--   vim.cmd(
--     string.format([[exe %d .. "wincmd w"]], vim.fn.bufwinnr(cur_bufnr))
--   )
-- end,
