-- https://github.com/AckslD/messages.nvim

---@type LazySpec
return {
  [1] = "AckslD/messages.nvim",
  lazy = true,
  cmd = {
    "Messages",
  },
  opts = {},
  config = function(_, opts)
    require("messages").setup(opts)

    -- Msg = function(...)
    --   require("messages.api").capture_thing(...)
    -- end
  end,
}
