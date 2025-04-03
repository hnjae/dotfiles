---@type LazySpec
return {
  [1] = "nvim-orgmode/orgmode",
  event = "VeryLazy",
  ft = { "org" },
  config = function()
    -- Setup orgmode
    require("orgmode").setup({
      org_agenda_files = "~/orgfiles/**/*",
      org_default_notes_file = "~/orgfiles/refile.org",
    })

    -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
    -- add ~org~ to ignore_install
    -- require('nvim-treesitter.configs').setup({
    --   ensure_installed = 'all',
    --   ignore_install = { 'org' },
    -- })
  end,

  specs = {
    {
      [1] = "nvim-treesitter/nvim-treesitter",
      optional = true,
      opts = function(plugin, opts)
        opts.ignore_install = opts.ignore_install or {}
        table.insert(opts.ignore_install, "org")

        --
        require("utils.plugin").on_load(plugin.main, function()
          local parser_config =
            require("nvim-treesitter.parsers").get_parser_configs()

          parser_config.org = {
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
  },
}
