-- blink 가 preview pane 보여주기전에는 snippet 이 작동이 되질 않는다. <2025-04-07>

local source_name_map = {
  Snippets = "",
}

---@type LazySpec
return {
  [1] = "saghen/blink.cmp",
  version = "*",
  -- build = vim.fn.executable("nix") == 1 and "nix run .#build-plugin" or "cargo build --release",
  optional = true,
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    cmdline = {
      enabled = false, -- NOTE: false 여야지 작동하는데? <2025-04-06>
      keymap = {
        -- optionally, inherit the mappings from the top level `keymap`
        -- instead of using the neovim defaults
        -- preset = 'inherit',

        -- ["<C-n>"] = {
        --   function(cmp)
        --     -- NOTE: 작동 안됨, <2025-04-06>
        --     if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then
        --       return cmp.accept()
        --     end
        --   end,
        --   "show_and_insert",
        --   "select_next",
        --   "fallback",
        -- },
      },

      completion = {
        menu = { auto_show = true }, -- NOTE: 작동 안됨, <2025-04-06>
        ghost_text = { enabled = true }, -- NOTE: 작동 안됨, <2025-04-06>
      },
    },

    appearance = {
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },

    keymap = {
      preset = "super-tab",
    },

    completion = {
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        },
      },

      menu = {
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

    signature = {
      enabled = true,
    },
  },
}
