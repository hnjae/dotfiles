local REPLACE_NETRW = true

local find_project_root = require("lspconfig").util.root_pattern(
  unpack(require("globals").root_patterns)
)
local map_keyword = require("globals").map_keyword

---@type LazySpec
return {
  [1] = "stevearc/oil.nvim",
  lazy = true,
  event = REPLACE_NETRW and "VimEnter" or nil,
  cond = not vim.g.vscode,
  enabled = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = {
    "Oil",
  },
  keys = {
    {
      [1] = "-",
      -- [2] = "<cmd>Oil<cr>",
      [2] = function()
        if vim.bo.filetype == "oil" then
          local oil = require("oil")
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
          local msg = "Can not open Oil from here: buftype is "
            .. vim.bo.buftype
          vim.notify(msg)
          return
        end

        if
          vim.list_contains({ "gitcommit", "gitbase", "git" }, vim.bo.filetype)
        then
          local msg = "Can not open Oil from here: filetype is "
            .. vim.bo.filetype
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
  },
  opts = {
    use_default_keymaps = false,
    default_file_explorer = REPLACE_NETRW, -- replace netrw
    delete_to_trash = true,
    columns = {
      {
        [1] = "icon",
        directory = require("globals").icons.directory,
      },
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
      [string.format("<C-%s>", map_keyword.vsplit)] = "actions.select_vsplit",
      [string.format("<C-%s>", map_keyword.split)] = "actions.select_split",
      [string.format("<C-%s>", map_keyword.tab)] = "actions.select_tab",

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
  config = function(_, opts)
    require("oil").setup(opts)

    -- NOTE: fugitive 에서 - 작동을 안하게 하려고 애썼으나, 안됨. oil 내부에서
    -- 어떻게 일괄로 처리하는 것 같다.<2024-02-20>
    -- vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufAdd" }, {
    --   callback = function(arg)
    --     if
    --       arg.event == "FileType"
    --       and (
    --         vim.tbl_contains({
    --           "noice",
    --           "notify",
    --           "cmp_menu",
    --           "cmp_docs",
    --           "TelescopePrompt",
    --           "TelescopeResult",
    --         }, arg.match)
    --         or string.match(arg.file, ".+://.*")
    --       )
    --     then
    --       return
    --     end
    --
    --     if arg.event == "BufReadPost" and string.match(arg.file, ".+://.*") then
    --       -- fugitive, ol, term 등, 평범한 파일이 아니면 무시
    --       return
    --     end
    --
    --     if
    --       arg.event == "BufAdd" and not (arg.match == "" and arg.file == "")
    --     then
    --       -- :enew 로 만들어진 빈 버퍼가 아닐 경우 무시
    --       return
    --     end
    --
    --     vim.notify(vim.inspect(arg))
    --     -- vim.api.nvim_buf_set_keymap(arg.buf, "n", "-", "<cmd>Oil<CR>")
    --     vim.keymap.set(
    --       { "n" },
    --       "-",
    --       -- "<cmd>Oil<CR>",
    --       function()
    --         vim.notify(vim.inspect(arg))
    --       end,
    --       { noremap = false, buffer = arg.buf }
    --     )
    --   end,
    -- })
  end,
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function(_, opts)
        local icons = require("globals").icons
        require("plugins.core.lualine.utils.buffer-attributes"):add({
          oil = { display_name = "Oil", icon = icons.directory },
        })

        local modules = require("lualine_require").lazy_require({
          oil = "oil",
          lspconfig = "lspconfig",
          Path = "plenary.path",
        })

        local find_project_root = modules.lspconfig.util.root_pattern(
          unpack(require("globals").root_patterns)
        )

        local get_name = function()
          local cur_dir = modules.oil.get_current_dir()
          local project_root = find_project_root(cur_dir)

          if project_root ~= nil then
            return modules.Path:new(cur_dir):make_relative(project_root)
          end

          return vim.fn.fnamemodify(cur_dir, ":~")
        end

        local name
        if require("utils").use_icons then
          local icon =
            require("plugins.core.lualine.utils.get-icon")(nil, "oil")
          name = function()
            return string.format("%s %s", icon, get_name())
          end
        else
          name = get_name
        end

        local extension = {
          sections = {
            lualine_c = { { name } },
          },
          inactive_sections = {
            lualine_c = { { name } },
          },
          filetypes = { "oil" },
        }

        if not opts.extensions then
          opts.extensions = {}
        end

        table.insert(
          opts.extensions,
          vim.tbl_deep_extend(
            "keep",
            require("globals.plugins.lualine").__get_basic_layout(),
            extension
          )
        )
      end,
    },
  },
}
