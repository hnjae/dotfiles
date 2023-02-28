return {
  "L3MON4D3/LuaSnip",
  version = "1.2.x",
  build = "make install_jsregexp",
  cond = vim.fn.executable("make"),
  lazy = true,
  event = { "InsertEnter" },
  dependencies = {
    {
      "rafamadriz/friendly-snippets",
      module = true,
    },
    -- "nvim-lua/plenary.nvim",
    {
      "honza/vim-snippets",
      init = function()
        vim.g.snips_author = "Hyunjae Kim"
        vim.g.snips_email = "hyunjae.kim@gmx.com"
        vim.g.snips_github = "https://github.com/hnjae"
      end,
    },
  },
  -- opts = {},
  keys = function()
    local luasnip = require("luasnip")
    local keys = {
      {
        -- press <Tab> to expand or jump in a snippet. These can also be mapped separately
        "<Tab>",
        function()
          return (luasnip.expand_or_jumpable() and "<Plug>luasnip-expand-or-jump" or "<Tab>")
        end,
        desc = "tab-luasnip",
        silent = true,
        mode = "i",
        expr = true,
      },
    }
    return keys
  end,
  cmd = {
    "LuaSnipEdit",
  },
  config = function()
    local Path = require("plenary.path")
    -- NOTE: Path module does not resolve path <2023-02-13>
    local my_snippets = Path:new(vim.fn.resolve(Path:new(vim.fn.stdpath("config"), "snippets").filename))

    vim.api.nvim_create_user_command("LuaSnipEdit", function()
      require("luasnip.loaders").edit_snippet_files({
        format = function(file, source_name)
          local filename = file:match(".*/(.*)")
          for type_, pattern in pairs({
            ["MY SNIPPETS"] = vim.pesc(my_snippets.filename),
            ["friendly-snippets"] = vim.pesc("friendly-snippets"),
            ["vim-snippets"] = vim.pesc("vim-snippets"),
          }) do
            if file:find(pattern) ~= nil then
              return string.format("%8s: %17s: %s", source_name, type_, filename)
            end
          end
          return string.format("%8s: %s", source_name, file)
        end,
        edit = function(file)
          vim.api.nvim_command("split " .. file)
          -- vim.cmd("edit " .. file)
        end,
        extend = function(ft, paths)
          if ft == "all" then
            return {}
          end

          local filepath = my_snippets:joinpath("snippets", ft .. ".json").filename
          for _, path in pairs(paths) do
            if filepath == path then
              return {}
            end
          end

          return {
            { filepath, filepath },
          }
        end,
      })
    end, {})

    -- local util = require("luasnip.util.util")
    -- local fts = util.get_snippet_filetypes()

    require("luasnip.loaders.from_vscode").lazy_load({
      paths = my_snippets.filename,
    })
    require("luasnip.loaders.from_vscode").lazy_load({
      exclude = { "lua", "python", "tex", "kotlin", "gitcommit", "rust", "all", "asciidoc", "asciidoctor" },
    })
    require("luasnip.loaders.from_snipmate").lazy_load({
      exclude = { "lua", "all" },
    })
  end,
}
