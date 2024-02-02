local treesitter_opts = {
  ensure_installed = {
    -- required by noice
    "vim",
    "regex",
    "lua",
    "bash",
    "query",
    "markdown",
    "markdown_inline",
    --
    "python",
    "java",
    "kotlin",
    "javascript",
    "typescript",
    "tsx",
    "rust",
    "ruby",
    "c",
    "cpp",
    "go",
    "zig",
    "nix",
    "sql",
    "regex",
    "luadoc",
    "luap", -- https://www.lua.org/pil/20.2.html
    --
    -- "graphql",
    -- --
    "fish",
    "dockerfile",
    -- "cmake",
    "requirements",
    "diff",
    "comment",
    -- data interchange format
    "json",
    -- "json5",
    "jsonc",
    -- "jsonnet",
    "yaml",
    "xml",
    "toml",
    "kdl",
    "ini",
    -- "rasi",
    --
    -- "rst",
    "html",
    "css",
    -- "cue",
    "ssh_config",
    "gitignore",
    "gitcommit",
    "git_config",
    "gitattributes",
    "git_rebase",
    "git_config",
    "gpg",
    "udev",
    --
    "http",
    "jq",
    --
    "latex",
    "bibtex",
    "gnuplot",
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
}

---@type LazySpec
return {
  [1] = "nvim-treesitter/nvim-treesitter",
  build = "<cmd>TSUpdate<CR>",
  lazy = false,
  event = { "VeryLazy" },
  -- event = { "BufReadPost", "BufNewFile" },
  opts = treesitter_opts,
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
  end,
}
