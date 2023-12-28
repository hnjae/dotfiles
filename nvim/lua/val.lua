local M = {}

-- this prefix will be registered by which.key
M.prefix = {
  lang = "s",
  close = "Z",

  finder = "<Leader>f",
  sniprun = "<Leader>r",
  focus = "<Leader>f",
  repl = "<Leader>r",
  sidebar = "<Leader>b",

  ["toggleterm-send"] = "<Leader>t",

  tab = "<Leader>nt",
  -- window = "<Leader>nw",
  edit = "<Leader>ne",
  vsplit = "<Leader>nv",
  split = "<Leader>ns",

  open = "<F6>",
}

M.map_keyword = {
  terminal = "t",
  explorer = "e",

  marks = "m",
  line = "e",
  lsp = "l",
  symbols = "s",
  snippet = "p",
}

-- TODO: root_patterns을 각 언어별로 구분해서 선언할 것 <2023-05-18>
-- null-ls 가 잘 지원하는지 모르겠다.
M.root_patterns = {
  ".git",
  ".editorconfig",
  "flake.nix",
  ".neoconf.json",
  ".nlsp-settings",
  ".envrc",
}

M.root_patterns2 = {
  python = {
    "pyproject.toml",
  },
  lua = {
    "selene.toml",
    "stylua.toml",
  },
  typescript = {
    "tsconfig.json",
  },
  ["_"] = {
    ".nlsp-settings",
    ".neoconf.json",
    ".editorconfig",
    -- ".envrc",
    ".git",
  },
}

-- TODO: implement following <2023-12-28>
--[[
  1. client.supports_method("textDocument/formatting") 를 이용해서 formatting 을 지원할 경우에만 keymap 설정
  2. BufWritePre 이벤트를 활용해서, 1의 상황에서는 buf.format을 실행할 것.

  다음 코드 스니펫을 활용할 수 있다: https://github.com/NvChad/NvChad/issues/2016#issuecomment-1545289371

  ```lua
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end,
		})
  ```
]]

-- on_attach function for lspconfig and null-ls
M.on_attach = function(_, bufnr)
  local buf_format_deny_list = {
    tsserver = true,
  }

  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  vim.keymap.set("n", "==", function()
    vim.lsp.buf.format({
      async = true,
      filter = function(client)
        return not buf_format_deny_list[client.name]
      end,
    })
  end, { desc = "lsp-format", buffer = bufnr })

  vim.keymap.set("v", "==", function()
    vim.lsp.buf.format({
      async = true,
      range = {
        ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
        ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
      },
      filter = function(client)
        return not buf_format_deny_list[client.name]
      end,
    })
  end, { desc = "lsp-buf-format", buffer = bufnr })
end

return M
