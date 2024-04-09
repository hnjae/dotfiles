---@type LazySpec
return {
  [1] = "nvim-tree/nvim-web-devicons",
  lazy = true,
  opts = {
    default = true,
    -- override = {},
    -- override_by_filename = {},
    -- override_by_extension = {},
  },
  config = function(_, opts)
    local devicons = require("nvim-web-devicons")
    devicons.setup(opts)

    local icon, color, cterm_color

    _, color, cterm_color =
      devicons.get_icon_colors(nil, nil, { default = true })
    devicons.set_default_icon(require("val").icons.file, color, cterm_color)

    -- key= filename or extension (not filetype)
    local icons = {}

    -- key= filename or extension (not filetype)
    local icon_map = {
      -- stylua: ignore start
      -- extensions
      snippets = { overrides = { icon = "", name = "Snippets" } }, -- nf-cod-symbol_snippet
      snippet  = { overrides = { icon = "", name = "Snippets" } }, -- nf-cod-symbol_snippet
      cheat    = { overrides = { icon = "", name = "Cheat" } }, -- nf-oct-paperclip

      kdl  = { base = "yaml",     overrides = { name = "Kdl" } }, -- https://kdl.dev/
      toml = { base = "yaml",     overrides = { name = "Toml" } },
      adoc = { base = "markdown", overrides = { name = "AsciiDoc", icon = "󱇗" }, }, -- nf-md-note_text_outline

      -- filenames
      justfile            = { base = "cmake", overrides = { name = "Just" } },
      [".envrc"]          = { base = "cmake", overrides = { name = "Direnv" } },
      ["git-rebase-todo"] = { base = "git",   overrides = { name = "GitRebase" } },
      -- stylua: ignore end
    }

    for extension, val in pairs(icon_map) do
      if val.base then
        -- if type(val.base) == "table" then
        --   icon, color, cterm_color = devicons.get_icon_colors(unpack(val.base))
        icon, color, cterm_color = devicons.get_icon_colors(val.base)
        icons[extension] = vim.tbl_extend("force", {
          icon = icon,
          color = color,
          cterm_color = cterm_color,
        }, val.overrides)
      else
        icons[extension] = val.overrides
      end
    end

    devicons.set_icon(icons)
  end,
}

-- print default icon
-- print(require("nvim-web-devicons").get_icon("rstsr", "srtst", {default=true}))
-- print(require("nvim-web-devicons").get_icon_colors("markdown"))
