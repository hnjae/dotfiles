---@type LazySpec
return {
  [1] = "stevearc/oil.nvim",
  lazy = false,
  -- event = "VeryLazy",
  enabled = true,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = {
    "Oil",
  },
  keys = {
    {
      [1] = "-",
      [2] = "<cmd>Oil<cr>",
      desc = "oil-up",
    },
  },
  opts = {
    use_default_keymaps = false,
    default_file_explorer = false, -- replace netrw
    delete_to_trash = true,
    columns = {
      {
        [1] = "icon",
        directory = require("val").icons.directory,
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
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-x>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",

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
}
