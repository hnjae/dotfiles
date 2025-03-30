local val = require("val")

---@type LazySpec
return {
  -- alternative:  "vigoux/notifier.nvim",
  [1] = "rcarriga/nvim-notify",
  lazy = true,
  enabled = true,
  cond = not vim.g.vscode,

  event = {
    "VeryLazy",
  },
  opts = function()
    local e = require("utils").enable_icon
    local icons = require("val").icons.signs

    local ret = {
      icons = {
        EROOR = e and icons.error or "E",
        WARN = e and icons.warn or "W",
        INFO = e and icons.info or "I",
        TRACE = e and val.icons.signs.trace or "T",
        DEBUG = e and val.icons.signs.debug or "D",
      },
      level = vim.log.levels.DEBUG,
      top_down = true,
      stages = "static",
      timeout = 2000,
    }

    -- if vim.fn.hlexists("NotifyBackground") == 1 then
    --   ret.background_colour = "NotifyBackground"
    -- end

    return ret
  end,
  main = "notify",
  -- use :messages or :Noice to see messages
  cmd = {
    "Notifications",
  },
  ---@type fun(plugin: LazyPluginSpec): LazyKeysSpec[]
  keys = function(plugin)
    ---@type LazyKeysSpec[]
    local ret = {
      -- NOTE:  여기서 require 를 작성한다고 해서, 자동으로 Load 되는 것이 아님
      -- <2024-01-02>
      {
        [1] = val.prefix.close .. "n",
        [2] = require(plugin.main).dismiss,
        desc = "notification-dismiss",
      },
    }

    return ret
  end,
  config = function(plugin, opts)
    local notify = require(plugin.main)
    notify.setup(opts)

    -- override default Notifications
    vim.api.nvim_create_user_command(
      "Notifications",
      function()
        local history = require(plugin.main).history()
        require("messages.api").capture_thing(
          -- vim.inspect(history[#history].message)
          history[#history].message
        )
      end,
      -- require("telescope").extensions.notify.notify,
      {}
    )

    -- replace default notify function
    if not require("utils").is_plugin("noice.nvim") then
      -- NOTE: notify.async occur 'attempt to yield across C-call boundary' error after update 2024-12-08
      -- vim.notify = notify.async
      vim.notify = notify.notify
    end
  end,
  ---@type LazySpec[]
  specs = {
    {
      [1] = "nvim-telescope/telescope.nvim",
      optional = true,
      ---@type fun(LazyPlugin, keys: LazyKeysSpec[]): nil
      keys = function(_, keys)
        local prefix = require("val").prefix

        local key = {
          [1] = prefix.find .. "hn",
          [2] = require("telescope").extensions.notify.notify,
          desc = "notify-history",
        }
        table.insert(keys, key)
      end,
    },
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function()
        local icons = require("val").icons
        require("state.lualine-ft-data"):add({
          notify = { display_name = "Notify", icon = icons.message },
        })
      end,
    },
  },
}
