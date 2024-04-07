local M = {}

-- Type Effort (colemak-dh):
-- 1.0 tn
-- 1.1 se
-- 1.3 ri
-- 1.6 ~ 1.8 aodh
-- 2.0 ~ 2.2 yflvk
-- 2.3 ~ 2.4 bycu,
-- 2.5~ 2.7 wbx.
-- 2.9 gm
-- 3.0 + l
-- 3+ bq;/j

-- 설정 전역e서 각종 키워드

-- 설정 전역에서 각종 키워드 통일 위해 사용.
---@type table<string, string>
M.map_keyword = {
  -- 보통 특정 목적의 윈도우를 여는 식의 작업에 사용되길 기대.
  trouble = "x",
  filemanager = "m",
  finder = "e", -- e.g. telescope
  window = "w",
  terminal = "i",
  git = "g",

  --
  execute = "x",

  -- 위와 미교하게 focus 가 다름
  focus = "F", -- deprecated 2024-02-19
  focus_picker = "f", -- focus window using s1n7ax/nvim-window-picker

  -- 아래는 위와 같은 scope 에서 쓰이지 않을걸로 기대됨.
  -- 특정 키워드를 찾거나 하는데 사용되길 기대.
  marks = "m",
  line = "e",
  lsp = "l",
  symbols = "y",
  snippet = "p",
  tag = "g",
  task = "t",

  --
  current = "e",
  tab = "t",
  vsplit = "v",
  split = "s",
  float = "f",
}

-- this prefix will be registered by which.key
M.prefix = {
  -- NOTE(buffer): filetype 에 따라 달라지거나, buffer 와 interact 하는 기능 할당.
  buffer = "s",
  toggleterm_send = "s" .. M.map_keyword.terminal,
  buffer_finder = "s" .. M.map_keyword.finder,
  sniprun = "sr",
  task = "s" .. M.map_keyword.task,
  repl = "sp",

  -- NOTE(close): 무언가를 닫거나, clear 하는 기능을 할당.
  close = "Z",

  -- NOTE(<Leader>): filetype 와 무관한 기능 할당
  finder = "<Leader>" .. M.map_keyword.finder,
  focus = "<Leader>" .. M.map_keyword.focus,
  sidebar = "<Leader>b",
  trouble = "<Leader>" .. M.map_keyword.trouble,
  window = "<Leader>" .. M.map_keyword.window,
  git = "<Leader>" .. M.map_keyword.git,
  new = "<Leader>n",
  snippet = "<Leader>" .. M.map_keyword.snippet,

  open = "<F6>",
}

M.root_patterns = {
  ".git",
  ".editorconfig",
  "flake.nix",
  ".neoconf.json",
  ".nlsp-settings",
  -- ".envrc",
  ".gitignore",
}

---@type fun(client: table, bufnr: integer): nil
-- on_attach function for lspconfig and null-ls
M.on_attach = function(client, bufnr)
  -- if client.config.name ~= "null-ls" then
  --   -- require("messages.api").capture_thing(client.supports_method())
  --   require("messages.api").capture_thing(client)
  -- end
  --
  -- -- prefix.buffer .. map_keyword.lsp
  -- local capabilities = client.config.server_capabilities
  -- local prefix = M.prefix.buffer .. M.map_keyword.lsp
  -- for _, map in ipairs({ { "a", "code-action", "codeActionProvider" } }) do
  --   if capabilities[map[3]] then
  --     vim.keymap.set(
  --       "n",
  --       prefix .. map[1],
  --       vim.lsp.buf.code_action,
  --       { buffer = bufnr, desc = "lsp-" .. map[2] }
  --     )
  --   end
  -- end

  -- vim.notify(vim.inspect(client))
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  require("val.lsp-keymap-setup")()
end

M.icons = {
  directory = "", --nf-oct-file_directory
  file = "", --nf-oct-file
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

  -- oct, md
  extension = "", -- nf-oct-rocket
  workflow = "", --nf-oct-workflow
  message = "󰍡", -- nf-md-message
  zap = "⚡", --nf-oct-zap  (해치우다)
  -- 
  git = "", -- nf-oct-git_branch
  file_tree = "󰙅", -- nf-md-file_tree
  -- dashboard = "󰕮", -- nf-md-view_dashboard
  dashboard = "", -- nf-oct-home
  --
  lightbulb = "", -- nf-oct-light_bulb
  search = "", -- nf-oct-serch
  help = "󰘥", -- nf-md-help-circle-out-line

  -- insert_box = "󰑕", -- nf-md-rename-box
  textbox = "󰘎", -- nf-md-form_textbox
  symbol = "", -- nf-oct-package
  tag = "", --nf-oct-tag

  tools = "", --nf-oct-tools

  check = "", --nf-oct-check
  log = "", --nf-oct-log
  -- heart = "♥", --nf-oct-heart
  -- "", -- nf-oct-rows
  -- "", -- nf-oct-checklist
}

return M
