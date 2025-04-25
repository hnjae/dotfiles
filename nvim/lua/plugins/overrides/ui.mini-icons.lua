local strip = function(str)
  return string.sub(str, 1, #str - 1)
end

local icons = {
  directory = strip(require("globals").icons.directory),
  file = strip(require("globals").icons.file),
}

---@type LazySpec
return {
  [1] = "mini.icons",
  optional = true,
  opts = {
    -- stylua: ignore
    default = {
      directory = { glyph = icons.directory, hl = 'MiniIconsAzure'  },
      file      = { glyph = icons.file,      hl = 'MiniIconsGrey'   },
      filetype  = { glyph = icons.file,      hl = 'MiniIconsGrey'   },
    },
    -- stylua: ignore
    directory = {
      -- override defaults <2025-04-24>
      ['.cache']    = { glyph = '󰪻', hl = 'MiniIconsCyan'   },
      ['.config']   = { glyph = '󱂀', hl = 'MiniIconsCyan'   },
      ['.git']      = { glyph = "", hl = 'MiniIconsOrange' },
      ['.github']   = { glyph = "", hl = 'MiniIconsAzure'  },
      ['.local']    = { glyph = '󰮜', hl = 'MiniIconsCyan'   },
      ['.vim']      = { glyph = icons.directory, hl = 'MiniIconsGreen'  },
      AppData       = { glyph = '󰮜', hl = 'MiniIconsOrange' },
      Applications  = { glyph = '󱧻', hl = 'MiniIconsOrange' },
      Desktop       = { glyph = '󰮟', hl = 'MiniIconsOrange' },
      Documents     = { glyph = '󱧷', hl = 'MiniIconsOrange' },
      Downloads     = { glyph = '󱧩', hl = 'MiniIconsOrange' },
      Favorites     = { glyph = '󱃫', hl = 'MiniIconsOrange' },
      Library       = { glyph = '󰲃', hl = 'MiniIconsOrange' },
      Music         = { glyph = '󱍚', hl = 'MiniIconsOrange' },
      Network       = { glyph = '󰲁', hl = 'MiniIconsOrange' },
      Pictures      = { glyph = icons.directory, hl = 'MiniIconsOrange' },
      ProgramData   = { glyph = '󰮜', hl = 'MiniIconsOrange' },
      Public        = { glyph = '󱧳', hl = 'MiniIconsOrange' },
      System        = { glyph = '󱧽', hl = 'MiniIconsOrange' },
      Templates     = { glyph = '󱋤', hl = 'MiniIconsOrange' },
      Trash         = { glyph = '󱧵', hl = 'MiniIconsOrange' },
      Users         = { glyph = '󰮜', hl = 'MiniIconsOrange' },
      Videos        = { glyph = '󱞋', hl = 'MiniIconsOrange' },
      Volumes       = { glyph = '󰉕', hl = 'MiniIconsOrange' },
      autoload      = { glyph = '󱁾', hl = 'MiniIconsGreen'  },
      bin           = { glyph = '󱧻', hl = 'MiniIconsYellow' },
      build         = { glyph = '󱧽', hl = 'MiniIconsGrey'   },
      boot          = { glyph = '󰴌', hl = 'MiniIconsYellow' },
      colors        = { glyph = '󱁾', hl = 'MiniIconsGreen'  },
      compiler      = { glyph = '󱁾', hl = 'MiniIconsGreen'  },
      dev           = { glyph = '󱧽', hl = 'MiniIconsYellow' },
      doc           = { glyph = '󱂸', hl = 'MiniIconsPurple' },
      docs          = { glyph = '󱂸', hl = 'MiniIconsPurple' },
      etc           = { glyph = '󱂀', hl = 'MiniIconsYellow' },
      ftdetect      = { glyph = '󱁾', hl = 'MiniIconsGreen'  },
      ftplugin      = { glyph = '󱁾', hl = 'MiniIconsGreen'  },
      home          = { glyph = '󱂶', hl = 'MiniIconsYellow' },
      indent        = { glyph = '󱁾', hl = 'MiniIconsGreen'  },
      keymap        = { glyph = '󱁾', hl = 'MiniIconsGreen'  },
      lang          = { glyph = '󱁾', hl = 'MiniIconsGreen'  },
      lib           = { glyph = '󰲃', hl = 'MiniIconsYellow' },
      lsp           = { glyph = '󱁾', hl = 'MiniIconsGreen'  },
      lua           = { glyph = icons.directory, hl = 'MiniIconsBlue'   },
      media         = { glyph = '󱧻', hl = 'MiniIconsYellow' },
      mnt           = { glyph = '󰉕', hl = 'MiniIconsYellow' },
      ['mini.nvim'] = { glyph = '󰮟', hl = 'MiniIconsRed'    },
      node_modules  = { glyph = '', hl = 'MiniIconsGreen'  },
      nvim          = { glyph = icons.directory, hl = 'MiniIconsGreen'  },
      opt           = { glyph = '󰮝', hl = 'MiniIconsYellow' },
      pack          = { glyph = '󱁾', hl = 'MiniIconsGreen'  },
      parser        = { glyph = '󱁾', hl = 'MiniIconsGreen'  },
      plugin        = { glyph = '󱁾', hl = 'MiniIconsGreen'  },
      proc          = { glyph = '󱃬', hl = 'MiniIconsYellow' },
      queries       = { glyph = '󱁾', hl = 'MiniIconsGreen'  },
      rplugin       = { glyph = '󱁾', hl = 'MiniIconsGreen'  },
      root          = { glyph = '󰷍', hl = 'MiniIconsYellow' },
      sbin          = { glyph = '󱧻', hl = 'MiniIconsYellow' },
      spell         = { glyph = '󱁾', hl = 'MiniIconsGreen'  },
      src           = { glyph = '󰴊', hl = 'MiniIconsPurple' },
      srv           = { glyph = '󱋤', hl = 'MiniIconsYellow' },
      snippets      = { glyph = '󱁾', hl = 'MiniIconsYellow' },
      syntax        = { glyph = '󱁾', hl = 'MiniIconsGreen'  },
      tmp           = { glyph = '󰪻', hl = 'MiniIconsYellow' },
      test          = { glyph = '󱞋', hl = 'MiniIconsBlue'   },
      tests         = { glyph = '󱞋', hl = 'MiniIconsBlue'   },
      tutor         = { glyph = '󱁾', hl = 'MiniIconsGreen'  },
      usr           = { glyph = '󰮜', hl = 'MiniIconsYellow' },
      var           = { glyph = '󱋤', hl = 'MiniIconsYellow' },
    },
    -- stylua: ignore
    file = {
      ["init.lua"]    = { glyph = "󰢱", hl = "MiniIconsAzure" }, -- default: nf-linux-neovim: 
      README          = { glyph = "󱪘", hl = "MiniIconsYellow" }, -- default: nf-oct-xxx
      ["README.md"]   = { glyph = "󱪘", hl = "MiniIconsYellow" },
      ["README.txt"]  = { glyph = "󱪘", hl = "MiniIconsYellow" },
      ["README.org"]  = { glyph = "󱪘", hl = "MiniIconsYellow" },
      ["README.adoc"] = { glyph = "󱪘", hl = "MiniIconsYellow" },
      ["README.rst"]  = { glyph = "󱪘", hl = "MiniIconsYellow" },
    },

    -- stylua: ignore
    filetype = {
      -- OVERRIDE DEFAULT
      awk      = { glyph = '󰞷', hl = "MiniIconsGrey" },
      bash     = { glyph = '󰞷', hl = "MiniIconsGreen" }, -- default: nf-seti-shell
      csh      = { glyph = '󰞷', hl = 'MiniIconsGrey'   },
      elvish   = { glyph = '󰞷', hl = 'MiniIconsGreen'  },
      fish     = { glyph = '󰈺', hl = "MiniIconsGrey" },
      nu       = { glyph = '󰞷', hl = "MiniIconsPurple" },
      sh       = { glyph = '󰞷', hl = 'MiniIconsGrey'   },
      tcsh     = { glyph = '󰞷', hl = 'MiniIconsAzure'  },
      terminfo = { glyph = '󰞷', hl = 'MiniIconsGrey'   },
      zsh      = { glyph = '󰞷', hl = "MiniIconsGreen" },

      asciidoc = { glyph = '󰧮', hl = 'MiniIconsYellow' },
      rst      = { glyph = '󰧮', hl = 'MiniIconsYellow' },

      hurl     = { glyph = "󰓡", hl = "MiniIconsGreen" }, -- nf-md
    },

    -- stylua: ignore
    extension  = {
      -- Image
      bmp  = { glyph = '󰈟', hl = 'MiniIconsGreen'  },
      gif  = { glyph = '󰈟', hl = 'MiniIconsOrange' },
      jpeg = { glyph = '󰈟', hl = 'MiniIconsOrange' },
      jpg  = { glyph = '󰈟', hl = 'MiniIconsOrange' },
      png  = { glyph = '󰈟', hl = 'MiniIconsPurple' },
      webp = { glyph = '󰈟', hl = 'MiniIconsBlue'   },
      avif = { glyph = '󰈟', hl = 'MiniIconsBlue'   },
      heic = { glyph = '󰈟', hl = 'MiniIconsRed' },
      jxl =  { glyph = '󰈟', hl = 'MiniIconsRed' },
    },

    lsp = {
      ["function"] = { glyph = "󰊕", hl = "MiniIconsAzure" },
    },

    -- Control which extensions will be considered during "file" resolution
    -- use_file_extension = function(ext, file)
    --   return true
    -- end,
  },
}
