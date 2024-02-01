-- TODO: luasnipedit 을 package.jsonc 에서 읽어서 처리 <2023-11-21>
-- NOTE:
--[[
새 snippet을 추가하고 싶으면
my_snippets 의 package.json 파일을 수정해주고, 관련 파일을 수정해준다.
https://github.com/rafamadriz/friendly-snippets 의 형식 참고.
]]
--

---@type LazySpec
return {
  [1] = "L3MON4D3/LuaSnip",
  version = "1.2.x",
  build = "make install_jsregexp",
  enabled = vim.fn.executable("make") == 1,
  lazy = true,
  event = { "InsertEnter" },
  dependencies = {
    {
      [1] = "rafamadriz/friendly-snippets",
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
  keys = {
    {
      -- press <Tab> to expand or jump in a snippet. These can also be mapped separately
      [1] = "<Tab>",
      [2] = function()
        return require("luasnip").expand_or_locally_jumpable()
            and "<Plug>luasnip-expand-or-jump"
          or "<Tab>"
      end,
      desc = "tab-luasnip",
      silent = true,
      mode = { "i", "s" },
      expr = true,
    },
    {
      [1] = "<Tab>",
      [2] = function()
        -- NOTE: normal 모드 맵핑이랑 i, s 모드 맵핑이랑 묶어서 표현하는 건
        -- 불가능으로 보임. <2024-01-15>
        if require("luasnip").expand_or_locally_jumpable() then
          require("luasnip").expand_or_jump()
        end
      end,
      desc = "tab-luasnip",
      silent = true,
      mode = { "n" },
      expr = true,
    },
  },
  cmd = {
    "LuaSnipEdit",
  },
  config = function()
    local Path = require("plenary.path")

    -- NOTE: Path module does not resolve path <2023-02-13>
    local my_snippets = Path:new(
      vim.fn.resolve(Path:new(vim.fn.stdpath("config"), "snippets").filename)
    )

    vim.api.nvim_create_user_command("LuaSnipEdit", function()
      require("luasnip.loaders").edit_snippet_files({
        -- format = function(file, source_name)
        --   local filename = file:match(".*/(.*)")
        --   for type_, pattern in pairs({
        --     ["MY SNIPPETS"] = vim.pesc(my_snippets.filename),
        --   }) do
        --     if file:find(pattern) ~= nil then
        --       return string.format(
        --         "%8s: %17s: %s",
        --         source_name,
        --         type_,
        --         filename
        --       )
        --     end
        --   end
        --   return string.format("%8s: %s", source_name, file)
        -- end,
        edit = function(file)
          vim.api.nvim_command("split " .. file)
        end,
        extend = function(ft, paths)
          if ft == "all" then
            return {}
          end

          local filepath =
            my_snippets:joinpath("snippets", ft .. ".jsonc").filename
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
