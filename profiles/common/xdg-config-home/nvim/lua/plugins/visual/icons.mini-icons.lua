local icons = require("globals").icons

---@type LazySpec
return {
  [1] = "mini.icons",
  optional = true,
  -- cond = not vim.o.termguicolors,
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

    --stylua: ignore
    extension = {
      -- Images (dircolors, nf-md-file_image_outline)
      bmp  = { glyph = "󰺰", hl = "MiniIconsPurple" },
      eps  = { glyph = "󰺰", hl = "MiniIconsPurple" },
      gif  = { glyph = "󰺰", hl = "MiniIconsPurple" },
      jpeg = { glyph = "󰺰", hl = "MiniIconsPurple" },
      jpg  = { glyph = "󰺰", hl = "MiniIconsPurple" },
      png  = { glyph = "󰺰", hl = "MiniIconsPurple" },
      tif  = { glyph = "󰺰", hl = "MiniIconsPurple" },
      tiff = { glyph = "󰺰", hl = "MiniIconsPurple" },
      webp = { glyph = "󰺰", hl = "MiniIconsPurple" },
      avif = { glyph = "󰺰", hl = "MiniIconsPurple" },
      heic = { glyph = "󰺰", hl = "MiniIconsPurple" },
      jxl  = { glyph = "󰺰", hl = "MiniIconsPurple" },
    },

    -- default nf-cod-*
    --stylua: ignore
    lsp = {
      constant      = { glyph = '󰏿', hl = 'MiniIconsOrange' }, -- nf-md-pi
      ['function']  = { glyph = '󰊕', hl = 'MiniIconsAzure'  }, -- nf-md-function
      method        = { glyph = '󰡱', hl = 'MiniIconsAzure'  }, -- nf-md-function_variant
      module        = { glyph = '󰏖', hl = 'MiniIconsPurple' }, -- nf-md-package_variant
      namespace     = { glyph = '󰏗', hl = 'MiniIconsRed'    }, -- nf-md-package_variant_closed
      number        = { glyph = '󰎠', hl = 'MiniIconsOrange' }, -- nf-md-numeric
      object        = { glyph = '󰆧', hl = 'MiniIconsGrey'   }, -- nf-md-cube_outline
      operator      = { glyph = '󱓉', hl = 'MiniIconsCyan'   }, -- nf-md-plus_minus_variant
      package       = { glyph = '󰏖', hl = 'MiniIconsPurple' }, -- nf-md-package_variant
      variable      = { glyph = '󰫧', hl = 'MiniIconsCyan'   }, -- nf-md-variable
    },
  },
  specs = {
    {
      [1] = "nvim-web-devicons",
      optional = true,
      enabled = false,
    },
  },
}
