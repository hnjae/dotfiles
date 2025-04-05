local REPLACE_NETRW = true

---@type LazySpec
return {
  [1] = "stevearc/oil.nvim",
  lazy = true,
  version = "*",
  event = REPLACE_NETRW and "VimEnter" or nil,
  cond = not vim.g.vscode,
  enabled = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = {
    "Oil",
  },
  keys = function()
    local oil = require("oil")
    local find_project_root = require("lspconfig").util.root_pattern(unpack(require("globals").root_patterns))

    return {
      {
        [1] = "-",
        [2] = function()
          if vim.bo.filetype == "oil" then
            local cur_dir = oil.get_current_dir()
            local project_root = find_project_root(cur_dir)

            if project_root ~= nil and project_root == cur_dir then
              local msg = "This is the root of the project: " .. cur_dir
              vim.notify(msg)
              return
            end

            oil.open()
            return
          end

          if vim.bo.buftype ~= "" then
            local msg = "Can not open Oil from here: buftype is " .. vim.bo.buftype
            vim.notify(msg)
            return
          end

          if vim.list_contains({ "gitcommit", "gitbase", "git" }, vim.bo.filetype) then
            local msg = "Can not open Oil from here: filetype is " .. vim.bo.filetype
            vim.notify(msg)
            return
          end

          require("oil").open()
        end,
        -- expr = true,
        desc = "oil-up",
      },
      {
        [1] = "_",
        [2] = function()
          require("oil").open()
        end,
        desc = "oil-up-force",
      },
    }
  end,
  opts = {
    use_default_keymaps = false,
    default_file_explorer = REPLACE_NETRW, -- replace netrw
    delete_to_trash = true,
    columns = {
      -- {
      --   [1] = "icon",
      --   directory = require("globals").icons.directory,
      -- },
      {
        [1] = "mtime",
        format = "%Y-%m-%d %H:%M:%S",
      },
      -- icon = {
      --   directory = "1",
      -- },
    },
    keymaps = {
      -- match telescope
      -- [string.format("<C-%s>", map_keyword.vsplit)] = "actions.select_vsplit",
      -- [string.format("<C-%s>", map_keyword.split)] = "actions.select_split",
      -- [string.format("<C-%s>", map_keyword.tab)] = "actions.select_tab",
      [string.format("<C-%s>", "v")] = "actions.select_vsplit",
      [string.format("<C-%s>", "x")] = "actions.select_split",
      [string.format("<C-%s>", "t")] = "actions.select_tab",

      -- match netrw
      ["gh"] = "actions.toggle_hidden",

      -- defaults
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<C-l>"] = "actions.refresh",
      -- ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g\\"] = "actions.toggle_trash",
    },
  },
  specs = {},
}
