-- https://www.nerdfonts.com/
-- NOTE: 가능하면 `nf-md` variant 사용하기
-- `nf-oct` 랑 `nf-fa` 는 너무 크다.
return {
  -- in-use (after migrating to LazyVim)
  null = "󰟢 ", -- nf-md-null
  sort = "󱎅 ", -- nf-md-sort_bool_ascending
  ai = "󱙺 ", -- nf-md-robot_outline
  -- symbol = " ", -- nf-cod-symbol_misc
  symbol = "󰠱 ", -- nf-cod-symbol_misc

  toggle = "󱨦 ", -- nf-md-toggle_switch_variant_off
  toggle_on = "󱨥 ", -- nf-md

  search = "󰍉 ", -- nf-md
  filter = "󰈳 ", -- nf-md-filter

  -- terminal = " ", -- nf-cod-terminal
  terminal = "󰆍 ", -- nf-md
  cog = "󰢻 ",
  git = "󰊢 ", -- nf-md-git
  file = "󰈤 ", -- nf-md-file_outline
  directory = "󰉖 ", -- nf-md-folder_outline
  directory_open = "󰷏 ", -- nf-md-folder_outline
  code = "󰅴 ", -- nf-md
  -- code = " ", -- nf-cod-code

  -- search, pin, dir open
  -- nf-md:
  -- 󰅴 󰅲 󰘦 󰅪 󰅩 󱒓
  -- 󰍁 󰊡 󱁎 󱞏 󱍨 󱍨 󰕕 󱟺 󰄗 󱑎 󰳾 󰮍 󱏵 󱆧 󰋱 󱠬 󱌿 󱨈 󰿭 󰼀 󰋲 󰋱 󱉍 󱗍 󰄗 󱤉 󱈹 󰥚 󰆥 󰾰 󰥋 󰇗 󰇞 󱥌 󰇦 󰨊 󰿃 󰎐 󰆌 󰍍 󱋼 󰆢
  -- 󰇧 󰇥 󰟆 󰽉 󰈏 󱀥 󰈈 󰈲 󰠟 󰈷 󰉁 󰵲 󰂓 󱥒 󱢇 󱌢 󱌣 󰀼 󰂥 󱉟 󰧑 󰘘 󱜠 󱐕 󰃤 󰃭 󰨾 󰆊 󰆋 󰆙 󰇞 󰈀 󱁉 󰚇 󰀘 󱀅 󰮴 󰏘 󰟣 󰐃
  -- 󰂔 󰂖 󰧰 󱑪 󰽒 󱂕 󰟁 󱁖 󰿠 󱄕 󰤌 󰗐 󰼫 󰿇 󰍉 󰩊 󰭎 󰮬 󰠱 󰠲 󰒕
  -- 󰢻 󰒓 󱤴 󱓗 cog,  puzzle
  -- 󰑃 󰑄

  -------------------------------------------------------------------------------------------------
  --
  severity = { -- nf-md 󰮦 󰀪 󰋽 󰳧 󰳦 󰅝 󰏨 󰅜 󰀩 󰝧 󰀦  󰅙 󰅚 󰋗  󰗖
    error = "󰅚 ",
    warn = "󰀪 ",
    info = "󰋽 ",
    hint = " ",
    -- trace = "󰐍 ",
    -- debug = "󰃤 ",
  },
  signs = {

    -- codicons
    debug = "", -- nf-cod-debug
    trace = "", -- nf-cod-play_circle
    error = " ", -- nf-cod-error
    warn = "", -- nf-cod-warning
    info = "", -- nf-cod-info
    hint = "", -- nf-cod-question
    -- nf-seti & nf-fa
    -- error= "" , -- nf-seti-error
    -- warning = "" , -- nf-fa-warning
    -- info = "" , -- nf-fa-info_circle
    -- question = "" , -- nf-fa-question_circle
    code_action = "", -- nf-cod-lightbulb
  },
  codicons = {
    gear = "",
  },

  -- oct, md
  -- code = "󰅴", -- nf-md-code_tags

  extension = "", -- nf-oct-rocket
  workflow = "", --nf-oct-workflow
  message = "󰍡 ", -- nf-md-message
  zap = "⚡", --nf-oct-zap  (해치우다)
  -- 
  file_tree = "󰙅", -- nf-md-file_tree
  -- dashboard = "󰕮", -- nf-md-view_dashboard
  dashboard = "", -- nf-oct-home
  --
  lightbulb = "", -- nf-oct-light_bulb
  help = "󰘥", -- nf-md-help-circle-out-line

  -- insert_box = "󰑕", -- nf-md-rename-box
  textbox = "󰘎", -- nf-md-form_textbox
  tag = "", --nf-oct-tag

  tools = "", --nf-oct-tools

  check = "", --nf-oct-check
  checklist = "", -- nf-oct-checklist
  log = "", --nf-oct-log
  -- heart = "♥", --nf-oct-heart
  -- "", -- nf-oct-rows
  empty_set = "∅", -- unicode

  result = "", -- nf-oct-checklist
  menu = "󰍜", -- nf-md-menu

  --
}
