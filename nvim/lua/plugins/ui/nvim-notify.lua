return {
  -- alternative:  "vigoux/notifier.nvim",
  [1] = "rcarriga/nvim-notify",
  lazy = true,
  enabled = true,
  event = "VimEnter",
  opts = {
    -- fps = 60,
    render = "compact",
    stages = "static",
    -- stages = "fade_in_fade_out",
  },
  keys = { { [1] = "z" .. "n", [2] = nil, desc = "noti-dismiss" } },
  config = function(plugin, opts)
    local notify = require("notify")
    notify.setup(opts)
    vim.notify = notify

    local rhsmap = {
      ["noti-dismiss"] = notify.dismiss,
    }

    for _, key in pairs(plugin.keys) do
      vim.keymap.set("n", key[1], rhsmap[key.desc], { desc = key.desc })
    end
  end,
}
