-- https://code.visualstudio.com/Docs/editor/tasks

-- local package_path = (...) -- "plugins.feature.overseer"
local package_path = "plugins.feature.overseer"

local val = require("val")
local prefix = val.prefix.task
local key_word_overseer = prefix:sub(-1, -1)
local map_keyword = require("val").map_keyword

-- or
-- "jedrzejboczar/toggletasks.nvim",

---@return number|nil
-- local function get_oversee_bufnr()
--   local len_winnr = vim.fn.winnr("$")
--
--   local bufnr, filetype
--   for winnr = 0, (len_winnr - 1) do
--     bufnr = vim.fn.winbufnr(winnr)
--     filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
--     if filetype == "OverseerList" then
--       return winnr
--     end
--   end
--
--   return nil
-- end

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
        {
          [1] = prefix .. "z",
          [2] = "<cmd>Telescope commands<CR>overseer ",
          desc = "list",
        },
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
        vim.cmd("OverseerOpen!")

        local tasks = require("overseer.task_list").list_tasks()
        if next(tasks) == nil then
          vim.cmd("OverseerRun")
        else
          vim.cmd([[OverseerQuickAction restart]])
        end
      end,
      -- "<cmd>OverseerQuickAction restart<CR>",
      desc = "run-or-restart",
    },
    {
      [1] = prefix .. "o",
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
    {
      [1] = require("val").prefix.sidebar .. key_word_overseer,
      [2] = "<cmd>OverseerToggle!<CR>",
      desc = "overseer",
    },
    {
      [1] = require("val").prefix.sidebar .. key_word_overseer:upper(),
      [2] = "<cmd>OverseerOpen<CR>",
      desc = "overseer-focus",
    },
      -- stylua: ignore start
      { [1] = prefix .. "a", [2] = "<cmd>OverseerTaskAction<CR>", desc = "actions" },
      { [1] = prefix .. "c", [2] = "<cmd>OverseerClearCache<CR>", desc = "clear-cache" },
    -- { [1] = prefix .. "i", [2] = "<cmd>OverseerInfo<CR>", desc = "info" },
    -- stylua: ignore end
  },
  opts = function()
    local ret = {
      strategy = {
        [1] = "jobstart",
        preserve_output = false,
        use_terminal = true,
      },

      -- strategy = { [1] = "terminal" },

      -- strategy = {
      --   [1] = "toggleterm",
      --   use_shell = false,
      --   direction = "float",
      --   open_on_start = true,
      --   close_on_exit = false,
      --   hidden = true, -- can not be toggled with normal ToggleTerm commands
      -- },

      templates = {
        "builtin",
      },
    }

    return ret
  end,

  config = function(_, opts)
    local overseer = require("overseer")
    overseer.setup(opts)

    local templates =
      require("utils").get_packages(package_path .. ".templates")
    for _, template in ipairs(templates) do
      overseer.register_template(template)
    end

    vim.api.nvim_create_user_command("WatchRun", function()
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

        local icons = require("val").icons
        require("state.lualine-ft-data"):add({
          OverseerForm = {
            display_name = "Overseer Form",
            icon = icons.workflow,
          },
          OverseerList = { display_name = "Overseer List", icon = "󰝖" }, -- nf-md-format_list_checks
        })
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
