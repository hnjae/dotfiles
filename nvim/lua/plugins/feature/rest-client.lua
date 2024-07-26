local prefix = require("val").prefix.buffer

---@type LazySpec
return {
  [1] = "rest-nvim/rest.nvim",
  version = "1.*",
  main = "rest-nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      [1] = "nvim-treesitter",
      optional = true,
      opts = function()
        require("state.treesitter-langs"):add(
          "lua",
          "xml",
          "http",
          "json",
          "graphql"
        )
      end,
    },
  },
  lazy = true,
  -- enabled = vim.fn.has("nvim-0.9.2") == 1
  --   and vim.fn.has("python3") == 1
  --   and require("utils").is_treesitter,
  ft = { "http" },
  opts = function()
    return {
      highlight = {
        enabled = true,
      },
      result = {
        show_url = true,
        show_curl_command = true,
        show_http_info = true,
        show_headers = true,
        formatters = {
          json = vim.fn.executable("jq") == 1 and "jq" or "cat",
          html = function(body)
            if vim.fn.executable("tidy") ~= 1 then
              -- return vim.fn.system({ "echo", "--" }, body)
              return body, { found = false, name = "tidy" }
            end

            local fmt_body =
              vim.fn.system({ "tidy", "-i", "-q", "-" }, body):gsub("\n$", "")
            return fmt_body, { found = true, name = "tidy" }
          end,
        },
      },
    }
  end,
  cmd = { "RestLog", "RestSelectEnv" },
  keys = {
      -- stylua: ignore start
      { [1] = prefix .. "r", [2] = "<Plug>RestNvim",        ft = "http", desc = "RestNvim" },
      { [1] = prefix .. "R", [2] = "<Plug>RestNvimPreview", ft = "http", desc = "RestNvimPreview" },
      { [1] = prefix .. "g", [2] = "<cmd>RestLog<CR>",      ft = "http", desc = "RestLog" },
    -- stylua: ignore end
  },
  specs = {
    {
      [1] = "nvim-lualine/lualine.nvim",
      optional = true,
      ---@param opts myLualineOpts
      opts = function(_, opts)
        local icons = require("val").icons
        require("state.lualine-ft-data"):add({
          httpResult = { display_name = "HTTP Result", icon = icons.result },
        })
      end,
    },
  },
}
