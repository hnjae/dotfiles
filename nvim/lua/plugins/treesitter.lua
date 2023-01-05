-- treesitter
local treesitter_config = function()
  local treesitter_config = {
    ensure_installed = {
      "c",
      "cmake",
      "rust",
      "java",
      "kotlin",
      "lua",
      "python",
      "go",
      "bash",
      "fish",
      "yaml",
      "toml",
      "json",
      "jsonc",
      "json5",
      "html",
      "markdown",
      "latex",
      "bibtex",
      "dockerfile",
      "regex",
      "vim"
    },
    highlights = {
      enable = true,
    },
  }

  -- if _IS_PLUGIN("nvim-ts-rainbow") then
  --   vim.cmd([[
  --   let _fg_color = synIDattr(synIDtrans(hlID('StatusLine')), 'fg')
  --   exec "hi rainbowcol1 guifg=" . _fg_color
  --   unlet _fg_color
  --   ]])
  --   local rainbow_config = {
  --       enable = true,
  --       -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
  --       extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
  --       max_file_lines = nil, -- Do not enable for files with more than n lines, int
  --       -- colors = {}, -- table of hex strings
  --       -- colors =  { "#ffffff" },
  --       -- termcolors = {} -- table of colour name strings
  --   }
  --   treesitter_config["rainbow"] = rainbow_config
  --   -- table.insert(treesitter_config, rainbow_config)
  -- end


  -- local status_orgmode, orgmode = pcall(require, "orgmode")
  -- if status_orgmode then
  --   orgmode.setup_ts_grammar()
  --   treesitter_config["highlights"]["additional_vim_regex_highlighting"] = {"org"}
  --   -- table.insert(treesitter_config["ensure_installed"], "org")
  -- end

  require("nvim-treesitter.configs").setup(treesitter_config)
end
return {
  -- {
  --   'p00f/nvim-ts-rainbow',
  --   dependenceis = { 'nvim-treesitter/nvim-treesitter' }
  -- },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependenceis = { 'nvim-treesitter/nvim-treesitter' }
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = treesitter_config
  },
}
