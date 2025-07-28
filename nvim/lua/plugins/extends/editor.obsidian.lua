-- <https://github.com/obsidian-nvim/obsidian.nvim>

local dir_ = vim.fn.getenv("HOME") .. "/Projects/obsidian.nvim"

---@type LazySpec
return {
  -- [1] = "obsidian-nvim/obsidian.nvim",
  -- version = false,
  dir = dir_,
  enabled = vim.uv.fs_stat(dir_) ~= nil,
  cond = not vim.g.vscode,

  lazy = true,
  cmd = {
    "Obsidian",
  },
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      [1] = "<A-CR>",
      [2] = "<cmd>Obsidian follow_link vsplit<CR>",
      desc = "follow-link-vsplit (obsidian.nvim)",
      ft = "markdown",
    },
    {
      [1] = "<C-A-CR>",
      [2] = "<cmd>Obsidian follow_link hsplit<CR>",
      desc = "follow-link-hsplit (obsidian.nvim)",
      ft = "markdown",
    },
    {
      [1] = "<CR>",
      [2] = "<cmd>Obsidian follow_link<CR>",
      desc = "follow-link (obsidian.nvim)",
      ft = "markdown",
    },
    {
      -- HACK: Open in new tab, since obsidian.nvim does not support this, use defer_fn
      [1] = "<C-CR>",
      [2] = function()
        vim.cmd("Obsidian follow_link hsplit")
        vim.defer_fn(function()
          -- tabedit % 등 시도해봤는데 안먹힘.
          vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<C-w><S-t>", true, false, true),
            "n",
            true
          )
        end, 100) -- at least 50 ms is required <2025-06-10>
      end,
      desc = "follow-link-tab-split (obsidian.nvim)",
      ft = "markdown",
    },
    { [1] = "<leader>mT", [2] = "<cmd>Obsidian today<CR>", desc = "today", ft = "markdown" },
    { [1] = "<leader>mM", [2] = "<cmd>Obsidian tomorrow<CR>", desc = "tomorrow", ft = "markdown" },
    {
      [1] = "<leader>mY",
      [2] = "<cmd>Obsidian yesterday<CR>",
      desc = "yesterday",
      ft = "markdown",
    },
    { [1] = "<leader>mt", [2] = "<cmd>Obsidian template<CR>", desc = "template", ft = "markdown" },
    { [1] = "<leader>mn", [2] = "<cmd>Obsidian rename<CR>", desc = "rename", ft = "markdown" },
    {
      [1] = "<leader>md",
      [2] = "<cmd>Obsidian dailies<CR>",
      desc = "select-dailies",
      ft = "markdown",
    },
    { [1] = "<leader>mg", [2] = "<cmd>Obsidian tagsCR>", desc = "select-tags", ft = "markdown" },
    {
      [1] = "<leader>mb",
      [2] = "<cmd>Obsidian backlinks<CR>",
      desc = "select-backlinks",
      ft = "markdown",
    },
    {
      [1] = "<leader>mX",
      [2] = "<cmd>Obsidian open<CR>",
      desc = "open-in-obsidian",
      ft = "markdown",
    },
    {
      [1] = "<leader>mv",
      [2] = function()
        return require("obsidian").util.toggle_checkbox({ " ", "x" })
      end,
      desc = "toggle-checkbox",
      ft = "markdown",
    },
    {
      [1] = "<leader>mV",
      [2] = function()
        return require("obsidian").util.toggle_checkbox({ "/" })
      end,
      desc = "checkbox-done",
      ft = "markdown",
    },
  },

  opts = {
    ---------------------------
    -- MATCH OBSIDIAN
    ---------------------------
    workspaces = {
      {
        name = "home",
        path = "~/Documents/obsidian/home",
      },
    },
    daily_notes = {
      folder = "dailies",
      date_format = "%Y-%m-%d",
      template = "daily.md",
      alias_format = nil,
    },
    new_notes_location = "notes_subdir",
    notes_subdir = "/",
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M:%S",
      substitutions = {
        ["time:YYYY-MM-DD[T]HH:MM:SSZ"] = function()
          return vim.fn.strftime("%Y-%m-%dT%H:%M:%S%z")
        end,
        ["time:GGGG-[W]WW-E"] = function()
          return vim.fn.strftime("%G-W%V-%u")
        end,
        ["time:GGGG-DDDD"] = function()
          return vim.fn.strftime("%G-%j")
        end,
        ["time:GGGG-[W]WW"] = function()
          return vim.fn.strftime("%G-W%V")
        end,
        ["date:dddd"] = function()
          return vim.fn.strftime("%A")
        end,
      },
    },
    open = {
      -- https://github.com/Vinzent03/obsidian-advanced-uri
      use_advanced_uri = false,
    },
    note_id_func = function(title)
      return title
    end,
    attachments = {
      img_folder = "attachments/",
      img_name_func = function()
        return vim.fn.system("uuid7")
      end,
    },
    disable_frontmatter = true, -- manage frontmatter myself

    -----------------
    -- NEOVIM CONFIG
    -----------------
    legacy_commands = false, -- e.g. ObsidianFollowLink
    mappings = {
      -- override lazyvim's mapping
      ["<leader>sg"] = {
        action = "<cmd>Obsidian search<CR>",
        opts = {
          desc = "ripgrep-search (obsidian)",
        },
      },
      ["<leader>ff"] = {
        action = "<cmd>Obsidian quick_switch<CR>",
        opts = {
          desc = "quick-switch (obsidian)",
        },
      },
      ["<leader><leader>"] = {
        action = "<cmd>Obsidian quick_switch<CR>",
        opts = {
          desc = "quick-switch (obsidian)",
        },
      },
    },
    ui = {
      enable = false,
    },
    completion = {
      nvim_cmp = true,
      blink = false,
    },
    picker = {
      name = "snacks.pick",
    },
    follow_url_func = function(url)
      vim.ui.open(url)
    end,
    follow_img_func = function(img)
      vim.ui.open(img)
    end,
  },
  config = function(_, opts)
    require("obsidian").setup(opts)
  end,
  specs = {
    {
      [1] = "which-key.nvim",
      optional = true,
      opts = {
        icons = {
          rules = {
            {
              plugin = "obsidian.nvim",
              icon = "󰧑", -- nf-md-brain
              color = "purple",
            },
            {
              pattern = "obsidian",
              icon = "󰧑", -- nf-md-brain
              color = "purple",
            },
          },
        },
      },
    },
    {
      [1] = "render-markdown.nvim",
      optional = true,
      opts = {
        preset = "obsidian",
        checkbox = {
          -- use `nf-fa` variant
          enabled = true,
          custom = {
            -- override defaults
            todo = {
              raw = "[☺]",
              rendered = "[☺]",
            },
            in_progress = {
              raw = "[/]",
              -- rendered = " 󰄮 ", -- nf-md-checkbox-blank
              rendered = "  ", -- nf-fa-circle_dot
              highlight = "markdownBold",
              scope_highlight = nil,
            },
            canceled = {
              raw = "[-]",
              rendered = " 󱋭 ",
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            rescheduled = {
              raw = "[<]",
              rendered = " 󰃮 ", --nf-md-calendar
              highlight = "GitSignsAdd",
              scope_highlight = nil,
            },
            scheduled = {
              raw = "[>]",
              rendered = "  ", --nf-fa_mail_forward
              highlight = "DiagnosticVirtualTextInfo",
              scope_highlight = nil,
            },
            important = {
              raw = "[!]",
              rendered = "  ",
              highlight = "DiagnosticVirtualTextWarn",
              scope_highlight = nil,
            },
            question = {
              raw = "[?]",
              rendered = "  ",
              highlight = "DiagnosticVirtualTextWarn",
              scope_highlight = nil,
            },
            star = {
              raw = "[*]",
              rendered = "  ",
              highlight = "DiagnosticVirtualTextWarn",
              scope_highlight = nil,
            },
            note = {
              raw = "[n]",
              rendered = " 󰐃 ",
              highlight = "DiagnosticVirtualTextError",
              scope_highlight = nil,
            },
            location = {
              raw = "[l]",
              rendered = "  ",
              highlight = "CmpItemKindKeyword",
              scope_highlight = nil,
            },
            information = {
              raw = "[i]",
              rendered = "  ",
              highlight = "DiagnosticVirtualTextInfo",
              scope_highlight = nil,
            },
            idea = {
              raw = "[I]",
              rendered = "  ",
              highlight = "DiagnosticVirtualTextWarn",
              scope_highlight = nil,
            },
            amount = {
              raw = "[S]",
              rendered = "  ",
              highlight = "GitSignsAdd",
              scope_highlight = nil,
            },
            pro = {
              raw = "[p]",
              rendered = "  ",
              highlight = "DiagnosticVirtualTextInfo",
              scope_highlight = nil,
            },
            con = {
              raw = "[c]",
              rendered = "  ",
              highlight = "DiagnosticVirtualTextError",
              scope_highlight = nil,
            },
            bookmark = {
              raw = "[b]",
              rendered = "  ",
              highlight = "DiagnosticVirtualTextError",
              scope_highlight = nil,
            },
            quote = {
              raw = '["]',
              rendered = "  ",
              highlight = "RenderMarkdownTodo",
              scope_highlight = nil,
            },
            up = {
              raw = "[u]",
              rendered = " 󰔵 ",
              highlight = "DiagnosticVirtualTextInfo",
              scope_highlight = nil,
            },
            down = {
              raw = "[d]",
              rendered = " 󰔳 ",
              highlight = "DiagnosticVirtualTextError",
              scope_highlight = nil,
            },
            win = {
              raw = "[w]",
              rendered = "  ",
              highlight = "CmpItemKindKeyword",
              scope_highlight = nil,
            },
            key = {
              raw = "[k]",
              rendered = "  ",
              highlight = "DiagnosticVirtualTextWarn",
              scope_highlight = nil,
            },
            fire = {
              raw = "[f]",
              rendered = "  ",
              highlight = "DiagnosticVirtualTextError",
              scope_highlight = nil,
            },
          },
        },
      },
    },
  },
}
