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

-- on_attach function for lspconfig and null-ls
M.on_attach = function(client, bufnr)
  local buf_format_deny_list = {
    tsserver = true,
  }
  local buf_format_filter = function(client_)
    return not buf_format_deny_list[client_.name]
  end

  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  if client.supports_method("textDocument/formatting") and not buf_format_deny_list[client.name] then
    vim.keymap.set("n", "==", function()
      vim.lsp.buf.format({
        async = true,
        filter = buf_format_filter,
      })
    end, { desc = "lsp-format", buffer = bufnr })

    vim.keymap.set("v", "==", function()
      vim.lsp.buf.format({
        async = true,
        range = {
          ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
          ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
        },
        filter = buf_format_filter,
      })
    end, { desc = "lsp-buf-format", buffer = bufnr })

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr, filter = buf_format_filter })
      end,
    })
  end
end

return M
