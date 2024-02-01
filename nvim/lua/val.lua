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

  -- 위와 미교하게 focus 가 다름
  focus = "f",

  -- 아래는 위와 같은 scope 에서 쓰이지 않을걸로 기대됨.
  -- 특정 키워드를 찾거나 하는데 사용되길 기대.
  marks = "m",
  line = "e",
  lsp = "l",
  symbols = "y",
  snippet = "p",
  tag = "g",

  --
  tab = "t",
  current = "e",
  vsplit = "v",
  split = "s",
}

-- this prefix will be registered by which.key
M.prefix = {
  -- NOTE(buffer): filetype 에 따라 달라지거나, buffer 와 interact 하는 기능 할당.
  buffer = "s",
  lang = "s",
  toggleterm_send = "s" .. M.map_keyword.terminal,
  buffer_finder = "s" .. M.map_keyword.finder,
  sniprun = "sr",
  task = "st",
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

  open = "<F6>",
}

M.root_patterns = {
  ".git",
  ".editorconfig",
  "flake.nix",
  ".neoconf.json",
  ".nlsp-settings",
  ".envrc",
  ".gitignore",
}

---@type fun(client: table, bufnr: integer): nil
-- on_attach function for lspconfig and null-ls
M.on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

return M
