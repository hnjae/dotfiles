-- Run API request

-- LazyVim 의 util.rest 의 prefix와 동일하게 설정
local prefix = "<Leader>R"

---@type LazySpec
return {
  [1] = "jellydn/hurl.nvim",
  version = "*", -- it uses sementic versioning

  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    {
      [1] = "nvim-treesitter/nvim-treesitter",
      opts = { ensure_installed = { "hurl" } },
    },
  },

  lazy = true,
  ft = "hurl",
  opts = {
    show_notification = false,
  },
  cmd = {
    "HurlDebugInfo",
    "HurlJson",
    "HurlManageVariable",
    "HurlRerun",
    "HurlRunner",
    "HurlRunnerAt",
    "HurlRunnerToEnd",
    "HurlRunnerToEntry",
    "HurlSetEnvFile",
    "HurlSetVariable",
    "HurlShowLastResponse",
    "HurlToggleMode",
    "HurlVerbose",
    "HurlVeryVerbose",
  },
  -- stylua: ignore
  keys = {
    { [1] = prefix, [2] = "", desc="+Rest (Hurl)", ft="hurl" },

    { [1] = prefix .. "a", [2] = "<cmd>HurlRunnerAt<CR>", desc = "run-api", ft = "hurl" },
    { [1] = prefix .. "A", [2] = "<cmd>HurlRunner<CR>", desc = "run-api (All)", ft = "hurl" },

    { [1] = prefix .. "e", [2] = "<cmd>HurlRunnerToEntry<CR>", desc = "run-api (to-entry)", ft = "hurl" },
    { [1] = prefix .. "E", [2] = "<cmd>HurlRunnerToEnd<CR>", desc = "run-api (to-end)", ft = "hurl" },

    { [1] = prefix .. "m", [2] = "<cmd>HurlToggleMode<CR>", desc = "hurl-toggle-mode", ft = "hurl", },

    { [1] = prefix .. "v", [2] = "<cmd>HurlVerbose<CR>", desc = "run-api (verbose)", ft = "hurl", },
    { [1] = prefix .. "V", [2] = "<cmd>HurlVeryVerbose<CR>", desc = "run-api (very verbose)", ft = "hurl", },

    -- Run Hurl request in visual mode
    { [1] = prefix, mode = "v", [2] = ":HurlRunner<CR>", desc = "hurl-runner", ft = "hurl" },
  },
  specs = {
    {
      [1] = "folke/which-key.nvim",
      optional = true,
      dependencies = { "echasnovski/mini.icons" },
      ---@param opts wk.Opts
      opts = function(_, opts)
        local icon = require("mini.icons").get("extension", "hurl")
        local wk_icon = { icon = icon, color = "green" }

        opts.icons = opts.icons or {}
        opts.icons.rules = opts.icons.rules or {}
        table.insert(opts.icons, { plugin = "hurl.nvim", icon = wk_icon.icon, color = wk_icon.color })

        opts.spec = opts.spec or {}
        table.insert(opts.spec, { [1] = prefix, mode = { "n", "v" }, group = "hurl", icon = wk_icon })
      end,
    },
  },
}
