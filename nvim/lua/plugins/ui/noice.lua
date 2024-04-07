-- replace cmdline, messages, popupmenu

---@type LazySpec
local M = {
  [1] = "folke/noice.nvim",
  lazy = true,
  enabled = true,
  event = {
    -- "VimEnter",
    "VeryLazy",
  },
  dependencies = {
    "rcarriga/nvim-notify",
    { "MunifTanjim/nui.nvim" },
  },
  opts = function()
    local ret = {
      -- notify = {
      --   enabled = false,
      -- },
      lsp = {
        progress = {
          enabled = true,
          throttle = 1000 / 300,
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = require("utils").is_treesitter,
          ["vim.lsp.util.stylize_markdown"] = require("utils").is_treesitter,
          ["cmp.entry.get_documentation"] = require("utils").is_plugin(
            "nvim-cmp"
          ),
        },
        hover = {
          enabled = false,
        },
        signature = {
          -- enabled = not require("utils").is_plugin("lsp_signature.nvim"),
          enabled = false, -- NOTE: 계속 signature hover window를 띄어놓는 법을 모르겠음 <2024-04-06>
          view = "hover",
          -- view = "popupmenu",
        },
      },
      messages = {
        -- Messages shown by lsp servers
        enabled = true,
        -- view = "mini",
      },
      popupmenu = {
        backend = "cmp",
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        -- command_palette = true, -- position the cmdline and popupmenu together
        -- long_message_to_split = false, -- long messages will be sent to a split
        -- inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    }
    return ret
  end,
  config = function(_, opts)
    require("noice").setup(opts)

    -- vim.keymap.set({ "n", "i", "s" }, "<c-j>", function()
    --   if not require("noice.lsp").scroll(4) then
    --     return "<c-f>"
    --   end
    -- end, { silent = true, expr = true })
    --
    -- vim.keymap.set({ "n", "i", "s" }, "<c-k>", function()
    --   if not require("noice.lsp").scroll(-4) then
    --     return "<c-b>"
    --   end
    -- end, { silent = true, expr = true })
  end,
}

if require("utils").is_treesitter then
  ---@diagnostic disable-next-line: param-type-mismatch
  table.insert(M.dependencies, "nvim-treesitter/nvim-treesitter")
end

return M
