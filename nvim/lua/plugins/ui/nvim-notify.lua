local val = require("val")

---@type LazySpec
return {
  -- alternative:  "vigoux/notifier.nvim",
  [1] = "rcarriga/nvim-notify",
  lazy = true,
  enabled = true,
  event = {
    "VeryLazy",
  },
  opts = {
    icons = {
      ERROR = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
      WARN = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
      INFO = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
    },
    -- fps = 60,
    top_down = false,
    -- render = "wrapped_compact",
    stages = "static",
    timeout = 2500,
    -- stages = "fade_in_fade_out",
  },
  main = "notify",
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
        desc = "noti-dismiss",
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
        require("messages.api").capture_thing(history)
      end,
      -- require("telescope").extensions.notify.notify,
      {}
    )
    -- replace default notify function
    vim.notify = notify
  end,
}
