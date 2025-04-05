--[[ NOTE:

  All presets have the following mappings:
    - C-space: Open menu or open docs if already open
    - C-n/C-p or Up/Down: Select next/previous item
    - C-e: Hide menu
    - C-k: Toggle signature help (if signature.enabled = true)

    - See :h blink-cmp-config-keymap for defining your own keymap
]]

---@type LazySpec
return {
  [1] = "Saghen/blink.cmp",
  cond = not vim.g.vscode and true,
  dependencies = {
    { [1] = "onsails/lspkind-nvim", optional = true }, -- my personal dependency
  },

  -- optional: provides snippets for the snippet source
  -- dependencies = { "rafamadriz/friendly-snippets" },

  version = "1.*",

  opts = function()
    local source_name_map = {
      Snippets = "",
    }

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    local opts = {
      cmdline = { enabled = true },

      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        preset = "default",
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        nerd_font_variant = "normal",
        kind_icons = require("lspkind").symbol_map,
      },

      completion = {
        documentation = {
          auto_show = true, -- default: false (Only show the documentation popup when manually triggered)
        },
        menu = {
          -- Don't automatically show the completion menu
          -- auto_show = false,

          draw = {
            columns = {
              { [1] = "label", [2] = "label_description", gap = 1 },
              { "kind_icon", "kind" },
              { "source_name" },
            },
            components = {
              source_name = {
                text = function(ctx)
                  local custom_name = source_name_map[ctx.source_name]
                  if custom_name == "" then
                    return nil
                  end

                  if custom_name ~= nil then
                    return custom_name
                  end

                  return string.format("[%s]", ctx.source_name)
                end,
              },
            },
          },
        },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      snippets = { preset = "luasnip" },

      fuzzy = { implementation = "prefer_rust_with_warning" },
    }

    return opts
  end,

  -- can be a list of dotted keys that will be extended instead of merged ([1f7b720](https://github.com/folke/lazy.nvim/commit/1f7b720cffa6d8f00ebb040bc60e8e056e0a6002))
  opts_extend = { "sources.default" },
}
