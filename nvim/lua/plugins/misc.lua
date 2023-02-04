return {
  -- run test
  { "vim-test/vim-test", lazy = true },

  -- TODO: consider replacing following with https://github.com/kylechui/nvim-surround  <2023-01-10, Hyunjae Kim>
  {
    "tpope/vim-surround",
    config = function()
      vim.api.nvim_create_autocmd({"FileType"}, {
        desc = "add `++` pattern to vim-surround",
        pattern = { "asciidoctor", "asciidoc" },
        callback = function ()
          vim.b.surround_43 = "`+\r+`"
        end,
      })
    end,
  },
  { "tpope/vim-repeat" },
  { "tpope/vim-fugitive" },

  -- TODO: make following to support *.kdl, *.toml <2023-02-04, Hyunjae Kim>
  { "ap/vim-css-color" }, -- preview color

  ------------------------------------------------------------------------------
  -- disabled
  ------------------------------------------------------------------------------
  {
    "junegunn/fzf.vim",
    lazy = false,
    enabled = false,
    cond = vim.fn.executable("fzf") == 1,
  },
  { "wfxr/minimap.vim", enabled = false },
  { "neoclide/jsonc.vim", lazy = true, enabled = false },
  { "vimwiki/vimwiki", lazy = true, enabled = false },
}
