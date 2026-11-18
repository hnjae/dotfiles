-- LazyExtra's coding.blink (with coding.luasnip)
-- cmdline 은 blink 로 완성하지 않고 nvim 기본 동작을 유지한다.

---@type LazySpec
return {
  {
    [1] = "blink.cmp",
    optional = true,
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      cmdline = { enabled = false },

      completion = {
        -- disable preselect
        list = { selection = { preselect = false, auto_insert = false } },
        menu = {
          draw = {
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "source_name" },
            },
            components = {
              label = { width = { max = 40 } },
              source_name = {
                width = { max = 30 },
                text = function(ctx)
                  return string.format("[%s]", ctx.source_name)
                end,
              },
            },
          },
        },
      },

      sources = {
        providers = {
          -- make snippets rank first
          snippets = { score_offset = 10 },
        },
      },

      keymap = {
        -- LazyVim's default preset ("enter") accepts with <CR>
        preset = "default",

        -- do not fall back to default behavior of <C-n> when the menu is not visible
        ["<C-n>"] = {
          function(cmp)
            if cmp.is_visible() then
              return cmp.select_next()
            end
            return cmp.show()
          end,
        },
        ["<C-p>"] = {
          function(cmp)
            if cmp.is_visible() then
              return cmp.select_prev()
            end
            return cmp.show()
          end,
        },

        -- NOTE: `snippet_forward` must stay in the list so blink maps <Tab> in select mode too.
        ["<Tab>"] = {
          function()
            local ok, luasnip = pcall(require, "luasnip")
            if ok and luasnip.expand_or_locally_jumpable() then
              -- keymap functions run in an expr mapping, where the buffer is locked
              vim.schedule(function()
                luasnip.expand_or_jump()
              end)
              return true
            end
          end,
          "snippet_forward",
          "accept",
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
      },
    },
  },
  {
    [1] = "blink.cmp",
    optional = true,
    opts = function()
      -- disable transparency
      vim.opt.pumblend = 0
      vim.cmd([[
        hi Pmenu blend=0
        hi PmenuSel blend=0
      ]])
    end,
  },
}
