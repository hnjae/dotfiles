local val = require("val")
local prefix = val.prefix

---@type LazySpec
return {
  -- set keymap / show keymap
  [1] = "folke/which-key.nvim",
  lazy = true,
  enabled = true,
  cond = not vim.g.vscode,
  event = "VeryLazy",
  version = "v3.*",
  dependencies = {
    { [1] = "nvim-tree/nvim-web-devicons", optional = true },
    -- { [1] = "echasnovski/mini.icons" },
  },
  ---@class wk.Opts
  opts = function(_, opts)
    -- opts = vim.tbl_deep_extend("keep", {
    --   preset = "modern",
    --   spec = {},
    --   icons = {
    --     rules = {},
    --   },
    -- }, opts or {})

    opts.preset = "modern"

    if opts.spec == nil then
      opts.spec = {}
    end
    vim.list_extend(opts.spec, {
      -- vim's builtin 인데 which-key.nvim 에 안뜨는 값
      { [1] = "g", group = "g (extra-cmd)" },
      { [1] = "gd", group = "goto-local-declaration" },
      { [1] = "gD", group = "goto-global-declaration" },
      { [1] = "z", group = "z (extra-cmd)" },
      { [1] = "zn", desc = "fold-none" },
      { [1] = "zN", desc = "fold-normal" },
      { [1] = "Z", group = "quit" },
      { [1] = "['", desc = "prev-line-with-mark" },
      { [1] = "]'", desc = "next-line-with-mark" },
      { [1] = "[`", desc = "prev-mark" },
      { [1] = "]`", desc = "next-mark" },
      --
      -- 내 맵핑 그룹
      { [1] = prefix.new .. "c", group = "current-buffer" },
      { [1] = prefix.new .. "e", group = "empty-buffer" },
      --
      {
        [1] = "<Leader>?",
        [2] = function()
          require("which-key").show({ global = true })
        end,
        desc = "show-global-keymaps",
        icon = {
          icon = val.icons.help,
          color = "red",
        },
      },
      {
        [1] = "<LocalLeader>?",
        [2] = function()
          require("which-key").show({ keys = "<LocalLeader>", global = true })
        end,
        desc = "show-buffer-local-keymaps",
        icon = {
          icon = val.icons.help,
          color = "red",
        },
      },
    })

    if opts.icons == nil then
      opts.icons = {}
    end
    if opts.icons.rules == nil then
      opts.icons.rules = {}
    end
    local icons = val.icons

    vim.list_extend(opts.icons.rules, {
      -- replace defaults
      { pattern = "buffer", icon = icons.file, color = "cyan" },
      { pattern = "file", icon = icons.file, color = "cyan" },
      { pattern = "find", icon = icons.search, color = "green" },
      { pattern = "search", icon = icons.search, color = "green" },
      { pattern = "toggle", icon = icons.toggle, color = "yellow" },
      { pattern = "diagnostic", icon = icons.checklist, color = "green" },
      { pattern = "code", icon = icons.code, color = "orange" },
      { pattern = "terminal", icon = icons.terminal, color = "red" },

      -- add generic
      { pattern = "help", icon = icons.help, color = "red" },
      { pattern = "fold", icon = "", color = "grey" }, -- nf-oct-fold
      { pattern = "prev", icon = "󰼨", color = "grey" }, -- nf-md-skip_previous_outline
      { pattern = "next", icon = "󰼧", color = "grey" }, -- nf-md-skip_next_outline
      { pattern = "history", icon = "󰋚", color = "grey" }, -- nf-md-history
      { pattern = "task", icon = "", color = "grey" }, -- nf-oct-tasklist
      { pattern = "run", icon = "󰜎", color = "red" }, -- nf-md-run
      { pattern = "execute", icon = "󰜎", color = "red" }, -- nf-md-run
      { pattern = "git", icon = icons.git, color = "orange" },
      { pattern = "new", icon = "󰏌", color = "grey" }, -- nf-md-open_in_new
      { pattern = "edit", icon = "", color = "grey" }, -- nf-fa-edit
      { pattern = "vsplit", icon = "", color = "grey" }, -- nf-cod-split_horizontal
      { pattern = "split", icon = "", color = "grey" }, -- nf-cod-split_vertical
      { pattern = "float", icon = "", color = "grey" }, -- nf-cod-multiple_windows
      --
      { pattern = "peek", icon = "󱀃", color = "grey" }, -- nf-md-newspaper_variant_multiple_outline
      { pattern = "sidebar", icon = "", color = "grey" }, -- nf-cod-layout_sidebar_right_off
      -- { pattern = "focus", icon = "󰽏", color = "grey" }, -- nf-md-focus_field
      { pattern = "cmdline", icon = "", color = "grey" }, -- nf-oct-command_palette
      {
        pattern = "notification",
        icon = require("val").message,
        color = "blue",
      },
    })
  end,
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- ※ vim.o.timeoutlen 완료전에 타이핑을 못 끝냈을 경우, 아래의 코드가 있어야 작동된다.
    -- wk.add({
    --   {
    --     [1] = "<LocalLeader>",
    --     [2] = function()
    --       wk.show({ keys = "<LocalLeader>" })
    --     end,
    --     group = "LocalLeader",
    --     -- mode = { "n", "x", "s", "o" },
    --     mode = { "n", "x" },
    --   },
    -- })

    -- update group
    local add = {}
    for desc, lhs in pairs(prefix) do
      table.insert(add, { [1] = lhs, group = desc })
    end
    wk.add(add)
  end,
}
