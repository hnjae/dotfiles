-- telescope

local telescope_config =  function()
  local telescope = require("telescope")

  local config = {
    defaults = {
      -- vimgrep_arguments = {
      --   "rg",
      --   "--color=never",
      --   "--no-heading",
      --   "--with-filename",
      --   "--line-number",
      --   "--column",
      --   "--smart-case",
      --   "--trim" -- add this value
      -- }
      -- theme = "dropdown"
    },
    pickers = {
      -- TODO: buffers doesn't show its content  <2022-06-16, Hyunjae Kim>
      -- buffers = {
      --   theme ="dropdown"
      -- },
      -- TODO: use vim.fn.executable to find fd
      find_files = {
        find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
      }
    },
    -- TODO: Not working <2022-06-16, Hyunjae Kim>
    -- builtin.current_buffer_fuzzy_find({opts}) *telescope.builtin.current_buffer_fuzzy_find()*
    extensions = {
      -- Your extension configuration goes here:
      -- extension_name = {
      --   extension_config_key = value,
      -- }
      -- please take a look at the readme of the extension you want to configure
      fzf = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = true,  -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
      }
    }
  }

  telescope.setup(config)
  telescope.load_extension('fzf')
  telescope.load_extension('ultisnips')
end



return {
  { 'nvim-lua/plenary.nvim', lazy = true },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release"
      .. " && cmake --build build --config Release"
      .. " && cmake --install build --prefix build",
    cond = vim.fn.executable("cmake") == 1,
    lazy = true
  },
  {
    'fhill2/telescope-ultisnips.nvim',
    dependenceis = { 'sirver/ultisnips' },
    lazy = true
  },
  {
    'nvim-telescope/telescope.nvim',
    dependenceis = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
      'fhill2/telescope-ultisnips.nvim'
    },
    config = telescope_config,
    lazy = true
  },
}
