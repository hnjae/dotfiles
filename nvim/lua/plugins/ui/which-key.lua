local prefix = require("val").prefix

---@type LazySpec
return {
  -- set keymap / show keymap
  [1] = "folke/which-key.nvim",
  lazy = true,
  enabled = true,
  event = "VeryLazy",
  version = "3.*",
  dependencies = {
    { [1] = "nvim-tree/nvim-web-devicons", optional = true },
  },
  ---@class wk.Opts
  opts = {
    preset = "modern",
    ---@type wk.Spec
    spec = {
      -- vim's builtin 인데 which-key.nvim 에 안뜨는 값
      -- stylua: ignore start
      { [1] = "g",  group = "extra-cmd" },
      { [1] = "z",  group = "extra-cmd" },
      { [1] = "zn", desc = "fold-none" },
      { [1] = "zN", desc = "fold-normal" },
      { [1] = "Z",  group = "quit" },
      { [1] = "['", desc = "prev-line-with-mark" },
      { [1] = "]'", desc = "next-line-with-mark" },
      { [1] = "[`", desc = "prev-mark" },
      { [1] = "]`", desc = "next-mark" },
      -- stylua: ignore end
      --
      { [1] = prefix.new .. "c", group = "current-buffer" },
      { [1] = prefix.new .. "e", group = "empty" },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- show which-key fast
    vim.o.timeoutlen = 500
    -- ※ timeoutlen 완료전에 타이핑을 못 끝냈을 경우, 아래의 코드가 있어야 작동된다.
    wk.add({
      {
        [1] = "<LocalLeader>",
        [2] = function()
          wk.show({ keys = "<LocalLeader>" })
        end,
        group = "LocalLeader",
      },
    })
  end,
}
