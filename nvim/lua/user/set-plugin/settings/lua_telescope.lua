local M = {}

local status_telescope, telescope = pcall(require, "telescope")

M.setup = function()
  if not status_telescope then
    return
  end

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
  if _IS_PLUGIN('telescope-fzf-native.nvim') then
    telescope.load_extension('fzf')
  end
  if _IS_PLUGIN('telescope-ultisnips.nvim') then
    telescope.load_extension('ultisnips')
  end
end

return M
