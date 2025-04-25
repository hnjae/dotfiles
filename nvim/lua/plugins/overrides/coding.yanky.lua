---@type LazySpec
return {
  [1] = "yanky.nvim",
  optional = true,
  dependencies = { "snacks.nvim" }, -- to use yanky snacks picker
  keys = {
    {
      "<leader>p",
      function()
        Snacks.picker.yanky()
      end,
      mode = { "n", "x" },
      desc = "Open Yank History",
    },
  },
  opts = function()
    -- replace built'in `YankyRingHistory` command
    LazyVim.on_load("yanky.nvim", function()
      vim.defer_fn(function()
        vim.api.nvim_create_user_command("YankyRingHistory", function()
          Snacks.picker.yanky()
        end, {})
      end, 1)
    end)
  end,
  specs = {},
}
