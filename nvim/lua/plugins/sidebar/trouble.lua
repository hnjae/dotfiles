local prefix = require("val").prefix
local map_keyword = require("val").map_keyword

---@type LazySpec[]
return {
  {
    -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
    [1] = "folke/trouble.nvim",
    lazy = true,
    enabled = true,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    cmd = {
      "Trouble",
      "TroubleClose",
      "TroubleToggle",
    },
    opts = {
      icon = require("utils").enable_icon,
    },
    keys = {
      {
        [1] = prefix.focus .. map_keyword.trouble,
        [2] = "<cmd>Trouble<CR>",
        desc = "focus-trouble",
      },
      {
        [1] = prefix.trouble,
        [2] = nil,
        desc = "+trouble",
      },
      {
        [1] = prefix.trouble .. map_keyword.trouble,
        [2] = "<cmd>TroubleToggle<CR>",
        desc = "trouble-toggle",
      },
      {
        [1] = prefix.sidebar .. map_keyword.trouble,
        [2] = "<cmd>TroubleToggle<CR>",
        desc = "trouble-toggle",
      },
      {
        [1] = prefix.trouble .. "w",
        [2] = "<cmd>TroubleToggle workspace_diagnostics<CR>",
        desc = "workspace-diagnostics",
      },
      {
        [1] = prefix.trouble .. "d",
        [2] = "<cmd>TroubleToggle document_diagnostics<CR>",
        desc = "document-diagnostics",
      },
      {
        [1] = prefix.trouble .. "q",
        [2] = "<cmd>TroubleToggle quickfix<CR>",
        desc = "quickfix",
      },
      {
        [1] = prefix.trouble .. "l",
        [2] = "<cmd>TroubleToggle loclist<CR>",
        desc = "location-list",
      },
      {
        [1] = prefix.trouble .. "r",
        [2] = "<cmd>TroubleToggle lsp_references<CR>",
        desc = "lsp-references",
      },
    },
  },
  {
    [1] = "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      local get_name = function()
        local trouble_opts = require("trouble.config").options

        local words = vim.split(trouble_opts.mode, "[%W]")
        for i, word in ipairs(words) do
          words[i] = word:sub(1, 1):upper() .. word:sub(2)
        end

        return table.concat(words, " ")
      end

      local name
      if require("utils").enable_icon then
        local icon = require("val.icons").tools
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
        filetypes = { "Trouble" },
      }

      if not opts.extensions then
        opts.extensions = {}
      end

      table.insert(
        opts.extensions,
        vim.tbl_deep_extend(
          "keep",
          require("val.plugins.lualine").__get_basic_layout(),
          extension
        )
      )
    end,
  },
}
