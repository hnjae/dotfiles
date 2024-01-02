local val = require("val")

return {
  -- alternative:  "vigoux/notifier.nvim",
  [1] = "rcarriga/nvim-notify",
  lazy = true,
  enabled = true,
  event = {
    "VeryLazy",
  },
  opts = {
    -- fps = 60,
    render = "compact",
    stages = "static",
    -- stages = "fade_in_fade_out",
  },
  main = "notify",
  keys = function(plugin)
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

    -- replace default notify function
    vim.notify = notify
  end,
}
