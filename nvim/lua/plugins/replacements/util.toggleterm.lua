--[[
NOTE:
  - Replace LazyVim's terminal implementation (snacks.nvim).
]]
local prefix_send = "<Leader>r"
local wk_icon = { icon = require("globals").icons.terminal, color = "red" }

local root_term = nil
local get_root_term = function()
  if root_term == nil then
    root_term = require("toggleterm.terminal").Terminal:new({
      direction = "horizontal",
      dir = LazyVim.root(),
    })
  end

  return root_term
end

local term_dir_map = {}
---@param cwd string
local get_cwd_term = function(cwd)
  if term_dir_map[cwd] == nil then
    term_dir_map[cwd] = require("toggleterm.terminal").Terminal:new({
      direction = "horizontal",
      dir = cwd,
    })
  end

  return term_dir_map[cwd]
end

---@type LazySpec
return {
  [1] = "akinsho/toggleterm.nvim",
  version = "*",
  lazy = true,
  cond = not vim.g.vscode and os.getenv("NVIM") == nil, -- toggleterm 안의 nvim 안의 toggerterm 금지.
  dependencies = {
    -- to override snacks's terminal mapping
    { [1] = "folke/snacks.nvim", optional = true },
  },
  cmd = {
    "ToggleTerm",
    "ToggleTermToggleAll",
    "TermExec",
    "TermSelect",
    "ToggleTermSendCurrentLine",
    "ToggleTermSendVisualLines",
    "ToggleTermSendVisualSelection",
    -- 'ToggleTermSetName',
  },
  -- stylua: ignore
  keys = {
    { [1] = prefix_send .. "l", mode = { "n" }, [2] = "<cmd>ToggleTermSendCurrentLine<CR>",                       desc = "send-line" },
    { [1] = prefix_send .. "b", mode = { "n" }, [2] = "<C-\\><C-n>ggVG:<C-u>'<,'>ToggleTermSendVisualLines<CR>",  desc = "send-buffer" },
    { [1] = prefix_send .. "l", mode = { "x" }, [2] = ":<C-u>'<,'>ToggleTermSendVisualLines<CR>",                 desc = "send-visual-lines" },
    { [1] = prefix_send .. "s", mode = { "x" }, [2] = ":<C-u>'<,'>ToggleTermSendVisualSelection<CR>",             desc = "send-visual-selection" },

    --[[
      NOTE:
        - In LazyVim, when the Terminal has focus and is in normal mode, it spawns a new terminal. Otherwise, it toggles the terminal. (v14.14.0; 2025-04-09)
          - (When the terminal is focused and in terminal mode, it toggles terminal instead of spawning a new terminal.)
        - The distinction between toggling and spawning seems odd, which makes we think this might not be the implementation the LazyVim developer intended.
        - We configured it to always toggle using toggleterm.

        - `<C-/>` and `<Leader>ft` share same terminal in LazyVim.
    --]]
    -- override LazyVim's terminal
    { [1] = "<C-/>", [2] = function () get_root_term():toggle(nil, "float") end, desc = "Terminal (ToggleTerm)" },
    { [1] = "<Leader>ft", [2] = function () get_root_term():toggle(nil, "horizontal") end, desc = "Terminal (ToggleTerm)" },
    { [1] = "<Leader>fT", [2] = function () get_cwd_term(vim.fn.expand('%:h')):toggle(nil, "horizontal") end, desc = "Spawn Terminal in buffer's cwd" },
  },
  opts = {
    shell = os.getenv("SHELL") or vim.o.shell,
    direction = "float",

    shade_terminals = false, -- NOTE: horizontal terminal 에 경우 shading_terminal 값이 무시되는 버그가 있는 것 같다. <2025-04-07>
    shading_factor = 0,
    shading_ratio = 0,

    insert_mappings = false,
    terminal_mappings = false,

    float_opts = {
      border = "rounded",
      width = function()
        local max = 126
        if vim.o.columns >= max then
          return max
        end

        return vim.o.columns
      end,
      height = function()
        local max = 36
        if vim.o.lines - 3 >= max then
          return max
        end

        return vim.o.lines - 3
      end,
    },
  },
  specs = {
    {
      [1] = "which-key.nvim",
      optional = true,
      opts = {
        icons = {
          rules = {
            { plugin = "toggleterm.nvim", icon = wk_icon.icon, color = wk_icon.color },
          },
        },
        spec = {
          { [1] = prefix_send, group = "terminal-send", mode = { "n", "x" }, icon = wk_icon },
        },
      },
    },
  },
}
