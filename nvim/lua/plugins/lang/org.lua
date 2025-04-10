-- TODO: map preview at <leader>cp <2025-04-10>
---@type LazySpec[]
return {
  {
    [1] = "nvim-orgmode/orgmode",
    version = "*",

    lazy = true,
    -- event = "VeryLazy",
    ft = { "org" },
    cmd = { "Org" },
    opts = {
      org_agenda_files = "~/Documents/orgfiles/**/*",
      org_default_notes_file = "~/Documents/orgfiles/refile.org",
      org_startup_folded = "inherit", -- follow neovim's global `foldlevel` option
    },
  },
  {
    [1] = "nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      -- NOTE: asciidoc 와는 다르게 ignore_install 에 넣어야 한다. 충돌남. <2025-04-09>
      opts.ignore_install = opts.ignore_install or {}
      table.insert(opts.ignore_install, "org")

      LazyVim.on_load("nvim-treesitter", function()
        -- NOTE: `TSInstall org` 하면 충돌 나고, 아래 설정만 해도 treesitter 가 있다고 인식됨. <2025-04-09>
        require("nvim-treesitter.parsers").get_parser_configs().org = {
          install_info = {
            url = "https://github.com/milisims/tree-sitter-org",
            revision = "main",
            files = { "src/parser.c", "src/scanner.c" },
          },
          filetype = "org",
        }
      end)
    end,
  },
}
