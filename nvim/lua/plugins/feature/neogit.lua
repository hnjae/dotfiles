-- NOTE: which-key를 무시하고 고유 키 동작 가이드가 있는데, 매우 불편.  <2024-01-04>
-- callback을 이용해서 ZZ 를 할당하고자 했으나 동작하지 않음.
return {
  [1] = "TimUntersberger/neogit",
  enabled = false,
  lazy = true,
  cmd = {
    "Neogit",
    "NeogitResetState",
  },
  opts = {
    mappings = {

      popup = {
        ["?"] = "HelpPopup",
        ["A"] = "CherryPickPopup",
        ["D"] = "DiffPopup",
        ["M"] = "RemotePopup",
        ["P"] = "PushPopup",
        ["X"] = "ResetPopup",
        ["Z"] = "StashPopup",
        ["b"] = false, -- "BranchPopup",
        ["B"] = "BisectPopup",
        ["c"] = "CommitPopup",
        ["f"] = "FetchPopup",
        ["l"] = "LogPopup",
        ["m"] = "MergePopup",
        ["p"] = "PullPopup",
        ["r"] = "RebasePopup",
        ["v"] = "RevertPopup",
        ["w"] = false, -- "WorktreePopup",
      },
    },
  },
  config = function(_, opts)
    require("neogit").setup(opts)

    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = { "NeogitStatus", "NeogitPopUp" },
      callback = function()
        vim.keymap.set({ "n" }, "ZZ", "<cmd>quit<CR>", { desc = "quit-neogit" })
      end,
    })
  end,
  specs = {
    [1] = "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function()
      local icons = require("val").icons
      require("state.lualine-ft-data"):add({
        NeogitStatus = { display_name = "NeogitStatus", icon = icons.git },
        -- NeogitWorkTreePopup
        -- NeogitCommitMessage
        -- NeogitPopUp
      })
    end,
  },
}
