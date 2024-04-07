---@type LazySpec
return {
  [1] = "nvim-tree/nvim-web-devicons",
  lazy = true,
  -- cond = require("utils").enable_icon,
  opts = {
    default = true,
    override = {
      default_icon = require("val").icons.file,
    },
    override_by_filename = {},
    override_by_extension = {},
  },
  config = function(_, opts)
    local devicons = require("nvim-web-devicons")
    devicons.setup(opts)

    local icons = {
      snippets = { icon = "", name = "Snippets" }, -- nf-cod-symbol_snippet
      snippet = { icon = "", name = "Snippets" }, -- nf-cod-symbol_snippet
      -- snippets = { icon = "", name = "Snippets" }, -- nf-oct-code
      -- nf-oct-paperclip
      cheat = { icon = "", name = "Cheat" },
    }

    local icon, color, cterm_color = devicons.get_icon_colors("cmake")
    icons.justfile = {
      icon = icon,
      color = color,
      cterm_color = cterm_color,
      name = "Just",
    }
    icons[".envrc"] = {
      icon = icon,
      color = color,
      cterm_color = cterm_color,
      name = "Direnv",
    }

    icon, color, cterm_color = devicons.get_icon_colors("", "yaml")
    icons.kdl = {
      -- https://kdl.dev/
      icon = icon,
      color = color,
      cterm_color = cterm_color,
      name = "Kdl",
    }

    icon, color, cterm_color = devicons.get_icon_colors("", "yaml")
    icons.toml = {
      icon = icon,
      color = color,
      cterm_color = cterm_color,
      name = "Toml",
    }

    _, color, cterm_color = devicons.get_icon_colors("", "markdown")
    icons.adoc = {
      icon = "󱇗", -- nf-md-note_text_outline
      color = color,
      cterm_color = cterm_color,
      name = "AsciiDoc",
    }

    devicons.set_icon(icons)
  end,
}
