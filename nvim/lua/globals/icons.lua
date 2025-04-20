-- https://www.nerdfonts.com/
-- NOTE: 가능하면 `nf-md` variant 사용하기
-- `nf-oct` 랑 `nf-fa` 는 너무 크다.
return {
  -- in-use (after migrating to LazyVim)
  null = "󰟢 ", -- nf-md-null
  sort = "󱎅 ", -- nf-md-sort_bool_ascending
  ai = "󱙺 ", -- nf-md-robot_outline
  toggle = "󱨦 ", -- nf-md-toggle_switch_variant_off
  search = " ", -- nf-oct-search
  terminal = " ", -- nf-cod-terminal
  git = "󰊢 ", -- nf-md-git

  -------------------------------------------------------------------------------------------------
  -- directory = "", --nf-oct-file_directory
  -- file = "", --nf-oct-file
  directory = "",
  --
  signs = {
    -- codicons
    debug = "", -- nf-cod-debug
    trace = "", -- nf-cod-play_circle
    error = "", -- nf-cod-error
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
  code = "", -- nf-oct-code
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
  symbol = "", -- nf-oct-package
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
