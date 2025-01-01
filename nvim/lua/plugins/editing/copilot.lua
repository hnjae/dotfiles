-- TODO: use copilot-cmp.lua instead of official version <2023-11-14>

---@type LazySpec[]
return {
  {
    [1] = "github/copilot.vim",
    lazy = true,
    enabled = false,
    -- event = { "InsertEnter" },
    ft = {
      "javascript",
      "typescript",
      "lua",
      "python",
    },
    cond = vim.fn.executable("node") == 1,
    init = function()
      vim.g.copilot_no_tab_map = true
    end,
    config = function()
      vim.cmd([[
        imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
    ]])
    end,
  },
  {
    [1] = "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    enabled = false,
    opts = {},
    specs = {
      {
        [1] = "hrsh7th/nvim-cmp",
        optional = true,
        dependencies = { "zbirenbaum/copilot-cmp" },
        ---@param opts myCmpOpts
        opts = function(_, opts)
          local cmp = require("cmp")

          if not opts.sources then
            opts.sources = {}
          end

          table.insert(opts.sources, { name = "copilot", group_index = 2 })
        end,
      },
      {
        [1] = "zbirenbaum/copilot.lua",
        optional = true,
        opts = {},
      },
    },
  },
  {
    [1] = "zbirenbaum/copilot.lua",
    lazy = false,
    enabled = false,
    cond = vim.fn.executable("node") == 1,
    opts = {
      panel = {
        -- enabled = false, -- use copilot-cmp
        auto_refresh = true,
      },
      suggestion = {
        -- enabled = false, -- use copilot-cmp
        auto_trigger = true,
        keymap = {
          accept = "<F10>",
        },
      },
      filetypes = {
        sh = function()
          if
            string.match(
              vim.fs.basename(vim.api.nvim_buf_get_name(0)),
              "^%.env.*"
            )
          then
            -- Disable for `.env` files
            return false
          end
          return true
        end,
        text = false,
        yaml = false,
        json = false,
        jsonc = false,
        toml = false,
        ini = false,
        markdown = false,
        asciidoctor = false,
        asciidoc = false,
        rst = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
        ["*"] = true,
      },
    },
    specs = {
      {
        [1] = "nvim-lualine/lualine.nvim",
        dependencies = { "AndreM222/copilot-lualine" },
        optional = true,
        cond = require("utils").enable_icon,
        ---@param opts myLualineOpts
        opts = function(_, opts)
          if not opts.sections then
            opts.sections = {}
          end
          if not opts.sections.lualine_x then
            opts.sections.lualine_x = {}
          end
          table.insert(
            opts.sections.lualine_x,
            { component = "copilot", priority = 100 }
          )
        end,
      },
    },
  },
}
