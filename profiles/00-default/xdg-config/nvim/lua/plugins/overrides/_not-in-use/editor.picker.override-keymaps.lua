---@type LazySpec[]
return {
  {
    [1] = "LazyVim",
    optional = true,
    keys = {
      {
        [1] = "<F1>",
        [2] = "<leader>sh",
        remap = true,
      },
      {
        [1] = "<leader>fF",
        [2] = function()
          if vim.bo.buftype ~= "" then
            LazyVim.pick("files", { root = false })()
          else
            LazyVim.pick("files", { cwd = vim.fn.expand("%:h") })()
          end
        end,
        desc = "Find Files (buffer's dir)",
      },
      {
        [1] = "<leader>sG",
        [2] = function()
          if vim.bo.buftype ~= "" then
            LazyVim.pick("live_grep", { root = false })()
          else
            LazyVim.pick("live_grep", { cwd = vim.fn.expand("%:h") })()
          end
        end,
        desc = "Grep (buffer's dir)",
      },
      {
        "<leader>sW",
        [2] = function()
          if vim.bo.buftype ~= "" then
            LazyVim.pick("grep_word", { root = false })()
          else
            LazyVim.pick("grep_word", { cwd = vim.fn.expand("%:h") })()
          end
        end,
        desc = "Visual selection or word (buffer's dir)",
        mode = { "n", "x" },
      },
    },
  },
  {
    [1] = "snacks.nvim",
    keys = {
      { "<leader>fF", false },
      { "<leader>sG", false },
      { "<leader>sW", false },
    },
  },
  {
    [1] = "fzf-lua",
    keys = {
      { "<leader>fF", false },
      { "<leader>sG", false },
      { "<leader>sW", false },
    },
  },
}
