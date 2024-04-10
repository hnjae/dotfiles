local icons = require("val").icons
-- local is_devicons, devicons = pcall(require, "nvim-web-devicons")

-- 일반적인 filetype 이면 devicons 설정에 추가.
return {
  -- {{{  normal
  checkhealth = { "CheckHealth", "󰗶" }, -- nf-md-heart_pulse
  netrw = { "Netrw", icons.directory },
  help = { [2] = icons.help },
  oil = { "Oil", icons.directory },
  alpha = { "Alpha", icons.dashboard },
  dashboard = { "Dashboard", icons.dashboard },
  toggleterm = { "ToggleTerm" },
  fugitive = { "Fugitive", icons.git },
  ["leetcode.nvim"] = { "LeetCode", "" }, -- nf-oct-code_review
  -- }}}
  ------------------------------------------------------------------------------
  -- {{{ floating
  lazy = { "Lazy", "󰒲" }, -- nf-md-sleep
  TelescopePrompt = { "Telescope", icons.search },
  OverseerForm = { [2] = icons.workflow },
  ["chatgpt-input"] = { "ChatGPT Input", icons.textbox },
  -- }}}
  ------------------------------------------------------------------------------
  -- {{{ popup
  sagafinder = { "SagaFinder", icons.search },
  saga_codeaction = { "Saga CodeAction", icons.lightbulb },
  sagarename = { "SagaRename", icons.textbox },
  ["neo-tree-popup"] = { "NeoTree Popup", icons.zap },
  notify = { "Notify", icons.message }, -- nf-md-traffic_light
  snippet_converter = { "Snippet Converter", icons.zap },
  -- }}}
  ------------------------------------------------------------------------------
  -- {{{ sidebar
  qf = { "QuickFix", icons.tools },
  trouble = { "Trouble", icons.tools },
  tagbar = { "Tagbar", icons.tag },
  Outline = { "Outline", icons.symbol },
  NvimTree = { "NvimTree", icons.file_tree },
  ["neo-tree"] = { "NeoTree", icons.file_tree },
  sagaoutline = { "SagaOutline", icons.symbol },
  OverseerList = { [1] = "OverseerList", [2] = "󰝖" }, -- nf-md-format_list_checks
  dbui = { [2] = "" }, -- nf-oct-database
  dbout = { [2] = "" }, -- nf-oct-database
  -- }}}
  -- {{{ misc
  -- notification 창도 있고 sidebar 도 있고 그럼
  noice = { "Noice", icons.message },
  -- }}}
}
-- NeogitStatus = %icons.git,
-- NeogitPopUp = icons.message,
