---@type LazySpec
return {
  [1] = "nvim-treesitter/nvim-treesitter",
  build = "<cmd>TSUpdateSync<CR>",
  lazy = false,
  enabled = require("utils").is_treesitter,
  event = { "VeryLazy" },
  -- event = { "BufReadPost", "BufNewFile" },
  opts = {
    -- ensure_installed = "all",
    ensure_installed = {
      -- required by noice
      "vim",
      "regex",
      "bash",
      "query",
      "markdown",
      "markdown_inline",
      --
      "gitignore",
      "gitcommit",
      "git_config",
      "gitattributes",
      "git_rebase",
      "git_config",
      --
      "vimdoc",
      "diff",
      "comment",
      "dot",
      "regex",
      "requirements",
      --
      "lua",
      "elixir",
      "luadoc",
      "luap", -- https://www.lua.org/pil/20.2.html
      "luau",
      --
      "awk",
      "jq",
      --
      "latex",
      "bibtex",
      "gnuplot",
      --
      "tsx",
      "typescript",
      "javascript",
      "html",
      "css",
      "http",
      --
      "java",
      "kotlin",
      "clojure",
      --
      "dockerfile",
      --
      "cmake",
      "make",
      "c",
      "cpp",
      --
      "nix",
      "python",
      "rust",
      "zig",
      "go",
      "sql",
      --
      "kdl",
      "ini",
      "xml",
      "toml",
      "json",
      "json5",
      "jsonc",
      "jsonnet",
      "rasi",
      "yaml",
      --
      "ssh_config",
      "gpg",
      "udev",
    },
    sync_install = true,
    auto_install = true,
    ignore_install = {},
    highlight = {
      enable = true,
      disable = {},
      additional_vim_regex_highlighting = false,
      -- disable = function(lang, buf)
      --   vim.notify(lang)
      --   local max_filesize = 100 * 1024 -- 100 KB
      --   local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      --   if ok and stats and stats.size > max_filesize then
      --     return true
      --   end
      -- end,
    },
    indent = {
      enable = true, -- NOTE: experimental features <2023-11-23>
    },
    incremental_selection = {
      enale = false,
    },
  },
  main = "nvim-treesitter.configs",
  config = function(plugin, opts)
    require(plugin.main).setup(opts)

    local del_commands = {
      "TSEditQuery",
      "TSEditQueryUserAfter",
    }
    for _, command in ipairs(del_commands) do
      vim.api.nvim_del_user_command(command)
    end

    require("nvim-treesitter.parsers").get_parser_configs()["just"] = {
      install_info = {
        url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
        files = { "src/parser.c", "src/scanner.c" },
        branch = "main",
        -- use_makefile = true -- this may be necessary on MacOS (try if you see compiler errors)
      },
      maintainers = { "@IndianBoy42" },
    }

    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  end,
}
