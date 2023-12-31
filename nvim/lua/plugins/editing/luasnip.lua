-- TODO: luasnipedit 을 package.json 에서 읽어서 처리 <2023-11-21>
-- NOTE:
--[[
새 snippet을 추가하고 싶으면
my_snippets 의 package.json 파일을 수정해주고, 관련 파일을 수정해준다.
https://github.com/rafamadriz/friendly-snippets 의 형식 참고.
]]
--

return {
  [1] = "L3MON4D3/LuaSnip",
  version = "1.2.x",
  build = "make install_jsregexp",
  -- cond = vim.fn.executable("make") == 1,
  enabled = vim.fn.executable("make") == 1,
  lazy = true,
  event = { "InsertEnter" },
  dependencies = {
    {
      [1] = "rafamadriz/friendly-snippets",
      module = true,
    },
    -- "nvim-lua/plenary.nvim",
    {
      [1] = "honza/vim-snippets",
      init = function()
        vim.g.snips_author = "KIM Hyunjae"
        vim.g.snips_email = "hyunjae@gmx.com"
        vim.g.snips_github = "https://github.com/hnjae"
      end,
    },
  },
  keys = function()
    local status_luasnip, luasnip = pcall(require, "luasnip")
    if not status_luasnip then
      return {}
    end

    -- TODO: fix this. (requiring module here)
    local keys = {
      {
        -- press <Tab> to expand or jump in a snippet. These can also be mapped separately
        [1] = "<Tab>",
        [2] = function()
          return (luasnip.expand_or_locally_jumpable() and "<Plug>luasnip-expand-or-jump" or "<Tab>")
          -- return (luasnip.expand_or_jumpable() and "<Plug>luasnip-expand-or-jump" or "<Tab>")
          -- return (luasnip.expandable() and "<Plug>luasnip-expand-or-jump" or "<Tab>")
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
            -- ["friendly-snippets"] = vim.pesc("friendly-snippets"),
            -- ["vim-snippets"] = vim.pesc("vim-snippets"),
          }) do
            if file:find(pattern) ~= nil then
              return string.format("%8s: %17s: %s", source_name, type_, filename)
            end
          end
          return string.format("%8s: %s", source_name, file)
        end,
        edit = function(file)
          vim.api.nvim_command("split " .. file)
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

    require("luasnip.loaders.from_vscode").lazy_load({
      paths = my_snippets.filename,
    })
  end,
}
