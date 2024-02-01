local val = require("val")
return {
  [1] = "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false, -- hijack 을 위해서 false 로 해야함.
  cmd = {
    "NvimTreeToggle",
    "NvimTreeOpen",
    "NvimTreeClose",
    "NvimTreeFocus",
    "NvimTreeResize",
    "NvimTreeRefresh",
    "NvimTreeCollapse",
    "NvimTreeClipboard",
    "NvimTreeFindFile",
    "NvimTreeFindFileToggle",
    "NvimTreeCollapseKeepBuffers",
  },
  keys = {
    {
      [1] = val.prefix.sidebar .. val.map_keyword.filemanager,
      [2] = "<cmd>NvimTreeToggle<CR>",
      desc = "NvimTree-toggle",
    },
    {
      [1] = val.prefix.focus .. val.map_keyword.filemanager,
      [2] = "<cmd>NvimTreeFocus<CR>",
      desc = "NvimTree",
    },
  },
  opts = {
    disable_netrw = false,
    hijack_netrw = false,
    hijack_directories = {
      enable = true,
      auto_open = true,
    },
    sort = {
      -- sorter = "case_insensitive",
    },
    view = {
      -- mappings = {},
    },
    renderer = {
      highlight_git = false,
      highlight_opened_files = "icon",
      highlight_modified = "all",
      indent_width = 1,
      special_files = {
        "Cargo.toml",
        "tsconfig.json",
        "package.json",
        "Makefile",
        "README.md",
        "README.adoc",
        "README.org",
        "readme.md",
        "readme.adoc",
        "readme.org",
      },
    },
    diagnostics = {
      enable = true,
      show_on_dirs = false,
      icons = {
        hint = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
        info = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
        warning = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
        error = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
      },
    },
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")
      local function opts(desc)
        return {
          desc = "(NvimTree) " .. desc,
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true,
        }
      end

      local function not_available()
        vim.notify("Not available in NvimTree")
      end

      --
      vim.keymap.set("n", "W", api.tree.collapse_all, opts("root-to-node"))

      -- netrw 와는 작동 방식이 다름. marked file을 옮기는게 아님
      vim.keymap.set("n", "fc", api.fs.copy.node, opts("copy"))
      vim.keymap.set("n", "fx", api.fs.cut, opts("cut"))
      vim.keymap.set("n", "fp", api.fs.paste, opts("paste"))

      -- netrw 에는 없는 기능
      vim.keymap.set(
        "n",
        "_",
        api.tree.change_root_to_node,
        opts("root-to-node")
      )

      --

      -- mimic netrw
      vim.keymap.set("n", "<F1>", api.tree.toggle_help, opts("help"))
      vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts("../"))
      vim.keymap.set("n", "%", api.fs.create, opts("creat"))
      vim.keymap.set("n", "<CR>", api.node.open.edit, opts("open"))
      vim.keymap.set("n", "t", api.node.open.tab, opts("open-tab"))
      vim.keymap.set("n", "v", api.node.open.vertical, opts("open-vertical"))
      vim.keymap.set(
        "n",
        "o",
        api.node.open.horizontal,
        opts("open-horizontal")
      )
      vim.keymap.set("n", "D", api.fs.trash, opts("trash"))
      vim.keymap.set("n", "r", not_available, opts("")) -- reverse order
      vim.keymap.set("n", "s", not_available, opts("")) -- sort options
      vim.keymap.set("n", "R", api.fs.rename, opts("rename"))
      vim.keymap.set("n", "<C-l>", api.tree.reload, opts("refresh"))

      vim.keymap.set("n", "p", api.node.open.preview, opts("preview"))
      vim.keymap.set(
        "n",
        "o",
        api.node.open.horizontal,
        opts("open-new-window")
      )

      -- vim.keymap.set("n", "m", nil, opts("+mark"))
      -- vim.keymap.set("n", "mf", api.marks.toggle, opts("file"))
      -- vim.keymap.set("n", "mm", api.marks.bulk.move, opts("move"))
      -- vim.keymap.set("n", "mu", api.marks.clear, opts("unmark-all"))
      -- vim.keymap.set("n", "mxx", api.marks.marks.bulk.trash, opts("bulk-trash"))
    end,
  },
}
