local icons = require("globals").icons

---@type LazySpec
return {
  [1] = "fzf-lua",
  enabled = false,
  cond = true,
  -- optional = true,
  keys = function(_, keys)
    local default_grep_opts = {
      search = "",
      fzf_opts = {
        ["--delimiter"] = ":",
        ["--nth"] = "3..",
      },
    }

    local grep_project = function()
      local opts = vim.deepcopy(default_grep_opts)
      -- opts.search_paths = { LazyVim.root() }
      opts.cwd = LazyVim.root()

      require("fzf-lua").grep(opts)
    end

    local grep_cwd = function()
      local opts = vim.deepcopy(default_grep_opts)
      opts.cwd = vim.fn.expand("%:h")

      require("fzf-lua").grep(opts)
    end

    return vim.list_extend(keys, {
      { [1] = "<F1>", [2] = "<cmd>FzfLua helptags<CR>", desc = "help-tags" },

      -- default mapping does not uses fzf's syntax
      { [1] = "<Leader>/", [2] = grep_project, desc = "Grep (Project)" },
      { [1] = "<Leader>sg", [2] = grep_project, desc = "Grep (Project)" }, -- same as above
      { [1] = "<Leader>sG", [2] = grep_cwd, desc = "Grep (buffer's cwd)" },
      -- { "<leader>ff", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      {
        [1] = "<Leader>fF",
        [2] = function()
          local opts = {
            ignore_current_file = false,
            cwd = vim.fn.expand("%:h"),
          }

          require("fzf-lua").files(opts)
        end,
        desc = "Find Files (buffer's cwd)",
      },
    })
  end,
  opts = function()
    local fzf = require("fzf-lua")
    local config = fzf.config
    local actions = fzf.actions

    -- restore fzf-lua's default mapping
    -- ["ctrl-s"]      = actions.file_split,
    -- ["ctrl-v"]      = actions.file_vsplit,
    -- ["ctrl-t"]      = actions.file_tabedit,
    config.defaults.actions.files["ctrl-t"] = actions.file_tabedit
    config.defaults.actions.files["ctrl-o"] = actions.file_split -- netrw의 o 에 서 따옴

    -- move trobule else where
    if LazyVim.has("trouble.nvim") then
      config.defaults.actions.files["ctrl-z"] = require("trouble.sources.fzf").actions.open
    end
  end,
  specs = {
    {
      [1] = "mini.icons",
      optional = true,
      opts = {
        filetype = {
          fzf = { glyph = icons.filter, hl = "MiniIconsAzure" },
        },
      },
    },
  },
}
