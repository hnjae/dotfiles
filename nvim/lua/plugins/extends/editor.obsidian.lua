-- <https://github.com/obsidian-nvim/obsidian.nvim>

---@type LazySpec
return {
  -- [1] = "obsidian-nvim/obsidian.nvim",
  -- version = false,
  dir = vim.fn.getenv("HOME") .. "/Projects/obsidian.nvim",
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
      [1] = "<C-A-CR>",
      [2] = "<cmd>Obsidian follow_link vsplit<CR>",
      desc = "follow-link-vsplit",
      ft = "markdown",
    },
    -- { [1] = "<CR>", [2] = "<cmd>ObsidianFollowLink<CR>", desc = "follow-link", ft = "markdown" },
    {
      [1] = "<CR>",
      [2] = function()
        return require("obsidian").util.smart_action()
      end,
      desc = "smart-action",
      ft = "markdown",
      expr = true,
    },
    {
      [1] = "<A-CR>",
      [2] = "<cmd>Obsidian follow_link vsplit<CR>",
      desc = "follow-link-vsplit",
      ft = "markdown",
    },
    {
      [1] = "<C-CR>",
      [2] = "<cmd>Obsidian follow_link<CR>",
      desc = "follow-link",
      ft = "markdown",
    },

    -- <leader>t: neotest
    { [1] = "<leader>tt", [2] = "<cmd>Obsidian today<CR>", desc = "today", ft = "markdown" },
    { [1] = "<leader>tM", [2] = "<cmd>Obsidian tomorrow<CR>", desc = "tomorrow", ft = "markdown" },
    {
      [1] = "<leader>ty",
      [2] = "<cmd>Obsidian yesterday<CR>",
      desc = "yesterday",
      ft = "markdown",
    },
    { [1] = "<leader>tT", [2] = "<cmd>Obsidian template<CR>", desc = "template", ft = "markdown" },
    { [1] = "<leader>tn", [2] = "<cmd>Obsidian rename<CR>", desc = "rename", ft = "markdown" },
    {
      [1] = "<leader>td",
      [2] = "<cmd>Obsidian dailies<CR>",
      desc = "select-dailies",
      ft = "markdown",
    },
    { [1] = "<leader>tg", [2] = "<cmd>Obsidian tagsCR>", desc = "select-tags", ft = "markdown" },
    {
      [1] = "<leader>tb",
      [2] = "<cmd>Obsidian backlinks<CR>",
      desc = "select-backlinks",
      ft = "markdown",
    },
    {
      [1] = "<leader>tX",
      [2] = "<cmd>Obsidian open<CR>",
      desc = "open-in-obsidian",
      ft = "markdown",
    },
    -- [2] = "<cmd>ObsidianToggleCheckbox<CR>",
    {
      [1] = "<leader>tv",
      [2] = function()
        return require("obsidian").util.toggle_checkbox({ " ", "x" })
      end,
      desc = "toggle-checkbox",
      ft = "markdown",
    },
    {
      [1] = "<leader>tV",
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
    -- https://github.com/Vinzent03/obsidian-advanced-uri
    use_advanced_uri = false,
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
    -- legacy_commands = false, -- e.g. ObsidianFollowLink
    mappings = {
      -- override lazyvim's mapping
      ["<leader>sg"] = {
        action = "<cmd>ObsidianSearch<CR>",
        opts = {
          desc = "obsidian-search (ripgrep)",
        },
      },
      ["<leader><leader>"] = {
        action = "<cmd>ObsidianQuickSwitch<CR>",
        opts = {
          desc = "obsidian-quick-switch",
        },
      },
      ["<leader>ff"] = {
        action = "<cmd>ObsidianQuickSwitch<CR>",
        opts = {
          desc = "obsidian-quick-switch",
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
